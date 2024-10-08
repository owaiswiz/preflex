module Preflex
  module PreferencesHelper
    extend self

    # PREFLEX_PREFERENCE_JS = File.read(Preferences::Preflex::Engine.root.join("app", "static", "preflex_preference.js"))
    def script_raw(*preference_klasses)
      return ''.html_safe if preference_klasses.empty?

      base = <<~JS
        const CSRF_TOKEN = "#{Preflex::Current.controller_instance.send(:form_authenticity_token)}"
        const UPDATE_PATH = "#{Preflex::Engine.routes.url_helpers.preferences_path}"
        class PreflexPreference {
          constructor(klass, data) {
            this.klass = klass
            this.localStorageKey = `PreflexPreference-${klass}`

            this.data = data
            this.dataLocal = JSON.parse(localStorage.getItem(this.localStorageKey) || '{}')
          }

          get(name) {
            this.ensurePreferenceExists(name)

            const fromServer = this.data[name]
            const fromServerUpdatedAt = this.data[`${name}_updated_at_epoch`] || 0

            const fromLocal = this.dataLocal[name]
            const fromLocalUpdatedAt = this.dataLocal[`${name}_updated_at_epoch`] || 0

            if(fromLocalUpdatedAt > fromServerUpdatedAt) {
              this.updateOnServer(name, fromLocal)
              return fromLocal
            }

            return fromServer
          }

          set(name, value) {
            this.ensurePreferenceExists(name)

            this.dataLocal[name] = value
            this.dataLocal[`${name}_updated_at_epoch`] = Date.now()

            localStorage.setItem(this.localStorageKey, JSON.stringify(this.dataLocal))
            this.updateOnServer(name, value)
            document.dispatchEvent(new CustomEvent('preflex:preference-updated', { detail: { klass: this.klass, name, value } }))
          }

          updateOnServer(name, value) {
            fetch(UPDATE_PATH, {
              method: 'POST',
              headers: {
                "Content-Type": "application/json",
                "X-CSRF-TOKEN": CSRF_TOKEN
              },
              body: JSON.stringify({ klass: this.klass, name, value })
            })
          }

          ensurePreferenceExists(name) {
            if(!this.data.hasOwnProperty(name)) {
              throw new Error(`Preference ${name} was not defined.`)
            }
          }
        }
      JS

      js = [base]
      js += preference_klasses.map do |klass|
        raise 'Expected #{klass} to be a sub-class of Preflex::Preference' unless klass < Preflex::Preference

        "window['#{klass.name}'] = new PreflexPreference('#{klass.name}', #{klass.current.data_for_js});"
      end

      js.join("\n")
    end

    def script_tag(*preference_klasses)
      return ''.html_safe if preference_klasses.empty?

      "<script data-turbo-eval=\"false\">#{script_raw(*preference_klasses)}</script>".html_safe
    end
  end
end

module Preflex
  module PreferencesHelper
    extend self

    # PREFLEX_PREFERENCE_JS = File.read(Preferences::Preflex::Engine.root.join("app", "static", "preflex_preference.js"))
    def script_tag(*preference_klasses)
      return ''.html_safe if preference_klasses.empty?

      base = <<~JS
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
            document.dispatchEvent(new CustomEvent('preflex:preference-updated', { detail: { name, value } }))
          }

          updateOnServer(name, value) {
            console.log('lets updated on server boi', name, value)
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

      "<script>#{js.join("\n")}</script>".html_safe
    end
  end
end

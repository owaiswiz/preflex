class UserPreference < Preflex::Preference
  preference :autoplay,      :boolean, default: true
  preference :playback_rate, :integer, default: 1
  preference :theatre_mode,  :boolean, default: false
  preference :call_sign,     :string,  default: 'Mr.'

  def self.current_owner(controller_instance)
    controller_instance.current_user
  end
end
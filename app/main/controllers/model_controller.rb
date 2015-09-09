class Volt::ModelController

  def call_toast(text, ms: 4000, css_class: nil)
    `toast(text, ms, css_class)`
  end
end
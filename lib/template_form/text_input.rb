require 'tilt'

module TemplateForm
  class TextInput < BaseInput

    private

    def template_file
      if options[:type] == 'password'
        f = detect_template_path 'password_input'
        return f if f
      end
      super
    end

  end
end

module TemplateForm
  class DateInput < TextInput

    private

    def template_file
      Dir["#{Rails.root}/app/forms/#{form_type}/date_input.html.*"].first
    end

  end
end

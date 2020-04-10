module TemplateForm
  class BaseInput

    def template_file
      name = underscore demodulize(self.class.name)
      path = "#{Rails.root}/app/forms/#{form_type}/#{name}.html.*"
      f = Dir[path].first
      raise TemplateForm::MissingTemplateError, "no template found at #{path}" unless File.exist? f
      f
    end

  end
end

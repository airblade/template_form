module TemplateForm
  class BaseInput

    def initialize(builder, attribute_name, options)
      @builder = builder
      @attribute_name = attribute_name

      @form_type = options.delete(:form_type) || builder.form_type

      @label_text = options.delete(:label) || ''
      @label_options = Hash.new { |h,k| h[k] = '' }.update(options.delete(:label_options) || {})

      @hint_text = options.delete(:hint) || ''
      @hint_options = Hash.new { |h,k| h[k] = '' }.update(options.delete(:hint_options) || {})

      data_attributes = (options.delete(:data) || {}).transform_keys { |k| "data-#{k}" }

      @options = options
      @options.merge! data_attributes
      @options[:class] ||= ''
    end


    def render
      template = Tilt.new template_file
      template.render(
        builder,
        attribute_name: attribute_name,

        label_text:     label_text,
        label_options:  label_options,

        hint_text:      hint_text,
        hint_options:   hint_options,

        options:        options,
        errors:         builder.object.errors
      ).html_safe
    end


    private

    attr_reader *%i[
      form_type
      builder
      attribute_name

      label_text
      label_options

      hint_text
      hint_options

      options
    ]


    def template_file
      name = underscore demodulize(self.class.name)  # TemplateForm::TextInput -> text_input
      path = "#{Rails.root}/app/forms/#{form_type}/#{name}.html.*"
      f = Dir[path].first
      raise TemplateForm::MissingTemplateError, "no template found at #{path}" unless File.exist? f
      f
    end

  end
end

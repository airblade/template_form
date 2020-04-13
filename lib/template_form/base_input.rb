require 'pathname'

module TemplateForm
  class BaseInput

    def initialize(builder, attribute_name, options)
      @builder = builder
      @attribute_name = attribute_name

      @form_type = options.delete(:form_type) || builder.form_type

      # Use the `:label` option to override the default label text.
      # Use `label: false` to indicate no label should be shown (check `show_label` in the template).
      @has_label = !(options.has_key?(:label) && options[:label] == false)
      @label_text = options.delete(:label) || ''
      @label_options = Hash.new { |h,k| h[k] = '' }.update(options.delete(:label_options) || {})

      @hint_text = options.delete(:hint) || ''

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

        has_label:      has_label,
        label_text:     label_text,
        label_options:  label_options,

        hint_text:      hint_text,

        options:        options,
        errors:         builder.object.errors
      ).html_safe
    end


    private

    attr_reader *%i[
      form_type
      builder
      attribute_name

      has_label
      label_text
      label_options

      hint_text

      options
    ]


    def template_file
      name = self.class.name.demodulize.underscore  # TemplateForm::TextInput -> text_input
      f = paths(name).map { |p| Pathname.glob(p).first }.detect &:itself
      f or raise TemplateForm::MissingTemplateError, "No template found at: #{paths(name).join ', '}"
    end

    def paths(name)
      locations.map { |p| p / form_type.to_s / "#{name}.html.*" }
    end

    def locations
      [ Pathname.new("#{Rails.root}/app/forms"),
        Pathname.new("#{__dir__}/templates") ]
    end

  end
end

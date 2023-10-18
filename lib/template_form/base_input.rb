require 'pathname'

module TemplateForm
  class BaseInput

    def initialize(builder, attribute_name, options)
      @builder = builder
      @attribute_name = attribute_name
      @view = options.delete(:view)

      @form_type = options.delete(:form_type) || builder.form_type

      # Use the `:label` option to override the default label text.
      # Use `label: false` to indicate no label should be shown (check `has_label` in the template).
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
      template.render(
        builder,
        attribute_name: attribute_name,

        has_label:      has_label,
        label_text:     label_text,
        label_options:  label_options,

        hint_text:      hint_text,

        options:        options,
        errors:         errors,
        view:           view
      ).html_safe
    end


    private

    attr_reader *%i[
      form_type
      builder
      attribute_name
      view

      has_label
      label_text
      label_options

      hint_text

      options
    ]

    def errors
      builder.object ? builder.object.errors : {}
    end

    def template
      Tilt.new template_file
    end

    def template_file
      detect_template_path(template_name) or
        raise TemplateForm::MissingTemplateError,
        "No template found at: #{paths(template_name).join ', '}"
    end

    # TemplateForm::TextInput -> text_input
    def template_name
      @template_name ||= [
        self.class.name.demodulize.underscore,
        options.delete(:with)
      ].compact.join('_')
    end

    def detect_template_path(name)
      paths(name).map { |p| Pathname.glob(p).first }.detect &:itself
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

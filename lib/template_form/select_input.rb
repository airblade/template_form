require 'tilt'

module TemplateForm
  class SelectInput

    OPTION_KEYS = %i[ include_blank prompt index disabled ]

    def initialize(builder, attribute_name, options)
      @builder = builder
      @attribute_name = attribute_name

      @form_type = options.delete(:form_type) || builder.form_type

      @collection = options.delete(:collection).to_a

      @label_text = options.delete(:label) || ''
      @label_options = Hash.new { |h,k| h[k] = '' }.update(options.delete(:label_options) || {})

      @hint_text = options.delete(:hint) || ''
      @hint_options = Hash.new { |h,k| h[k] = '' }.update(options.delete(:hint_options) || {})

      @value_method = options.delete(:value_method) || default_value_method
      @text_method  = options.delete(:text_method)  || default_text_method

      data_attributes = (options.delete(:data) || {}).transform_keys { |k| "data-#{k}" }

      @options = options.select { |k,_| OPTION_KEYS.include? k }

      @html_options = options.reject { |k,_| OPTION_KEYS.include? k }
      @html_options.merge! data_attributes
      @html_options[:class] ||= ''
    end

    def render
      file      = Dir["#{Rails.root}/app/forms/#{form_type}/select_input.html.*"].first
      template  = Tilt.new file
      template.render(
        builder,
        attribute_name: attribute_name,
        collection:     collection,

        label_text:     label_text,
        label_options:  label_options,

        hint_text:      hint_text,
        hint_options:   hint_options,

        options:        options,
        html_options:   html_options,

        errors:         builder.object.errors,

        value_method:   value_method,
        text_method:    text_method
      ).html_safe
    end

    private

    attr_reader *%i[
      form_type
      builder
      attribute_name
      collection

      label_text
      label_options

      hint_text
      hint_options

      options
      html_options

      value_method
      text_method
    ]

    def default_text_method
      case collection.first
      when String then :to_s
      when Array  then :first
      else raise NotImplementedError
      end
    end

    def default_value_method
      case collection.first
      when String then :to_s
      when Array  then :last
      else raise NotImplementedError
      end
    end
  end
end

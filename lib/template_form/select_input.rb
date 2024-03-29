require 'tilt'

module TemplateForm
  class SelectInput < BaseInput

    OPTION_KEYS = %i[ include_blank prompt index disabled selected ]

    def initialize(builder, attribute_name, options)
      @builder = builder
      @attribute_name = attribute_name
      @view = options.delete(:view)

      @form_type = options.delete(:form_type) || builder.form_type

      @collection = options.delete(:collection).to_a

      # Use the `:label` option to override the default label text.
      # Use `label: false` to indicate no label should be shown (check `has_label` in the template).
      @has_label = !(options.has_key?(:label) && options[:label] == false)
      @label_text = options.delete(:label) || ''
      @label_options = Hash.new { |h,k| h[k] = '' }.update(options.delete(:label_options) || {})

      @hint_text = options.delete(:hint) || ''

      @value_method = options.delete(:value_method) || default_value_method
      @text_method  = options.delete(:text_method)  || default_text_method

      data_attributes = (options.delete(:data) || {}).transform_keys { |k| "data-#{k}" }

      @options, @html_options = options.partition { |k,_| OPTION_KEYS.include? k }.map(&:to_h)

      @html_options.merge! data_attributes
      @html_options[:class] ||= ''
    end

    def render
      template.render(
        builder,
        attribute_name: attribute_name,
        collection:     collection,
        view:           view,

        has_label:      has_label,
        label_text:     label_text,
        label_options:  label_options,

        hint_text:      hint_text,

        options:        options,
        html_options:   html_options,

        errors:         errors,

        value_method:   value_method,
        text_method:    text_method
      ).html_safe
    end

    private

    attr_reader *%i[
      collection
      view

      html_options

      value_method
      text_method
    ]

    def default_text_method
      case collection.first
      when String then :to_s
      when Array  then :first
      when nil    then :to_s  # it won't be called because collection is empty
      else raise NotImplementedError, "first collection element is a #{collection.first.class.name}"
      end
    end

    def default_value_method
      case collection.first
      when String then :to_s
      when Array  then :last
      when nil    then :to_s  # it won't be called because collection is empty
      else raise NotImplementedError, "first collection element is a #{collection.first.class.name}"
      end
    end
  end
end

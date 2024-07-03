require 'tilt'

module TemplateForm
  class DateSelectInput < BaseInput

    OPTION_KEYS = %i[
      use_month_numbers
      use_two_digit_numbers
      use_short_month
      add_month_numbers
      use_month_names
      month_format_string
      date_separator
      time_separator
      datetime_separator
      start_year
      end_year
      year_format
      day_format
      discard_day
      discard_month
      discard_year
      order
      include_blank
      default
      selected
      disabled
      prompt
      with_css_classes
      use_hidden
    ]

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

      @options, @html_options = options.partition { |k,_| OPTION_KEYS.include? k }.map(&:to_h)

      @html_options.merge! data_attributes
      @html_options[:class] ||= ''
    end

    def render
      template.render(
        builder,
        attribute_name: attribute_name,
        view:           view,

        has_label:      has_label,
        label_text:     label_text,
        label_options:  label_options,

        hint_text:      hint_text,

        options:        options,
        html_options:   html_options,

        errors:         errors,
      ).html_safe
    end

    private

    attr_reader *%i[
      view
      html_options
      options
    ]

  end
end

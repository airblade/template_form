require 'tilt'

module TemplateForm
  class TextareaInput

    def initialize(builder, attribute_name, options)
      @builder = builder
      @attribute_name = attribute_name
      @options = options

      @options[:class] ||= ''
      @options[:hint_options]  = Hash.new { |h,k| h[k] = '' }.update(@options.fetch(:hint_options, {}))
      @options[:label_options] = Hash.new { |h,k| h[k] = '' }.update(@options.fetch(:label_options, {}))
    end

    def render
      file      = Dir["#{Rails.root}/app/forms/#{form_type}/textarea_input.html.*"].first
      template  = Tilt.new file
      template.render(
        builder,
        attribute_name: attribute_name,
        options:        options,
        errors:         builder.object.errors
      ).html_safe
    end

    private

    attr_reader :builder, :attribute_name, :options

    def form_type
      options.delete(:form_type) || builder.form_type
    end

  end
end

require 'tilt'

module TemplateForm
  class TextInput

    def initialize(builder, attribute_name, options)
      @builder = builder
      @attribute_name = attribute_name
      @options = options

      @options[:class] ||= ''
      @options[:hint_options]  = Hash.new { |h,k| h[k] = '' }.update(@options.fetch(:hint_options, {}))
      @options[:label_options] = Hash.new { |h,k| h[k] = '' }.update(@options.fetch(:label_options, {}))
    end

    def render
      file      = Dir["#{Rails.root}/app/forms/#{form_type}/text_input.html.*"].first
      template  = Tilt.new file
      template.render(
        builder,
        attribute_name: attribute_name,
        options:        options,
        errors:         builder.object.errors,
        data:           data
      ).html_safe
    end

    private

    attr_reader :builder, :attribute_name, :options

    def form_type
      options.delete(:form_type) || builder.form_type
    end

    def data
      return {} unless options.has_key? :data

      attrs = options.delete :data
      attrs.map { |k,v| ["data-#{k}", v] }.to_h
    end

  end
end

require 'tilt'

module TemplateForm
  class SelectInput

    def initialize(builder, attribute_name, options)
      @builder = builder
      @attribute_name = attribute_name
      @options = options

      @options[:class] ||= ''
      @options[:hint_options]  = Hash.new { |h,k| h[k] = '' }.update(@options.fetch(:hint_options, {}))
      @options[:label_options] = Hash.new { |h,k| h[k] = '' }.update(@options.fetch(:label_options, {}))
    end

    def render
      file      = Dir["#{Rails.root}/app/forms/#{form_type}/select_input.html.*"].first
      template  = Tilt.new file
      template.render(
        builder,
        attribute_name: attribute_name,
        options:        options,
        errors:         builder.object.errors,
        collection:     collection,
        label_method:   label_method,
        value_method:   value_method
      ).html_safe
    end

    private

    attr_reader :builder, :attribute_name, :options

    def form_type
      options.delete(:form_type) || builder.form_type
    end

    def collection
      @collection ||= options.delete(:collection)
    end

    def label_method
      # assume collection's elements are arrays
      # options.delete(:label_method) || :first

      return options.delete(:label_method) if options.has_key? :label_method

      case collection.first
      when String then :to_s
      when Array  then :first
      else raise NotImplementedError
      end
    end

    def value_method
      # assume collection's elements are arrays
      # options.delete(:value_method) || :last

      return options.delete(:value_method) if options.has_key? :value_method

      case collection.first
      when String then :to_s
      when Array  then :last
      else raise NotImplementedError
      end
    end

  end
end

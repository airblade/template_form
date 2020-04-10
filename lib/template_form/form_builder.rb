require 'template_form/errors'
require 'template_form/base_input'
require 'template_form/checkbox_input'
require 'template_form/grouped_select_input'
require 'template_form/select_input'
require 'template_form/text_input'
require 'template_form/textarea_input'
require 'template_form/date_input'
require 'template_form/file_input'

module TemplateForm
  class FormBuilder < ActionView::Helpers::FormBuilder

    attr_reader :form_type

    def initialize(*)
      super
      # Do not remove `:form_type` from `options`.  It has to stay so
      # When `fields_for()` instantiates a new form builder for each
      # associated record, the second and subsequent ones have the
      # correct form type.
      @form_type = options[:form_type] || TemplateForm.form_type
    end

    def input(attribute_name, options = {})
      attribute_type = options.delete(:as) ||
        (@object.respond_to?(:type_for_attribute) && @object.type_for_attribute(attribute_name).type) ||
        :string

      input_for(attribute_type).new(self, attribute_name, options).render
    end

    private

    def input_for(attribute_type)
      case attribute_type
      when :string  then TextInput
      when :text    then TextareaInput
      when :date    then DateInput
      when :boolean then CheckboxInput
      when :file    then FileInput
      when :select  then SelectInput
      when :grouped_select then GroupedSelectInput
      end
    end

  end
end


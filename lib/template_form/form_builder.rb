require 'template_form/checkbox_input'
require 'template_form/grouped_select_input'
require 'template_form/select_input'
require 'template_form/text_input'
require 'template_form/textarea_input'

module TemplateForm
  class FormBuilder < ActionView::Helpers::FormBuilder

    attr_reader :form_type

    def initialize(*)
      super
      @form_type = options.delete(:form_type) || TemplateForm.form_type
    end

    def input(attribute_name, options = {})
      attribute_type = options.delete(:as) || (
        column = @object.type_for_attribute attribute_name.to_s
        column.type
      )

      input_for(attribute_type).new(self, attribute_name, options).render
    end

    private

    def input_for(attribute_type)
      case attribute_type
      when :string  then TextInput
      when :text    then TextareaInput
      when :boolean then CheckboxInput
      when :select  then SelectInput
      when :grouped_select then GroupedSelectInput
      end
    end

  end
end


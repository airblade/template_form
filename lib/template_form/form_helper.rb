require 'template_form/form_builder'

module TemplateForm
  module FormHelper

    def template_form_for(record, options = {}, &block)
      options[:builder] = TemplateForm::FormBuilder

      with_template_form_field_error_proc do
        form_for record, options, &block
      end
    end

    private

    def with_template_form_field_error_proc
      default_field_error_proc = ActionView::Base.field_error_proc
      begin
        ActionView::Base.field_error_proc = TemplateForm.field_error_proc
        yield
      ensure
        ActionView::Base.field_error_proc = default_field_error_proc
      end
    end

  end
end

ActiveSupport.on_load(:action_view) do
  include TemplateForm::FormHelper
end

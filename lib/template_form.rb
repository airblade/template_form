require 'template_form/version'
require 'template_form/form_helper'

module TemplateForm

  def self.field_error_proc
    noop_field_error_proc
  end

  def self.form_type
    @form_type || :bulma
  end

  def self.form_type=(val)
    @form_type = val
  end

  private

  def self.noop_field_error_proc
    Proc.new { |html_tag, instance| html_tag }
  end

end

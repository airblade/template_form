require 'template_form/version'
require 'template_form/form_helper'

module TemplateForm

  def self.field_error_proc
    noop_field_error_proc
  end

  def self.form_type
    :bulma
  end

  private

  def self.noop_field_error_proc
    Proc.new { |html_tag, instance| html_tag }
  end

end

# require 'template_form/railtie' if defined?(Rails)


require 'template_form/version'
require 'template_form/form_helper'

module TemplateForm

  def self.field_error_proc
    Proc.new { |html_tag, instance| html_tag }
  end

  def self.form_type
    :bulma
  end

end

# require 'template_form/railtie' if defined?(Rails)


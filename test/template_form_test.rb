require 'test_helper'

class TemplateFormTest < Minitest::Test

  def test_that_it_has_a_version_number
    refute_nil ::TemplateForm::VERSION
  end

  def test_default_form_type
    assert_equal :bulma, TemplateForm.form_type
  end

  def test_form_type
    type = TemplateForm.form_type

    TemplateForm.form_type = :foo
    assert_equal :foo, TemplateForm.form_type

    TemplateForm.form_type = type
  end

  def test_field_error_proc
    assert_equal 'html', TemplateForm.field_error_proc.call('html', Object.new)
  end
end

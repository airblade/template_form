require 'test_helper'

class BaseInputTest < Minitest::Test

  def test_initialize_builder
    builder = Struct.new(:form_type).new(:foo)
    input = TemplateForm::BaseInput.new builder, :attr, {}
    assert_equal builder, input.send(:builder)
  end


  def test_initialize_attribute_name
    builder = Struct.new(:form_type).new(:foo)
    input = TemplateForm::BaseInput.new builder, :attr, {}
    assert_equal :attr, input.send(:attribute_name)
  end


  def test_initialize_form_type
    builder = Struct.new(:form_type).new(:foo)
    input = TemplateForm::BaseInput.new builder, :attr, {}
    assert_equal :foo, input.send(:form_type)

    input = TemplateForm::BaseInput.new builder, :attr, {form_type: :bar}
    assert_equal :bar, input.send(:form_type)
  end


  def test_has_label
    input = TemplateForm::BaseInput.new Object.new, :attr, {form_type: :bar}
    assert input.send(:has_label)

    input = TemplateForm::BaseInput.new Object.new, :attr, {form_type: :bar, label: false}
    refute input.send(:has_label)
  end


  def test_label_text
    input = TemplateForm::BaseInput.new Object.new, :attr, {form_type: :bar}
    assert_equal '', input.send(:label_text)

    input = TemplateForm::BaseInput.new Object.new, :attr, {form_type: :bar, label: 'Foo'}
    assert_equal 'Foo', input.send(:label_text)
  end


  def test_label_options
    input = TemplateForm::BaseInput.new Object.new, :attr, {form_type: :bar}
    assert_equal({}, input.send(:label_options))

    input = TemplateForm::BaseInput.new Object.new, :attr, {form_type: :bar, label_options: {foo: 153}}
    assert_equal({foo: 153}, input.send(:label_options))
    refute input.send(:options).has_key?(:label_options)
  end


  def test_hint
    input = TemplateForm::BaseInput.new Object.new, :attr, {form_type: :bar}
    assert_equal '', input.send(:hint_text)

    input = TemplateForm::BaseInput.new Object.new, :attr, {form_type: :bar, hint: 'Foo'}
    assert_equal 'Foo', input.send(:hint_text)
  end


  def test_data_attributes
    input = TemplateForm::BaseInput.new Object.new, :attr, {form_type: :bar}
    refute input.send(:options).keys.any? {|k| k.to_s.start_with? 'data-' }

    input = TemplateForm::BaseInput.new Object.new, :attr, {form_type: :bar, data: {foo: 153}}
    assert_equal 153, input.send(:options)['data-foo']
    refute input.send(:options).has_key?(:data)
  end


  def test_options
    input = TemplateForm::BaseInput.new Object.new, :attr, {form_type: :bar, foo: 153}
    assert_equal 153, input.send(:options)[:foo]
    assert_equal '',  input.send(:options)[:class]
  end


  def test_errors
    builder_without_object = Struct.new(:object).new
    input = TemplateForm::BaseInput.new builder_without_object, :attr, {form_type: :bar}
    assert_equal({}, input.send(:errors))

    errors = Object.new
    builder_with_object = Struct.new(:object).new Struct.new(:errors).new(errors)
    input = TemplateForm::BaseInput.new builder_with_object, :attr, {form_type: :bar}
    assert_equal errors, input.send(:errors)
  end


  def test_template_file_missing
    input = TemplateForm::BaseInput.new Object.new, :attr, {form_type: :bar}
    error = assert_raises TemplateForm::MissingTemplateError do
      input.send :template_file
    end
    assert_match /No template found at:/, error.message
  end


  def test_template_file_in_app
    input = TemplateForm::BaseInput.new Object.new, :attr, {form_type: :some_form_type}
    assert_equal Pathname.new(__dir__) + 'app/forms/some_form_type/base_input.html.erb',
      input.send(:template_file)
  end


  def test_template_bundled
    input = TemplateForm::TextInput.new Object.new, :attr, {form_type: :bulma}
    assert_equal Pathname.new(__dir__) + '../lib/template_form/templates/bulma/text_input.html.erb',
      input.send(:template_file)
  end


  def test_render
    view = Object.new
    builder_without_object = Struct.new(:object).new
    input = TemplateForm::BaseInput.new builder_without_object, :attr, {
      form_type: :bar,
      label: 'Label',
      label_options: {foo: 153},
      hint: 'Hint',
      class: 'bar',
      view: view
    }

    mock_template = Minitest::Mock.new
    mock_template.expect :render, '', [
      input.send(:builder),
      {
        attribute_name: :attr,
        has_label: true,
        label_text: 'Label',
        label_options: {foo: 153},
        hint_text: 'Hint',
        options: {class: 'bar'},
        errors: {},
        view: view
      }
    ]

    input.stub :template, mock_template do
      output = input.render
    end
  end

end

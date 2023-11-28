require 'test_helper'

class FormBuilderTest < Minitest::Test

  def setup
    @template = Object.new.tap do |template|
      template.extend ActionView::Helpers::FormHelper
      template.extend ActionView::Helpers::FormOptionsHelper
      # template.extend ActionView::Helpers::TagHelper
      # template.extend ActionView::Context
    end
  end


  def test_initialize
    builder = TemplateForm::FormBuilder.new(:foo, Object.new, @template, {})
    assert_equal TemplateForm.form_type, builder.form_type

    builder = TemplateForm::FormBuilder.new(:foo, Object.new, @template, {form_type: :bar})
    assert_equal :bar, builder.form_type
  end


  class TestFormBuilder < TemplateForm::FormBuilder
    attr_reader :attribute_type

    def input_for(attribute_type)
      @attribute_type = attribute_type
      Struct.new(:builder, :attribute_name, :options) do
        def render
          self
        end
      end
    end
  end


  def test_input
    builder = TestFormBuilder.new(nil, nil, @template, {})
    input = builder.input :foo

    assert_equal :string, builder.attribute_type
    assert_equal builder, input.builder
    assert_equal :foo,    input.attribute_name
    assert_equal({},      input.options)
  end


  def test_input_as
    builder = TestFormBuilder.new(nil, nil, @template, {})
    builder.input :foo, as: :select

    assert_equal :select, builder.attribute_type
  end


  def test_input_type_for_attribute
    object = Object.new
    def object.type_for_attribute(*)
      Struct.new(:type).new(:date)
    end

    builder = TestFormBuilder.new(nil, object, @template, {})
    input = builder.input :foo

    assert_equal :date, input.builder.attribute_type
  end


  def test_input_options
    view = Object.new
    builder = TestFormBuilder.new(nil, nil, @template, {view: view})
    input = builder.input :foo, as: :select, bar: 153

    assert_equal({bar: 153, view: view}, input.options)
    refute input.options.has_key?(:as)
  end


  def test_input_password
    builder = TestFormBuilder.new(nil, nil, @template, {})

    input = builder.input :password
    assert_equal 'password', input.options[:type]

    input = builder.input :password_confirmation
    assert_equal 'password', input.options[:type]

    input = builder.input :password_confirmation, type: :foo
    assert_equal :foo, input.options[:type]
  end

end

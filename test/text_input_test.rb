require 'test_helper'

class TextInputTest < Minitest::Test

  def setup
    @template = Object.new.tap do |template|
      template.extend ActionView::Helpers::FormHelper
      template.extend ActionView::Helpers::FormOptionsHelper
      template.extend ActionView::Helpers::FormTagHelper
      # template.extend ActionView::Helpers::TagHelper
      # template.extend ActionView::Context
    end
  end


  def test_input_string_no_model
    builder = TemplateForm::FormBuilder.new(:signup, nil, @template, {})
    expected = <<-END
      <div class="field ">
        <label class=" label" for="signup_email">Email</label>
        <div class="control ">
          <input class=" input" type="text" name="signup[email]" id="signup_email" />
        </div>
      </div>
    END
    assert_dom_equal expected, builder.input(:email)
  end

end

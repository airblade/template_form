$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'template_form'

require 'minitest/autorun'


module Rails
  def self.root
    __dir__
  end
end


# Not to be confused with Rails 2.3's assert_dom_equal method.
def assert_dom_equal(expected, actual)
  assert_equal expected.squish, actual.squish
end

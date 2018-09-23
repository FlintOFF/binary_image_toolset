require 'test_helper'

class BinaryImageToolsetTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::BinaryImageToolset::VERSION
  end
end

require 'test_helper'

class ApplicationHelperTest < ActionView::TestCase
  test 'converts markdown' do

    source = '**hello** world'
    result = markdown(source)
    expected = "<p><strong>hello</strong> world</p>\n"

    assert_equal expected, result

    assert result.html_safe?

  end
end

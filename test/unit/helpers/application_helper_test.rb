require 'test_helper'

class ApplicationHelperTest < ActionView::TestCase
  test 'scopes the locale' do
    I18n.locale = :en
    called = false

    scope_locale :pirate do
      assert_equal :pirate, I18n.locale
      called = true
    end

    assert_equal :en, I18n.locale
    assert called
  end
  
  test 'converts markdown' do

    source = '**hello** world'
    result = markdown(source)
    expected = "<p><strong>hello</strong> world</p>\n"

    assert_equal expected, result

    assert result.html_safe?

  end
end

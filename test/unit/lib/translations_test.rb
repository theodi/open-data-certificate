require_relative '../../test_helper'

require 'translations'

class TranslationsTest < ActiveSupport::TestCase

  test "merge two yaml files" do
    run = false
    path = Rails.root + "fixtures/translations"
    Tempfile.open('output.yml') do |output|
      run = true
      Translations::Merge.merge(path + "a.yml", path + "b.yml", output.path)
      assert_equal File.read(path + "expected.yml"), File.read(output.path)
    end
    assert run, "yaml merge block didn't run"
  end

end

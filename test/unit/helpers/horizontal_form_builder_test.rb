require 'test_helper'

class HorizontalHelperTest < ActionView::TestCase

  test "label has control-label class" do
    form_builder = HorizontalFormBuilder.new(:model,{},self,{},nil)
    form_label = form_builder.label(:param)

    assert form_label.include? 'class="control-label"'
  end

  test "label class is appended with .control-label" do

    form_builder = HorizontalFormBuilder.new(:model,{},self,{},nil)
    form_label = form_builder.label(:param, :class => 'foo bar')

    assert form_label.include? 'class="foo bar control-label"'

  end

end

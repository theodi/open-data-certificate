# This is to help build horizontal bootstrap forms:
#   http://twitter.github.io/bootstrap/base-css.html#forms
# 
# All it does just now is add a class .control-label to the
# <label> element. 
#
class HorizontalFormBuilder < ActionView::Helpers::FormBuilder

  def label(attribute, options={})

    # set the class to control label
    options[:class] = if options[:class].blank?
      'control-label'
    else

      # append control label class
      options[:class] + ' control-label'
    end

    super

  end

end
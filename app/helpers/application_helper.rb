module ApplicationHelper
  include Utils::BaseConfig
  class CodeRayify < Redcarpet::Render::HTML
    def block_code(code, language)
      valid_language?(language) ? CodeRay.scan(code, language).div(css: :class) : CodeRay.scan(code, "text").div
    end

    private 

    def valid_language?(lang)
      return false if lang.blank?
      valid_languages = CodeRay::Scanners.list
      valid_languages.include? lang.to_sym
    end
  end

  def markdown(text)
    coderayified = CodeRayify.new(:filter_html => false,
                                  :hard_wrap => true)
    options = {
      :fenced_code_blocks => true,
      :no_intra_emphasis => true,
      :autolink => true,
      :strikethrough => true,
      :lax_html_blocks => true,
      :superscript => true,
      :tables => true,
      :highlight => true,
      :quote => true,
      :filter_html => false,
      :safe_links_only => true
    }
    markdown_to_html = Redcarpet::Markdown.new(coderayified, options)
    markdown_to_html.render(text).html_safe
  end

  def greet
    now = Time.now
    today = Date.today.to_time

    morning = today.beginning_of_day
    noon = today.noon
    evening = today.change( hour: 17 )
    night = today.change( hour: 20 )
    tomorrow = today.tomorrow

    if (morning..noon).cover? now
      'Good Morning'
    elsif (noon..evening).cover? now 
      'Good Afternoon'
    elsif (evening..night).cover? now
      'Good Evening'
    elsif (night..tomorrow).cover? now
      'Good Night'
    end
  end
end

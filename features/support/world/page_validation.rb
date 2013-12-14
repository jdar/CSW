module PageValidationModule

  def assert_page_html_contains(htm)
    assert(page.html.include?(htm), "html not found: #{htm}")
  end

  def assert_page_has_text(text)
    assert(page.has_text?(text), "text not found: #{text}")
  end

  def assert_page_has_no_text(text)
    assert(page.has_no_text?(text), "text should not be present: #{text}")
  end

  def assert_page_has_link(title)
    assert(page.has_link?(title), "link not found: #{title}")
  end

  def assert_page_has_no_link(title)
    assert(page.has_no_link?(title), "link should not be present #{title}")
  end

  def assert_current_path(path, optional_text=nil)
    current_path.must_equal(path)
    assert_page_has_text(optional_text) if optional_text
    if optional_text
      assert(page.has_text?(text), "text not found: #{text}")
    end
  end

end

World(PageValidationModule)

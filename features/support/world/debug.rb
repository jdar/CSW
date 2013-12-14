module DebugModule

  def log_page
    if page
      Rails.logger.debug("page status_code:  #{page.status_code}")
      Rails.logger.debug("page current_host: #{page.current_host}")
      Rails.logger.debug("page current_path: #{page.current_path}")
      Rails.logger.debug("page current_url:  #{page.current_url}")
      Rails.logger.debug("page body:\n #{page.body} \n")
    end
  end

  def log_public_methods(context)
    if context.to_s.downcase == 'cucumber'
      self.public_methods.sort.each { | m | Rails.logger.debug "cucumber_method: #{m}" }
    elsif context.to_s.downcase == 'page'
      page.public_methods.sort.each { | m | Rails.logger.debug "page_method: #{m}" }
    end
  end

end

World(DebugModule)

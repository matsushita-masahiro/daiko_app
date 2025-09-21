class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  before_action :record_page_view, unless: :admin_request?

  protected

  def authenticate_admin
    authenticate_or_request_with_http_basic('Admin Area') do |username, password|
      username == ENV['ADMIN_USERNAME'] && password == ENV['ADMIN_PASSWORD']
    end
  end

  private

  def record_page_view
    return if bot_request? || request.xhr?
    
    begin
      PageView.record_visit(request)
    rescue => e
      Rails.logger.error "Failed to record page view: #{e.message}"
    end
  end

  def bot_request?
    user_agent = request.user_agent.to_s.downcase
    bot_patterns = [
      'bot', 'crawler', 'spider', 'scraper', 'facebookexternalhit',
      'twitterbot', 'linkedinbot', 'whatsapp', 'telegrambot',
      'googlebot', 'bingbot', 'yandexbot', 'baiduspider',
      'slackbot', 'discordbot', 'applebot', 'duckduckbot'
    ]
    
    bot_patterns.any? { |pattern| user_agent.include?(pattern) }
  end

  def admin_request?
    request.path.start_with?('/admin')
  end
end

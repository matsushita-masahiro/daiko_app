class SitemapsController < ApplicationController
  def index
    @urls = [
      {
        loc: root_url,
        lastmod: Date.current,
        changefreq: 'daily',
        priority: 1.0
      },
      {
        loc: new_inquiry_url,
        lastmod: Date.current,
        changefreq: 'monthly',
        priority: 0.8
      }
    ]
    
    respond_to do |format|
      format.xml { render layout: false }
    end
  end

  def robots
    respond_to do |format|
      format.text { render layout: false }
    end
  end
end
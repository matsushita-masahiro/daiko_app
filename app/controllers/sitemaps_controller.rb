class SitemapsController < ApplicationController
  def index
    @base_url = "https://神戸運転代行.com"
    
    respond_to do |format|
      format.xml
    end
  end

  def robots
    respond_to do |format|
      format.text do
        render plain: File.read(Rails.root.join('public', 'robots.txt'))
      end
    end
  end
end

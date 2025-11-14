xml.instruct!
xml.urlset xmlns: "http://www.sitemaps.org/schemas/sitemap/0.9" do
  # トップページ
  xml.url do
    xml.loc @base_url
    xml.lastmod Time.current.to_date
    xml.changefreq "daily"
    xml.priority 1.0
  end
  
  # 利用規約
  xml.url do
    xml.loc "#{@base_url}/terms"
    xml.lastmod Time.current.to_date
    xml.changefreq "monthly"
    xml.priority 0.5
  end
  
  # お問い合わせ
  xml.url do
    xml.loc "#{@base_url}/inquiries/new"
    xml.lastmod Time.current.to_date
    xml.changefreq "monthly"
    xml.priority 0.7
  end
end

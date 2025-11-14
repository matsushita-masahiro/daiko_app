module ApplicationHelper
  # お問い合わせ区分の日本語変換
  def inquiry_type_label(inquiry_type)
    case inquiry_type
    when 'dependency'
      'ご依頼'
    when 'company_info'
      '弊社について'
    when 'other'
      'その他ご質問'
    else
      inquiry_type
    end
  end

  # SEO用のメタタグ設定
  def page_title(title = nil)
    base_title = "神戸運転代行.com - 神戸・三宮の安い・安全なタクシー代行サービス | ヒロクル"
    title ? "#{title} | #{base_title}" : base_title
  end

  def page_description(description = nil)
    default_description = "神戸市・三宮エリアで24時間対応の運転代行サービス。安い料金で安全にお送りします。ヒロクルの信頼できるタクシー代行で、お酒を飲んだ後も安心してお帰りいただけます。"
    description || default_description
  end

  def page_keywords(keywords = nil)
    default_keywords = "神戸,三宮,ヒロクル,代行,安い,安全,タクシー,運転代行,神戸市,24時間,料金,予約"
    keywords ? "#{keywords},#{default_keywords}" : default_keywords
  end

  def og_title(title = nil)
    title || "神戸・三宮の安い・安全な運転代行サービス | ヒロクル"
  end

  def og_description(description = nil)
    page_description(description)
  end

  def og_image(image = nil)
    return image if image.present?
    
    # 既存のアイコンファイルを使用
    "#{request.base_url}/icon.png"
  end

  # 構造化データ（JSON-LD）の生成
  def structured_data_json
    {
      "@context": "https://schema.org",
      "@type": "LocalBusiness",
      "name": "ヒロクル - 神戸運転代行サービス",
      "description": page_description,
      "url": request.base_url,
      "telephone": ENV['COMPANY_PHONE'],
      "address": {
        "@type": "PostalAddress",
        "addressLocality": "神戸市",
        "addressRegion": "兵庫県",
        "addressCountry": "JP"
      },
      "geo": {
        "@type": "GeoCoordinates",
        "latitude": "34.6937",
        "longitude": "135.5023"
      },
      "openingHours": "Mo-Su 00:00-23:59",
      "priceRange": "¥¥",
      "serviceArea": {
        "@type": "City",
        "name": "神戸市"
      },
      "hasOfferCatalog": {
        "@type": "OfferCatalog",
        "name": "運転代行サービス",
        "itemListElement": [
          {
            "@type": "Offer",
            "itemOffered": {
              "@type": "Service",
              "name": "24時間運転代行サービス",
              "description": "神戸市・三宮エリアの安全で安い運転代行サービス"
            }
          }
        ]
      }
    }.to_json.html_safe
  end

  # FAQ構造化データ
  def faq_structured_data_json
    {
      "@context": "https://schema.org",
      "@type": "FAQPage",
      "mainEntity": [
        {
          "@type": "Question",
          "name": "料金はどのように計算されますか？",
          "acceptedAnswer": {
            "@type": "Answer",
            "text": "距離に応じた基本料金制となっております。事前にお見積もりをお伝えし、追加料金は一切いただきません。"
          }
        },
        {
          "@type": "Question",
          "name": "予約は必要ですか？",
          "acceptedAnswer": {
            "@type": "Answer",
            "text": "予約なしでもご利用いただけますが、お待たせする場合がございます。事前のご予約をおすすめします。"
          }
        },
        {
          "@type": "Question",
          "name": "支払い方法は？",
          "acceptedAnswer": {
            "@type": "Answer",
            "text": "現金、クレジットカード、電子マネーでのお支払いが可能です。"
          }
        }
      ]
    }.to_json.html_safe
  end

  # パンくずリスト構造化データ
  def breadcrumb_structured_data_json(items)
    {
      "@context": "https://schema.org",
      "@type": "BreadcrumbList",
      "itemListElement": items.map.with_index do |item, index|
        {
          "@type": "ListItem",
          "position": index + 1,
          "name": item[:name],
          "item": item[:url]
        }
      end
    }.to_json.html_safe
  end
end
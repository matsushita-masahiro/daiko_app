class UserLocation < ApplicationRecord
  # バリデーション
  validates :latitude, presence: true, numericality: { greater_than_or_equal_to: -90, less_than_or_equal_to: 90 }
  validates :longitude, presence: true, numericality: { greater_than_or_equal_to: -180, less_than_or_equal_to: 180 }
  validates :ip_address, presence: true
  validates :visited_at, presence: true

  # スコープ
  scope :today, -> { where(visited_at: Date.current.beginning_of_day..Date.current.end_of_day) }
  scope :this_week, -> { where(visited_at: 1.week.ago.beginning_of_day..Date.current.end_of_day) }
  scope :this_month, -> { where(visited_at: 1.month.ago.beginning_of_day..Date.current.end_of_day) }
  scope :recent, ->(limit = 10) { order(visited_at: :desc).limit(limit) }

  # サービスエリアの定義（神戸市全域、芦屋市、西宮市、尼崎市）
  # 北緯: 34.6°〜34.8°, 東経: 135.0°〜135.5°
  SERVICE_AREA_LAT_MIN = 34.6
  SERVICE_AREA_LAT_MAX = 34.8
  SERVICE_AREA_LON_MIN = 135.0
  SERVICE_AREA_LON_MAX = 135.5

  scope :within_service_area, -> {
    where(
      latitude: SERVICE_AREA_LAT_MIN..SERVICE_AREA_LAT_MAX,
      longitude: SERVICE_AREA_LON_MIN..SERVICE_AREA_LON_MAX
    )
  }

  scope :outside_service_area, -> {
    where.not(
      latitude: SERVICE_AREA_LAT_MIN..SERVICE_AREA_LAT_MAX,
      longitude: SERVICE_AREA_LON_MIN..SERVICE_AREA_LON_MAX
    )
  }

  # クラスメソッド
  def self.record_location(request, latitude, longitude)
    create!(
      latitude: latitude,
      longitude: longitude,
      ip_address: request.remote_ip,
      user_agent: request.user_agent,
      referer: request.referer,
      visited_at: Time.current
    )
  end

  def self.anonymize_old_records
    where('visited_at < ? AND anonymized_at IS NULL', 30.days.ago).find_each do |location|
      location.update(
        ip_address: 'anonymized',
        anonymized_at: Time.current
      )
    end
  end

  # インスタンスメソッド
  def within_service_area?
    latitude.between?(SERVICE_AREA_LAT_MIN, SERVICE_AREA_LAT_MAX) &&
      longitude.between?(SERVICE_AREA_LON_MIN, SERVICE_AREA_LON_MAX)
  end

  def approximate_address
    # 簡易的な住所表示（実際の逆ジオコーディングは外部APIが必要）
    if within_service_area?
      "神戸市周辺（サービスエリア内）"
    else
      "サービスエリア外"
    end
  end
end

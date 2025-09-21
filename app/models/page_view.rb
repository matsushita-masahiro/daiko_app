class PageView < ApplicationRecord
  validates :ip_address, presence: true
  validates :visited_at, presence: true

  scope :today, -> { where(visited_at: Date.current.beginning_of_day..Date.current.end_of_day) }
  scope :this_week, -> { where(visited_at: 1.week.ago.beginning_of_day..Date.current.end_of_day) }
  scope :this_month, -> { where(visited_at: 1.month.ago.beginning_of_day..Date.current.end_of_day) }
  scope :unique_visitors, -> { select(:ip_address).distinct }

  def self.record_visit(request)
    create!(
      ip_address: request.remote_ip,
      user_agent: request.user_agent,
      page_path: request.path,
      visited_at: Time.current
    )
  end
end

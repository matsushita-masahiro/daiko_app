class Admin::DashboardController < Admin::BaseController
  def index
    # お問い合わせ統計
    @total_inquiries = Inquiry.count
    @unanswered_inquiries = Inquiry.left_joins(:answers).where(answers: { id: nil }).count
    @answered_inquiries = @total_inquiries - @unanswered_inquiries

    # アクセス統計
    @total_page_views = PageView.count
    @unique_visitors = PageView.unique_visitors.count
    @today_page_views = PageView.today.count
    @today_unique_visitors = PageView.today.unique_visitors.count
    @this_week_page_views = PageView.this_week.count
    @this_month_page_views = PageView.this_month.count

    # 位置情報統計
    @total_locations = UserLocation.count
    @locations_within_service_area = UserLocation.within_service_area.count
    @locations_outside_service_area = UserLocation.outside_service_area.count
    @service_area_percentage = @total_locations > 0 ? (@locations_within_service_area.to_f / @total_locations * 100).round(1) : 0
    
    @today_locations = UserLocation.today.count
    @this_week_locations = UserLocation.this_week.count
    @this_month_locations = UserLocation.this_month.count
    
    @recent_locations = UserLocation.recent(10)
  end
end
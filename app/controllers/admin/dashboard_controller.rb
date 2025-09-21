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
  end
end
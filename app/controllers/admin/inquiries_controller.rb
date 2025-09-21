class Admin::InquiriesController < Admin::BaseController
  before_action :set_inquiry, only: [:show]

  def index
    @inquiries = Inquiry.includes(:answers).order(created_at: :desc).page(params[:page]).per(10)
  end

  def show
  end

  private

  def set_inquiry
    @inquiry = Inquiry.find(params[:id])
  end
end
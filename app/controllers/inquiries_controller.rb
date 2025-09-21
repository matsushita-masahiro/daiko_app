class InquiriesController < ApplicationController
  before_action :set_inquiry, only: [:show]
  
  def index
    @inquiries = Inquiry.recent.includes(:answers)
  end

  def show
  end

  def new
    @inquiry = session[:inquiry_params] ? Inquiry.new(session[:inquiry_params]) : Inquiry.new
  end

  def confirm
    @inquiry = Inquiry.new(inquiry_params)
    
    if @inquiry.valid?
      session[:inquiry_params] = inquiry_params.to_h
      render :confirm
    else
      render :new, status: :unprocessable_entity
    end
  end

  def back_to_form
    redirect_to new_inquiry_path
  end

  def create
    # セッションからデータを取得
    unless session[:inquiry_params]
      redirect_to new_inquiry_path, alert: 'セッションが無効です。もう一度入力してください。'
      return
    end

    @inquiry = Inquiry.new(session[:inquiry_params])
    
    if @inquiry.save
      # セッションクリア
      session.delete(:inquiry_params)
      
      # お客様向け受付メール送信
      InquiryMailer.inquiry_received(@inquiry).deliver_now
      
      # 管理者向け通知メール送信
      InquiryMailer.inquiry_notification(@inquiry).deliver_now
      
      redirect_to root_path, notice: 'お問い合わせを受け付けました。'
    else
      render :confirm, status: :unprocessable_entity
    end
  end
  
  private
  
  def set_inquiry
    @inquiry = Inquiry.find(params[:id])
  end
  
  def inquiry_params
    params.require(:inquiry).permit(:name, :email, :furigana, :inquiry_type, :phone, :address, :content)
  end
end

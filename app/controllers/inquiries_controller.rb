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
    Rails.logger.debug "=== INQUIRY PARAMS DEBUG ==="
    Rails.logger.debug "inquiry_params: #{inquiry_params.inspect}"
    Rails.logger.debug "inquiry_type value: #{inquiry_params[:inquiry_type].inspect}"
    
    @inquiry = Inquiry.new(inquiry_params)
    
    Rails.logger.debug "inquiry object inquiry_type: #{@inquiry.inquiry_type.inspect}"
    Rails.logger.debug "inquiry object attributes: #{@inquiry.attributes.inspect}"
    
    if @inquiry.valid?
      session[:inquiry_params] = inquiry_params.to_h
      render :confirm
    else
      Rails.logger.debug "inquiry validation errors: #{@inquiry.errors.full_messages}"
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

    Rails.logger.debug "=== CREATE INQUIRY DEBUG ==="
    Rails.logger.debug "session inquiry_params: #{session[:inquiry_params].inspect}"
    
    @inquiry = Inquiry.new(session[:inquiry_params])
    
    Rails.logger.debug "inquiry object before save: #{@inquiry.attributes.inspect}"
    Rails.logger.debug "inquiry_type before save: #{@inquiry.inquiry_type.inspect}"
    
    if @inquiry.save
      Rails.logger.debug "inquiry saved successfully: #{@inquiry.attributes.inspect}"
      
      # セッションクリア
      session.delete(:inquiry_params)
      
      # お客様向け受付メール送信
      InquiryMailer.inquiry_received(@inquiry).deliver_now
      
      # 管理者向け通知メール送信
      InquiryMailer.inquiry_notification(@inquiry).deliver_now
      
      redirect_to root_path, notice: 'お問い合わせを受け付けました。'
    else
      Rails.logger.debug "inquiry save failed: #{@inquiry.errors.full_messages}"
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

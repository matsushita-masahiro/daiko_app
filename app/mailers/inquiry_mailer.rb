class InquiryMailer < ApplicationMailer
  default from: -> { ENV['ADMIN_EMAIL'] }

  # お問い合わせ受付メール（お客様向け）
  def inquiry_received(inquiry)
    @inquiry = inquiry
    @company_name = ENV['COMPANY_NAME']
    @company_phone = ENV['COMPANY_PHONE']
    
    mail(
      to: @inquiry.email,
      subject: "【#{@company_name}】お問い合わせを受け付けました"
    )
  end

  # お問い合わせ通知メール（管理者向け）
  def inquiry_notification(inquiry)
    @inquiry = inquiry
    @company_name = ENV['COMPANY_NAME']
    
    mail(
      to: ENV['ADMIN_EMAIL'],
      subject: "【#{@company_name}】新しいお問い合わせが届きました"
    )
  end

  # 回答送信メール（お客様向け）
  def answer_sent(inquiry, answer)
    @inquiry = inquiry
    @answer = answer
    @company_name = ENV['COMPANY_NAME']
    @company_phone = ENV['COMPANY_PHONE']
    
    mail(
      to: @inquiry.email,
      subject: "【#{@company_name}】お問い合わせへの回答"
    )
  end
end

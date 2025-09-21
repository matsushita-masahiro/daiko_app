# Preview all emails at http://localhost:3000/rails/mailers/inquiry_mailer
class InquiryMailerPreview < ActionMailer::Preview
  # Preview this email at http://localhost:3000/rails/mailers/inquiry_mailer/inquiry_received
  def inquiry_received
    InquiryMailer.inquiry_received
  end

  # Preview this email at http://localhost:3000/rails/mailers/inquiry_mailer/answer_sent
  def answer_sent
    InquiryMailer.answer_sent
  end
end

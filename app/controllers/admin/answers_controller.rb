class Admin::AnswersController < Admin::BaseController
  before_action :set_inquiry

  def new
    @answer = @inquiry.answers.build
  end

  def create
    @answer = @inquiry.answers.build(answer_params)
    @answer.admin_name = 'Administrator' # 管理者名を設定

    if @answer.valid?
      begin
        ActiveRecord::Base.transaction do
          @answer.save!
          # お客様への回答メール送信
          InquiryMailer.answer_sent(@inquiry, @answer).deliver_now
        end
        redirect_to admin_inquiries_path, notice: '回答を送信しました。'
      rescue => e
        Rails.logger.error "Failed to send answer email: #{e.message}"
        # トランザクションがロールバックされるため、回答は保存されない
        @answer.errors.add(:base, 'メール送信に失敗しました。もう一度お試しください。')
        render :new, status: :unprocessable_entity
      end
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def set_inquiry
    @inquiry = Inquiry.find(params[:inquiry_id])
  end

  def answer_params
    params.require(:answer).permit(:content)
  end
end
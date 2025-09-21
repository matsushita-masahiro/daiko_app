class AnswersController < ApplicationController
  before_action :set_inquiry
  before_action :set_answer, only: [:show]
  
  def new
    @answer = @inquiry.answers.build
  end

  def create
    @answer = @inquiry.answers.build(answer_params)
    
    if @answer.save
      # お客様向け回答メール送信
      InquiryMailer.answer_sent(@inquiry, @answer).deliver_now
      
      redirect_to inquiry_path(@inquiry), notice: '回答を送信しました。お客様にメールをお送りしました。'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
  end
  
  private
  
  def set_inquiry
    @inquiry = Inquiry.find(params[:inquiry_id])
  end
  
  def set_answer
    @answer = @inquiry.answers.find(params[:id])
  end
  
  def answer_params
    params.require(:answer).permit(:content, :admin_name)
  end
end

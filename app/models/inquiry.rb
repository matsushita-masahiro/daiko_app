class Inquiry < ApplicationRecord
  has_many :answers, dependent: :destroy
  
  validates :name, presence: true
  validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :furigana, presence: true
  validates :inquiry_type, presence: true
  validates :phone, presence: true
  validates :content, presence: true
  
  enum :inquiry_type, {
    dependency: 0,
    company_info: 1,
    other: 2
  }
  
  # 日本語表示用のメソッド
  def inquiry_type_japanese
    case inquiry_type
    when 'dependency'
      'ご依頼'
    when 'company_info'
      '弊社について'
    when 'other'
      'その他ご質問'
    end
  end
  
  scope :recent, -> { order(created_at: :desc) }
  scope :answered, -> { joins(:answers).distinct }
  scope :unanswered, -> { left_joins(:answers).where(answers: { id: nil }) }
end

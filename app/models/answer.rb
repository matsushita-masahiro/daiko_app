class Answer < ApplicationRecord
  belongs_to :inquiry
  
  validates :content, presence: true
  validates :admin_name, presence: true
  
  before_create :set_answered_at
  
  private
  
  def set_answered_at
    self.answered_at = Time.current
  end
end

class Tax < ApplicationRecord
  validates :name, presence: true, length: { maximum: 100 }
  validates :value, presence: true, numericality: { greater_than: 0 }
  validates :begin, presence: true
  validates :end, presence: true
  validate  :end_after_begin

  def valid 
    Date.today > self.begin && Date.today < self.end
  end
  private

  def end_after_begin
    return if self.begin.blank? || self.end.blank?

    if self.end < self.begin
      errors.add(:end, "must be after start date")
    end
  end
end

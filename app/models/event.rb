class Event < ApplicationRecord
  validates :title, presence: true
  validates :starts_at, presence: true
  validates :ends_at, presence: true

  private

  def event_ends_after_starts
    if starts_at.present? && ends_at.present? && ends_at <= starts_at
      errors.add(:ends_at, "must be after the start time")
    else
    end
  end
end

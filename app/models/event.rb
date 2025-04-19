class Event < ApplicationRecord
  validates :title, presence: true
  validates :starts_at, presence: true
  validates :ends_at, presence: true

  def to_icalendar
    cal = Icalendar::Calendar.new

    cal.event do |e|
      e.dtstart     = starts_at
      e.dtend       = ends_at
      e.summary     = title
      e.description = description
      e.ip_class    = "PRIVATE"
    end

    cal.publish
    cal.to_ical
  end

  private

  def event_ends_after_starts
    if starts_at.present? && ends_at.present? && ends_at <= starts_at
      errors.add(:ends_at, "must be after the start time")
    else
    end
  end
end

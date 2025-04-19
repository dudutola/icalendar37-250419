class Event < ApplicationRecord
  validates :title, presence: true
  validates :starts_at, presence: true
  validates :ends_at, presence: true
  validate :event_ends_after_starts

  def to_icalendar
    cal = Icalendar::Calendar.new

    cal.event do |e|
      e.dtstart       = Icalendar::Values::DateTime.new(starts_at, "tzid" => "Europe/Lisbon")
      e.dtend         = Icalendar::Values::DateTime.new(ends_at, "tzid" => "Europe/Lisbon")
      e.summary       = title
      e.description   = description
      e.ip_class      = "PRIVATE"
      e.uid           = "event-#{self.id}@localhost"
      e.sequence      = Time.now.to_i
      e.dtstamp       = Time.now.utc
      # e.last_modified =  updated_at&.utc || Time.now.utc
    end

    cal.publish
    cal.to_ical
  end

  private

  def event_ends_after_starts
    return if starts_at.blank? || ends_at.blank?

    if ends_at <= starts_at
      errors.add(:ends_at, "must be after the start time")
    else
    end
  end
end

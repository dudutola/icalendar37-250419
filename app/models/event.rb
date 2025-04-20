class Event < ApplicationRecord
  validates :title, presence: true
  validates :starts_at, presence: true
  validates :ends_at, presence: true
  validate :event_ends_after_starts

  include Rails.application.routes.url_helpers

  def to_icalendar
    cal = Icalendar::Calendar.new

    tz = Icalendar::Timezone.new
    tz.tzid = "Europe/Lisbon"

    # STANDARD time (winter time)
    standard = Icalendar::Timezone::Standard.new
    standard.dtstart = "20231029T020000"
    standard.tzoffsetfrom = "+0100"
    standard.tzoffsetto = "+0000"
    standard.tzname = "WET"
    tz.add_standard(standard)

    # DAYLIGHT time (summer time)
    daylight = Icalendar::Timezone::Daylight.new
    daylight.dtstart = "20240331T010000"
    daylight.tzoffsetfrom = "+0000"
    daylight.tzoffsetto = "+0100"
    daylight.tzname = "WEST"
    tz.add_daylight(daylight)

    cal.add_timezone(tz)

    cal.event do |e|
      e.dtstart       = Icalendar::Values::DateTime.new(starts_at, "tzid" => "Europe/Lisbon")
      e.dtend         = Icalendar::Values::DateTime.new(ends_at, "tzid" => "Europe/Lisbon")
      e.summary       = title
      e.description   = description || ""
      e.ip_class      = "PRIVATE"
      e.uid           = "event-#{self.id}@localhost"
      # e.sequence      = Time.now.to_i
      e.sequence = updated_at.to_i if updated_at.present?
      e.dtstamp       = Time.now.utc
      e.location      = address
      e.url           = event_url(self)
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

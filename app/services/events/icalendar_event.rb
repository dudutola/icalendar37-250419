# Events::IcalendarEvent.new(event: Event.first).call

class Events::IcalendarEvent
  include Rails.application.routes.url_helpers

  def initialize(event:)
    @event = event
  end

  def call
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
      e.dtstart       = Icalendar::Values::DateTime.new(@event.starts_at, "tzid" => "Europe/Lisbon")
      e.dtend         = Icalendar::Values::DateTime.new(@event.ends_at, "tzid" => "Europe/Lisbon")
      e.summary       = @event.title
      e.description   = @event.description || ""
      e.ip_class      = "PRIVATE"
      e.uid           = "event-#{@event.id}@localhost"
      # e.sequence      = Time.now.to_i
      e.sequence = @event.updated_at.to_i if @event.updated_at.present?
      e.dtstamp       = Time.now.utc
      e.location      = @event.address
      e.url           = event_url(@event)
    end

    cal.publish
    cal.to_ical
  end
end

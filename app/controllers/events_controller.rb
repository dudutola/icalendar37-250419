class EventsController < ApplicationController
  def index
    @events = Event.all.order(:starts_at)
  end

  def show
    @event = Event.find(params[:id])

    respond_to do |format|
      format.html
      format.ics do
        render plain: @event.to_icalendar
      end
    end
  end
end

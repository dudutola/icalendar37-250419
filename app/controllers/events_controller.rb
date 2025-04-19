class EventsController < ApplicationController
  def index
    @events = Event.all.order(:starts_at)
  end
end

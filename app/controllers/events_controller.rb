class EventsController < ApplicationController
  before_action :set_event, only: [ :show, :edit, :update ]

  def index
    @events = Event.all.order(:starts_at)
  end

  def show
    respond_to do |format|
      format.html
      format.ics do
        render plain: @event.to_icalendar
      end
    end
  end

  def edit;end

  def update
    respond_to do |format|
      if @event.update(event_params)
        # render plain: @event.to_icalendar
        format.html { redirect_to @event }
        format.json { render :show }
      else
        format.html { render :edit }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  private

  def set_event
    @event = Event.find(params[:id])
  end

  def event_params
    params.require(:event).permit(:title, :description, :starts_at, :ends_at)
  end
end

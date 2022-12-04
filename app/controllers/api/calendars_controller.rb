class Api::CalendarsController < ApplicationController
  def show
    @calendars = User.find(params[:id]).calendars.find_by(year:2022).days
  end
end

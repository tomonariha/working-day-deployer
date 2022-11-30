class Api::CalendarsController < ApplicationController
  def show
    @calendars = User.find(params[:id]).calendars.where(year:2022)
  end
end

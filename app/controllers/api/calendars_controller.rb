# frozen_string_literal: true

class Api::CalendarsController < ApplicationController
  def show
    @calendars = User.find(current_user.id).calendars.find_by(year: params[:id]).days
  end
end

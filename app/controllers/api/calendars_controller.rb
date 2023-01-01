# frozen_string_literal: true

class Api::CalendarsController < ApplicationController
  def show
    @days = User.find(current_user.id).calendars.find_or_create_by(year: params[:year]).days
  end
end

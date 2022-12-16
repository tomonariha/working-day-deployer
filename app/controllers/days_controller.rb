# frozen_string_literal: true

class DaysController < ApplicationController
  def update
    @calendar = User.find(current_user.id).calendars.find_by(year: params[:year])
    target_day = Date.new(params[:year].to_i, params[:month].to_i, params[:date].to_i)
    @day = @calendar.days.find_or_create_by(date: target_day)
    Day.update!(@day.id, schedule: params[:schedule])
  end
end

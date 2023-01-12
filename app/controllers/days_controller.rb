# frozen_string_literal: true

class DaysController < ApplicationController
  before_action :set_calendar
  before_action :set_target_day

  def destroy
    day = @calendar.days.find_by(date: @target_day)
    day.delete if day
  end

  def update
    day = @calendar.days.find_or_create_by(date: @target_day)
    Day.update!(day.id, schedule: params[:schedule])
  end

  private

  def set_calendar
    @calendar = User.find(current_user.id).calendars.find_by(year: params[:year])
  end

  def set_target_day
    @target_day = Date.new(params[:year].to_i, params[:month].to_i, params[:date].to_i)
  end
end

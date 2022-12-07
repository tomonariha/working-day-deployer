class DaysController < ApplicationController
  def update
    @calendar = User.find(current_user.id).calendars.find_by(year: params[:year])
    target_day = Date.new(params[:year].to_i, params[:month].to_i, params[:date].to_i)
    @day = Day.new(calendar_id: @calendar.id, date: target_day, schedule: params[:schedule])
    @day.save!
  end
end
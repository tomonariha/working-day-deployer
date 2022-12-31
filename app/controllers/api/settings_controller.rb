# frozen_string_literal: true

class Api::SettingsController < ApplicationController
  def index
    @settings = User.find(current_user.id).calendars.find_by(year: params[:calendar_year].to_i).settings
  end

  def show
  end

  def create
    @calendar = User.find(current_user.id).calendars.find_by(year: params[:calendar_year])
    period_start_at = Date.new(params[:calendar_year].to_i, params[:start_month].to_i, params[:start_day].to_i)
    period_end_at = Date.new(params[:calendar_year].to_i, params[:end_month].to_i, params[:end_day].to_i)
    @setting = Setting.new(
      calendar_id: @calendar.id,
      schedule_of_sunday: params[:schedule_of_sunday],
      total_working_days: params[:total_working_days],
      period_start_at: period_start_at,
      period_end_at: period_end_at
    )
    @setting.save!
  end

  def destroy
    Setting.find(params[:id]).delete
  end
end

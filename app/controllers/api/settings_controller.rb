# frozen_string_literal: true

class Api::SettingsController < ApplicationController
  def index
    @settings = User.find(current_user.id).calendars.find_by(year: params[:calendar_year]).settings
  end

  def show
  end

  def create
    @calendar = User.find(current_user.id).calendars.find_by(year: params[:calendar_year])
    @setting = Setting.new(
      calendar_id: @calendar.id,
      schedule_of_sunday: params[:schedule_of_sunday],
      total_working_days: params[:total_working_days],
      period_start_at: params[:period_start_at],
      period_end_at: params[:period_end_at]
    )
    @setting.save!
  end

  def update
    @setting = Setting.find(params[:id])
    @setting.update!(setting_params)
  end

  def destroy
    Setting.find(params[:id]).delete
  end

  private

  def setting_params
    params.require(:setting).permit(
      :calendar_id,
      :schedule_of_sunday,
      :total_working_days,
      :period_start_at,
      :period_end_at,
    )
  end
end

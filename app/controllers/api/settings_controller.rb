# frozen_string_literal: true

class Api::SettingsController < ApplicationController
  def index
    @settings = User.find(current_user.id).calendars.find_by(year: params[:calendar_id]).settings
  end

  def show
  end

  def create
    @calendar = User.find(current_user.id).calendars.find_by(year: params[:year])
    start_at = Date.new(params[:year].to_i, params[:start_month].to_i, params[:start_day].to_i)
    end_at = Date.new(params[:year].to_i, params[:end_month].to_i, params[:end_day].to_i)
    @setting = Setting.new(calendar_id: @calendar.id, schedule_of_sunday: params[:schedule_of_sunday])
    debugger
    #@setting.save!
  end
end

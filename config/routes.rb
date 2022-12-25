# frozen_string_literal: true

Rails.application.routes.draw do
  root 'home#index'
  devise_for :users
  get 'calendars/index'
  draw :api
  post 'days/:year/:month', to: 'days#update'
  post 'settings/:year', to: 'api/settings#create'
end

Rails.application.routes.draw do
  namespace 'api' do
    resources 'calendars', only: %i(show)
    resources 'calendars' do
      get 'settings', to: 'settings#index'
    end
  end
end

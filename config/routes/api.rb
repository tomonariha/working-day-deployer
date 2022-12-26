Rails.application.routes.draw do
  namespace 'api' do
    resources 'calendars', only: %i(show), param: :year do
      get 'settings', to: 'settings#index'
    end
  end
end

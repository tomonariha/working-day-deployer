Rails.application.routes.draw do
  namespace 'api' do
    resources 'calendars', only: %i(show), param: :year do
      resources 'settings', only: %i(index destroy create)
    end
  end
end

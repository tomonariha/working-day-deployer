Rails.application.routes.draw do
  namespace 'api' do
    resources 'calendars', only: %i(show)
  end
end

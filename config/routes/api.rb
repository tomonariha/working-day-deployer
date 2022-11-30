Rails.application.routes.draw do
  namespace 'api' do
    resources 'calendars' 
  end
end

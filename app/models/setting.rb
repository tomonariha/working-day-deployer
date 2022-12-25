class Setting < ApplicationRecord
  belongs_to :calendar, dependent: :destroy
end

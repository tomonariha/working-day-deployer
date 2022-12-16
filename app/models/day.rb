# frozen_string_literal: true

class Day < ApplicationRecord
  belongs_to :calendar, dependent: :destroy
end

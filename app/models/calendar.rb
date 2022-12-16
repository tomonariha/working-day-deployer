# frozen_string_literal: true

class Calendar < ApplicationRecord
  belongs_to :user
  has_many :days, dependent: :destory
end

# frozen_string_literal: true

class Task < ApplicationRecord
  # Validations
  validates :name, presence: true,
            length: { minimum: 3, maximum: 15 }
end

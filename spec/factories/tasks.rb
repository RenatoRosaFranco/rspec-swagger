# frozen_string_literal: true

FactoryBot.define do
  factory :task do
    name { FFaker::Book.title }
    completed { false }

    trait :completed do
      completed { true }
    end

    trait :uncompleted do
      completed { false }
    end
  end
end

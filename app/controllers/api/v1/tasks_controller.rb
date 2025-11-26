# frozen_string_literal: true

module Api
  module V1
    class TasksController < ApplicationController
      before_action :set_task, only: [:show]

      def index
        tasks = Task.order(created_at: :desc)
        render json: { tasks: tasks }, status: :ok
      end

      def show
        render json: { task: @task }, status: :ok
      end

      private

      def set_task
        @task = Task.find(params[:id])
      rescue ActiveRecord::RecordNotFound => _
        render json: { success: false, message: "Task not found for id=#{params[:id]}" }
      end
    end
  end
end

# frozen_string_literal: true

module Api
  module V1
    class TasksController < BaseController
      before_action :set_task, only: [:show, :update, :destroy]

      def index
        tasks = Task.order(created_at: :desc)
        render json: { success: true, tasks: tasks }, status: :ok
      end

      def create
        task = Task.new(task_params)

        if task.save
          render json: {
            success: true,
            message: "Task created successfully",
            task: task
          }, status: :created
        else
          render json: {
            success: false,
            message: "Failed to create task",
            errors: task.errors.full_messages
          }, status: :unprocessable_entity
        end
      end

      def show
        render json: { success: true, task: @task }, status: :ok
      end

      def update
        if @task.update(task_params)
          render json: {
            success: true,
            message: "",
            task: @task
          }, status: :ok
        else
          render json: {
            success: false,
            message: "Failed to update task",
            errors: @task.errors.full_messages
          }, status: :unprocessable_entity
        end
      end

      def destroy
        if @task.destroy
          render json: {
            success: true,
            message: "Task deleted successfully",
          }, status: :ok
        else
          render json: {
            success: false,
            message: "Failed to delete task"
          }, status: :unprocessable_entity
        end
      end

      private

      def set_task
        @task = Task.find(params[:id])
      rescue ActiveRecord::RecordNotFound => _
        render json: { 
          success: false, 
          message: "Task not found for id=#{params[:id]}" 
        }, status: :not_found
      end

      def task_params
        params.require(:task).permit(:name, :completed)
      end
    end
  end
end

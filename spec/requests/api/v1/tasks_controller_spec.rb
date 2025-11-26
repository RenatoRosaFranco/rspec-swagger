# frozen_stirng_literal: true

require 'swagger_helper'

RSpec.describe 'API::V1::Tasks', type: :request, swagger_doc: 'v1/swagger.yaml' do
  path '/api/v1/tasks' do
    get 'List all tasks' do
      tags 'Tasks'
      produces 'application/json'

      response 200, 'Tasks returned with success' do
        schema type: :object,
               properties: {
                 tasks: {
                   type: :array,
                   items: {
                     type: :object,
                     properties: {
                       id: { type: :integer },
                       title: { type: :string, nullable: true },
                       description: { type: :string, nullable: true }
                     }
                   }
                 }
               }

        before { FactoryBot.create_list(:task, 3) }
        
        run_test!
      end
    end
  end

  path '/api/v1/tasks' do
    post 'Create a task' do
      tags 'Tasks'
      consumes 'application/json'
      produces 'application/json'

      parameter name: :task, in: :body, schema: {
        type: :object,
        properties: {
          task: {
            type: :object,
            properties: {
              name: { type: :string },
              completed: { type: :boolean }
            },
            required: %w[name]
          }
        }
      }
  

      response 201, 'task created sucessfully' do
        let(:task) { { task: { name: "New Task", completed: false } } }
        
        run_test!
      end

      response 422, 'invalid parameters' do
        let(:task) { { task: { name: "" } } }
        
        run_test!
      end
    end
  end

  path '/api/v1/tasks/{id}' do
    get 'Show task' do
      tags 'Tasks'
      parameter name: :id, in: :path, type: :integer

      response 200, 'task found' do
        let(:id) { FactoryBot.create(:task).id }
        
        run_test!
      end

      response 404, 'task not found' do
        let(:id) { 0 }
        
        run_test!
      end
    end
  end

  path '/api/v1/tasks/{id}' do
    put 'Update task do' do
      tags 'Tasks'
      consumes 'application/json'
      
      parameter name: :id, in: :path, type: :integer
      parameter completed: :task, in: :body, schema: {
        type: :object,
        properties: {
          task: {
            type: :object,
            properties: {
              name: { type: :string },
              completed: { type: :boolean }
            }
          }
        }
      }

      response 200, 'task updated sucessfully' do
        let(:task) { FactoryBot.create(:task, :uncompleted) }
        let(:id) { task.id }
        let(:params) { { task: { completed: true } } }
        
        run_test!
      end

      response 422, 'invalid update' do
        let(:task) { FactoryBot.create(:task) }
        let(:id) { task.id }
        let(:params) { { task:  { completed: true } } }
        
        run_test!
      end
    end
  end

  path '/api/v1/tasks/{id}' do
    delete 'Delete task' do
      tags 'Tasks'
      parameter name: :id, in: :path, type: :integer

      response 200, 'task deleted sucessfully' do
        let(:id) { FactoryBot.create(:task).id }
        
        run_test!
      end

      response 404, 'task not found' do
        let(:id) { 0 }
        
        run_test!
      end
    end
  end
end

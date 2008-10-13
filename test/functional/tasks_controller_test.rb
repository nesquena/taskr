require 'test_helper'

class TasksControllerTest < ActionController::TestCase
  context "on :index action" do
    setup { get :index }
    should_assign_to :tasks, :equals => 'Task.all'
    should_respond_with_content_type :html
    should_respond_with :success
    should_render_template :index
  end
  
  context "on :create action" do
    context "for all formats" do
      setup { post :create, :task => Factory.attributes_for(:task) }
      should_assign_to :task
      should_change "Task.count", :by => 1
    end

    context "for html format" do
      setup { post :create, :task => Factory.attributes_for(:task), :format => 'html' }
      should_respond_with_content_type :html
      should_respond_with :redirect
      should_redirect_to "tasks_path"
    end
    
    context "for js format" do
      setup { post :create, :task => Factory.attributes_for(:task, :description => "go to mall"), :format => 'js' }
      should_respond_with_content_type :js
      should_respond_with :success
      should "render the partial" do 
        assert_match(/go to mall/, @response.body)
      end
    end
  end
  
  context "on :destroy action" do
    setup do
      @task = Factory(:task)
    end
    
    context "for all formats" do
      setup { delete :destroy, { :id => @task.id } }
      
      should_assign_to :task, :class => Task, :equals => '@task'
      should_change "Task.count", :by => -1
      should "have deleted the task" do
        assert_nil Task.find_by_id(@task.id)
      end
    end
    
    context "for html format" do
      setup { delete :destroy, :id => @task.id, :format => 'html' }

      should_respond_with_content_type :html
      should_respond_with :redirect
      should_redirect_to "tasks_path"
    end
    
    context "for json format" do
      setup { delete :destroy, :id => @task.id, :format => 'json' }

      should_respond_with_content_type :json
      should "respond with json result true and task id" do
        assert_equal({ :result => true, :id => @task.id }.to_json, @response.body)
      end
    end
    
  end
      
end

class TasksController < ApplicationController
  def index
    @tasks = Task.all
    
    respond_to do |wants|
      wants.html
    end
  end
  
  def create
    @task = Task.new(params[:task])
    
    respond_to do |wants|
      if @task.save
        wants.html { redirect_to tasks_path }
        wants.js { render :partial => 'task_item', :object => @task  }
      else # task isn't valid
        wants.html { redirect_to tasks_path }
        wants.js { render :nothing => true }
      end
    end
  end
  
  def destroy
    @task = Task.find_by_id(params[:id])
    
    respond_to do |wants|
      if @task.destroy
        wants.html { redirect_to tasks_path }
        wants.json { render :json => { :result => true, :id => @task.id }  }
      else # task is not destroyed
        wants.html { redirect_to tasks_path }
        wants.json { render :json => { :result => false, :id => @task.id }  }
      end
    end
  end
end

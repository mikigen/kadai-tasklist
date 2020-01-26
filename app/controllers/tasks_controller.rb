class TasksController < ApplicationController
  before_action :require_user_logged_in
  before_action :correct_user, only: [:show, :edit, :update, :destroy]
  
  def index
      @tasks = current_user.tasks.order(id: :desc).page(params[:page])
  end
  
  def show
    @task = Task.find(params[:id])
  end
  
  def new
      @task = Task.new
  end
  
  def create
    @task = current_user.tasks.build(task_params)
    if @task.save
      flash[:success] = 'Taskを投稿しました。'
      redirect_to root_url
    else
      @tasks = current_user.tasks.order(id: :desc).page(params[:page])
      flash.now[:danger] = 'Taskの投稿に失敗しました。'
      render 'tasks/new'
    end
  end

  def destroy
    @task.destroy
    flash[:success] = 'Taskを削除しました。'
    redirect_to root_url
  end
  
  def edit
  end
  
  def update
    @task = Task.find(params[:id])

    if @task.update(task_params)
      flash[:success] = 'Task は正常に更新されました'
      redirect_to root_url
    else
      flash.now[:danger] = 'Task は更新されませんでした'
      render :edit
    end
  end
  
  private
  
  def task_params
    params.require(:task).permit(:content, :status)
  end
  
  def correct_user
    @task = current_user.tasks.find_by(id: params[:id])
    unless @task
      redirect_to root_url
    end
  end
end

class FacultiesController < ApplicationController
  before_filter :require_admin

  def index
    flash[:notice] = "in index"
    @faculties = Faculty.all
  end

  def update
    unless f = Faculty.find(params[:id])
      redirect_to faculties_path, :notice => "Invalid id #{params[:id]}"
    end

    unless f.update_attributes(params[:faculty])
      redirect_to faculties_path, :notice => "Failed to update #{f.inspect}"
    end

    redirect_to faculties_path, :notice => "Successfully updated #{f.name}"
  end

  def create
    @new_faculty = Faculty.new(params[:faculty])

    if @new_faculty.save
      flash[:notice] = "Successfully added #{@new_faculty.name}"
    else
      flash[:notice] = "Error: #{@new_faculty.errors.inspect}"
    end

    render :action => :index
  end

  def destroy
    f = Faculty.find(params[:id])
    f.destroy

    redirect_to faculties_path
  end

private
  def require_admin
    unless @current_user and @current_user.user_type == User::Types::Admin
      redirect_to request.referer || home_path, :notice => "Insufficient priveleges"
    end
  end
end

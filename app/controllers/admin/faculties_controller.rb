class Admin::FacultiesController < AdminController

  def index
    @faculties = Faculty.all
  end

  def update
    unless f = Faculty.find(params[:id])
      redirect_to admin_faculties_path, :notice => "Invalid id #{params[:id]}"
    end

    unless f.update_attributes(params[:faculty])
      redirect_to admin_faculties_path, :notice => "Failed to update #{f.inspect}"
    end

    redirect_to admin_faculties_path, :notice => "Successfully updated #{f.name}"

  end

  def create
    @new_faculty = Faculty.new(params[:faculty])

    if @new_faculty.save
      flash[:notice] = "Successfully added #{@new_faculty.name}"
    else
      flash[:notice] = "Error: #{@new_faculty.errors.inspect}"
    end

    index
    render :action => :index
  end

  def destroy
    f = Faculty.find(params[:id])
    f.destroy

    redirect_to admin_faculties_path
  end

end

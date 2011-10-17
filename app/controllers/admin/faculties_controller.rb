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

end

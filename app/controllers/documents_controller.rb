class DocumentsController < ApplicationController

include CASControllerIncludes

#CalNet / CAS Authentication
#before_filter CASClient::Frameworks::Rails::Filter
before_filter :rm_login_required

def new
    @document = Document.new
end

def create
    @document = Document.new(params[:document])
    # TODO: additional verification of correct user?
    return if redirect_if(params[:document].nil? || params[:document][:user_id].nil? || params[:document][:user_id].to_i != @current_user.id,
        "Error: Couldn't associate document with your user. Please re-upload.",
        "/dashboard")

    @document.user = @current_user

    # Process document type
    @document.set_document_type(params[:document][:document_type])

    if [Document::Types::Resume, Document::Types::Transcript].include?(@document.document_type)
        if @document.save
            flash[:notice] = "Thanks for uploading your #{params[:document][:document_type]}! It should now show up in your profile."
        else
            flash[:error] = "Oops! Something went wrong with your upload. No changes were made."
        end
    else
        flash[:error] = "Please select a document type to upload. We don't want to have to guess for you."
    end

    #redirect_back_or_default "/dashboard"
    redirect_to url_for(:controller => 'users', :action => 'edit', :id => @current_user.id)
end

def show
  redirect_to '/'
end

def destroy
    @document = Document.find(params[:id])
    if @document.user == @current_user
        if @document.destroy
            flash[:notice] = "Removed the requested document."
        else
            flash[:error] = "The requested document escaped our virtual shredder. Please try again, or contact support."
        end
    else
        flash[:error] = "Access violation."
    end
    redirect_to url_for(:controller => 'users', :action => 'edit', :id => @current_user.id)
end

end

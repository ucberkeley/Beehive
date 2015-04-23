require 'csv'

class AdminController < ApplicationController
  before_filter :require_admin

  def index
    roles = {User::Types::Undergrad => 'Undergrad',
             User::Types::Grad => 'Grad Student',
             User::Types::Faculty => 'Faculty',
             User::Types::Staff => 'Staff',
             User::Types::Affiliate => 'Affiliate',
             User::Types::Admin => 'Admin'
    }
    if params.has_key?('user_role') and params.has_key?('user_role_new')
      form_error = false
      error_msg = ['Oops! The following errors prevented the selected user from being updated!']
      if params['user_role'] == ''
        form_error = true
        error_msg  << '1) No user selected.'
      end
      if params['user_role_new'] == ''
        if form_error
          error_msg << '2) No role selected.'
        else
          error_msg << '1) No role selected.'
          form_error = true
        end
      end
      if form_error
        flash[:error] = error_msg.join('<br/>').html_safe
      else
        u = User.find_by_email(params['user_role'])
        u.user_type = params['user_role_new'].to_i
        u.save!
        flash[:notice] = "User #{u.name} successfully set as #{u.user_type_string}."
      end
    end
    @non_admins = []
    User.all.each do |i|
      if i.user_type == User::Types::Undergrad
        @non_admins << [i.name + ' - Undergrad', i.email]
      end
      if i.user_type == User::Types::Grad
        @non_admins << [i.name + ' - Grad Student', i.email]
      end
      if i.user_type == User::Types::Faculty
        @non_admins << [i.name + ' - Faculty', i.email]
      end
    end
    @non_admins = @non_admins.sort
    @roles = [['Undergrad', 0], ['Grad Student', 1], ['Faculty', 2], ['Staff', 3], ['Affiliate', 4], ['Admin', 4]]
  end

  def upload
    uploaded_file = params[:user_csv]
    if uploaded_file.nil?
      flash[:error] = 'Oops! No CSV file selected'
      return redirect_to admin_path
    end
    #Write CSV file to filesystem
    csv_file_handle = Rails.root.join('tmp', uploaded_file.original_filename)
    File.open(csv_file_handle, 'w') do |file|
      file.write(uploaded_file.read)
    end
    #Initial check for simple parse problems in CSV
    begin
      CSV.parse(csv_file_handle.to_s)
    rescue 
      flash[:error] = 'The CSV was malformed! Please correct the CSV and try again.'
      File.delete(csv_file_handle)
      return redirect_to admin_path
    end
    #Two passes: 1st pass checks each row is valid, 2nd updates the users table
    for i in 0..1 do
      CSV.foreach(csv_file_handle, {:headers => true, :header_converters => :symbol}) do |row|
        row_hash = row.to_hash
        p row_hash
        user = User.find_by_email(row_hash[:email])
        if user.nil?
          user = User.new
          if !row_hash[:login_id].nil?
            user.name = row_hash[:name]
            user.email = row_hash[:email]
            user.user_type = row_hash[:user_role]
            user.login = row_hash[:login_id]
          else
            flash[:error] = 'The following error(s) occurred with the CSV upload: Attempted to add new user without login_id.'
            File.delete(csv_file_handle)
            return redirect_to admin_path
          end
        else
          user.name = row_hash[:name]
          user.user_type = row_hash[:user_role]
        end
        if !user.valid? && !row_hash.empty?
          # invalid user and not a newline
          flash[:error] = 'The following error(s) occurred with the CSV upload: ' + user.errors.full_messages.join(",")
          File.delete(csv_file_handle)
          return redirect_to admin_path
        elsif user.valid? && i == 1
          #if on second pass and user is valid, save to db
          user.save!
        end
      end
    end
    flash[:notice] = 'CSV successfully uploaded!'
    File.delete(csv_file_handle)
    redirect_to admin_path
  end
end
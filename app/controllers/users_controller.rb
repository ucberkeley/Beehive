class UsersController < ApplicationController
  before_filter :rm_login_required

  # GET /users
  # GET /users.xml
  def index
    @users = User.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @users }
    end
  end

  # GET /users/1
  # GET /users/1.xml
  def show
    @user = User.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @user }
    end
  end

  # GET /users/new
  # GET /users/new.xml
  def new
    @user = User.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @user }
    end
  end

  # GET /users/1/edit
  def edit
    @user = User.find(params[:id])
    
    # Attribs logic. Puts the attribs in the params so that 
    # the user's edit profile form displays existing attribs.
    
    Attrib.get_attrib_names.each do |attrib_name|
      params['attrib_' + attrib_name] = @user.attrib_values_for_name(attrib_name, true)
    end
    
  end

  def profile
    params[:id] = @current_user.id
    edit
    render :edit
  end

  # POST /users
  # POST /users.xml
  def create
    @user = User.new(params[:user])

    respond_to do |format|
      if @user.save
        format.html { redirect_to(@user, :notice => 'User was successfully created.') }
        format.xml  { render :xml => @user, :status => :created, :location => @user }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /users/1
  # PUT /users/1.xml
  def update
    @user = User.find(params[:id])
    puts p(params)
    respond_to do |format|
      if @user.update_attributes(params[:user])
        
        # Attribs logic. Gets the attribs from the params and finds or 
        # creates them appropriately.

        @user.attribs = []
        
        Attrib.get_attrib_names.each do |attrib_name|

          # What was typed into the box. May include commas and spaces.
          raw_attrib_value = params['attrib_' + attrib_name]
          
          # If left blank, we don't want to create "" attribs.
          if raw_attrib_value.present?
            raw_attrib_value.split(',').uniq.each do |val_before_fmt|
              
              # Avoid ", , , ," situations
              if val_before_fmt.present?
                
                # Remove leading/trailing whitespace
                val = val_before_fmt.strip
                
                # HACK: We want to remove spaces and use uppercase for courses only
                if attrib_name == 'course'
                  val = val.upcase.gsub(/ /, '')
                else
                  val = val.downcase
                end
                
                the_attrib = Attrib.find_or_create_by_name_and_value(attrib_name, val)
                @user.attribs << the_attrib
              end
            end
          end
        end
        
        format.html { redirect_to(edit_user_path, :notice => 'User was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.xml
  def destroy
    @user = User.find(params[:id])
    @user.destroy

    respond_to do |format|
      format.html { redirect_to(users_url) }
      format.xml  { head :ok }
    end
  end
end

class AttribsController < ApplicationController
  # GET /attribs
  # GET /attribs.xml
  def index
    @attribs = Attrib.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @attribs }
    end
  end

  # GET /attribs/1
  # GET /attribs/1.xml
  def show
    @attrib = Attrib.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @attrib }
    end
  end

  # GET /attribs/new
  # GET /attribs/new.xml
  def new
    @attrib = Attrib.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @attrib }
    end
  end

  # GET /attribs/1/edit
  def edit
    @attrib = Attrib.find(params[:id])
  end

  # POST /attribs
  # POST /attribs.xml
  def create
    @attrib = Attrib.new(params[:attrib])

    respond_to do |format|
      if @attrib.save
        format.html { redirect_to(@attrib, :notice => 'Attrib was successfully created.') }
        format.xml  { render :xml => @attrib, :status => :created, :location => @attrib }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @attrib.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /attribs/1
  # PUT /attribs/1.xml
  def update
    @attrib = Attrib.find(params[:id])

    respond_to do |format|
      if @attrib.update_attributes(params[:attrib])
        format.html { redirect_to(@attrib, :notice => 'Attrib was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @attrib.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /attribs/1
  # DELETE /attribs/1.xml
  def destroy
    @attrib = Attrib.find(params[:id])
    @attrib.destroy

    respond_to do |format|
      format.html { redirect_to(attribs_url) }
      format.xml  { head :ok }
    end
  end
end

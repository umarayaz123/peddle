class FeedsController < ApplicationController
  # GET /feeds
  # GET /feeds.json
  def index
    @feeds = Feed.order("created_at DESC").limit(20)
    if request.xhr? && current_user
      render :partial => "/shared/feeds", :layout => false
      return
    else
      render :text => "You need to sign in"
      return
    end
    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @feeds }
    end
  end

  def your_feeds
    if current_user
      @feeds = current_user.feeds.order("created_at DESC").limit(20)
      render :partial => "/shared/feeds", :layout => false
    else
      render :text => "You need to sign in"
    end
  end

  def feeds_for_you
    if current_user
      @feeds = Feed.where(:feed_for => current_user.name).order("created_at DESC").limit(20)
      render :partial => "/shared/feeds", :layout => false
    else
      render :text => "You need to sign in"
    end
  end

  # GET /feeds/1
  # GET /feeds/1.json
  def show
    @feed = Feed.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @feed }
    end
  end

  # GET /feeds/new
  # GET /feeds/new.json
  def new
    @feed = Feed.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @feed }
    end
  end

  # GET /feeds/1/edit
  def edit
    @feed = Feed.find(params[:id])
  end

  # POST /feeds
  # POST /feeds.json
  def create
    @feed = Feed.new(params[:feed])
    if request.xhr?
      @feed_for = params[:message].scan(/@([A-Za-z0-9_]+)/).last.first if params[:message].scan(/@([A-Za-z0-9_]+)/).last
      @feed.message  = params[:message]
      @feed.user_id  = params[:id].to_i
      @feed.feed_for = @feed_for
      if @feed.save
        render :text => @feed.id
        return
      else
        render :text => "failure"
      end
    end

    respond_to do |format|
      if @feed.save
        format.html { redirect_to @feed, :notice => 'Feed was successfully created.' }
        format.json { render :json => @feed, :status => :created, :location => @feed }
      else
        format.html { render :action => "new" }
        format.json { render :json => @feed.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /feeds/1
  # PUT /feeds/1.json
  def update
    @feed = Feed.find(params[:id])

    respond_to do |format|
      if @feed.update_attributes(params[:feed])
        format.html { redirect_to @feed, :notice => 'Feed was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @feed.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /feeds/1
  # DELETE /feeds/1.json
  def destroy
    @feed = Feed.find(params[:id])
    @feed.destroy
    if request.xhr?
      render :text => "success"
      return
    end
    respond_to do |format|

      format.html { redirect_to feeds_url }
      format.json { head :ok }
    end
  end
end

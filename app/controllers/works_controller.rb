class WorksController < ApplicationController
  before_action :find_work, only: [:show, :edit, :update,:destroy,:upvote]

  def index
    @works = Work.all
  end

  def new
    @work = Work.new
  end

  def create

   @work = Work.new(work_params)
   if @work.save
     flash[:success] = "#{@work.title} saved"
     redirect_to works_path
   else
     flash[:alert] = "Could not create #{@work.category}"
     render :new
   end
 end


  def show
    work = find_work
    if work == nil
      flash[:alert] = "work was deleted"
      redirect_to works_path
    else
      @work = work
    end

  end

  def edit


  end


  def update
    if @work.update(work_params)
      flash[:success] = "#{@work.title} updated"
      redirect_to work_path(@work.id)
    else
      flash[:alert] = "A problem occured:Could not update"

      render :edit
    end
  end
  def destroy

        @work = Work.find(params[:id])
        if @work.destroy
        flash[:message] = "Deleted #{@work.category} #{@work.title}"
        redirect_to works_path

      end
    end

  def upvote
    if !(session[:user_id])
      flash[:status] = :failure
      flash[:message] = "you must be logged in to do that"
      redirect_back fallback_location: {action: "index"}
    elsif  session[:user_id]
      @vote = Vote.new
      @vote.user = User.find(session[:user_id])
      @vote.work = Work.find_by(id: params[:id])
      @vote.date =  Date.today
      if @vote.save
        #flash[:status] = :success
        flash[:message] = "Successfully upvoted "
        redirect_back fallback_location: {action: "index"}
      else
        #flash[:status] =:failure
        flash[:message]= "Could not upvote.#{@user.username} has already upvoted for #{@work.title}"
        redirect_back fallback_location: {action: "index"}
      end
    end
  end

  private
  def work_params
    return params.require(:work).permit(:category, :title, :created, :publication_year, :description)
  end
  def find_work
    @work = Work.find_by(id: params[:id])

  end

end

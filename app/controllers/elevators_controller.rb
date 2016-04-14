class ElevatorsController < PermissionsController
  before_filter :require_permission, only: [:edit, :destroy]

  def index
    @elevators = Elevator.order(:building_name).page params[:page]
  end

  def show
    @elevator = Elevator.find(params[:id])
    @review = Review.new
    @rating = Review::RATING
    @reviews = @elevator.reviews.order(total_votes: :desc, created_at: :desc)
    @reviews = @reviews.page params[:page]
    @user = @elevator.user
  end

  def new
    @elevator = Elevator.new
  end

  def create
    @elevator = current_user.elevators.build(elevator_params)

    if @elevator.save
      flash[:notice] = 'You have successfully added an elevader!'
      redirect_to elevator_path(@elevator)
    else
      flash[:error] = @elevator.errors.full_messages.join('. ')
      render action: 'new'
    end
  end

  def destroy
    @elevator = Elevator.find(params[:id])
    @elevator.destroy
    flash[:notice] = "Elevator was deleted"
    redirect_to elevators_path
  end

  def edit
    @elevator = Elevator.find(params[:id])
  end

  def update
    @elevator = Elevator.find(params[:id])
    if @elevator.update(elevator_params)
      flash[:notice] = 'Elevator was updated successfully'
      redirect_to elevator_path(@elevator)
    else
      flash[:error] = @elevator.errors.full_messages.join('. ')
      render :edit
    end
  end

  def search
    @search_results = Elevator.find_by_fuzzy_building_name(params['search'])
    @ids = @search_results.map { |result| result.id }
    @elevators = Elevator.where(id: @ids)
    @elevators = @elevators.page params[:page]
    if @elevators.empty?
      flash[:alert] = "Sorry but we couldn't find that elevator for you"
    end
    render :index
  end

  private

  def elevator_params
    params.require(:elevator).permit(:building_name, :address, :city, :zipcode, :state, :elevator_cache, :elevator)
  end
end

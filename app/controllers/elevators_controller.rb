class ElevatorsController < PermissionsController
  before_filter :require_permission, only: [:edit, :destroy]

  def index
    @elevators = Elevator.all.order(created_at: :desc)
  end

  def show
    @elevator = Elevator.find(params[:id])
    @review = Review.new
    @rating = Review::RATING
    @reviews = @elevator.reviews
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
      flash[:notice] = @elevator.errors.full_messages.join('. ')
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
      flash[:alert] = @elevator.errors.full_messages.join('. ')
      render :edit
    end
  end

  def search
    @elevators = Elevator.where(
      'building_name LIKE ?',
      "%#{params['search']}%"
    )
    render :index
  end

  private

  def elevator_params
    params.require(:elevator).permit(:building_name, :address, :city, :zipcode, :state)
  end
end

class SimulationsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_simulation, only: [:show, :advance]

  def new
    @simulation = Simulation.new
  end

  def create
    uploaded_file = params[:simulation][:file]
    
    begin
      content = uploaded_file.read
      data = InputParser.parse(content)
      
      @simulation = current_user.simulations.create!(
        generation_number: data[:generation],
        rows: data[:rows],
        cols: data[:cols],
        grid_data: data[:grid]
      )
      redirect_to @simulation
    rescue InputParser::InvalidFormatError => e
      flash.now[:alert] = "Errore nel file: #{e.message}"
      render :new, status: :unprocessable_entity
    rescue => e
      flash.now[:alert] = "Errore generico: #{e.message}"
      render :new, status: :unprocessable_entity
    end
  end

  def show
  end

  def advance
    engine = GameOfLifeEngine.new(@simulation.grid_data, @simulation.rows, @simulation.cols)
    new_grid = engine.next_generation
    
    @simulation.update!(
      grid_data: new_grid, 
      generation_number: @simulation.generation_number + 1
    )

    # Risposta Turbo Stream per aggiornare solo la griglia
    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to @simulation }
    end
  end

  private

  def set_simulation
    @simulation = current_user.simulations.find(params[:id])
  end
end
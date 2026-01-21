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
      # Debug: stampa il contenuto per vedere se viene letto bene
      puts "DEBUG: Contenuto file:\n#{content}" 
      
      data = InputParser.parse(content)
      
      @simulation = current_user.simulations.new( # Cambiato da create! a new per debug
        generation_number: data[:generation],
        rows: data[:rows],
        cols: data[:cols],
        grid_data: data[:grid]
      )

      if @simulation.save
        redirect_to @simulation
      else
        # Se il problema è la validazione del modello Simulation
        flash.now[:alert] = "Errore salvataggio: #{@simulation.errors.full_messages.join(", ")}"
        render :new, status: :unprocessable_entity
      end

    rescue InputParser::InvalidFormatError => e
      flash.now[:alert] = "Errore formato: #{e.message}"
      render :new, status: :unprocessable_entity
    rescue => e
      # Questo stamperà l'errore esatto nella tua console di GitHub Codespaces
      puts "ERRORE CRITICO: #{e.message}"
      puts e.backtrace.first(5)
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

    render turbo_stream: turbo_stream.replace("game_board", 
          partial: "simulations/grid", 
          locals: { simulation: @simulation })
  end

  private

  def set_simulation
    @simulation = current_user.simulations.find(params[:id])
  end
end
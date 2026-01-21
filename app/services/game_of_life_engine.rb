class GameOfLifeEngine
  attr_reader :grid, :rows, :cols

  def initialize(grid, rows, cols)
    @grid = grid # Matrice bidimensionale (Array of Arrays)
    @rows = rows
    @cols = cols
  end

  # Calcola la prossima generazione
  def next_generation
    new_grid = Array.new(@rows) { Array.new(@cols) }

    @rows.times do |r|
      @cols.times do |c|
        alive_neighbors = count_alive_neighbors(r, c)
        is_alive = @grid[r][c] == "*"

        if is_alive
          # Regole per cellule vive
          new_grid[r][c] = (alive_neighbors == 2 || alive_neighbors == 3) ? "*" : "."
        else
          # Regola per cellule morte
          new_grid[r][c] = (alive_neighbors == 3) ? "*" : "."
        end
      end
    end

    new_grid
  end

  private

  def count_alive_neighbors(row, col)
    count = 0
    # Controlla le 8 celle circostanti
    (-1..1).each do |i|
      (-1..1).each do |j|
        next if i == 0 && j == 0 # Salta la cella stessa

        r, c = row + i, col + j

        if r >= 0 && r < @rows && c >= 0 && c < @cols
          # Usiamo .to_s per sicurezza nel caso il JSON venga letto con tipi strani
          count += 1 if @grid[r][c].to_s == "*"
        end
      end
    end
    count
  end
end

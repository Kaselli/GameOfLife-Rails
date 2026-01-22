require "set"

class GameOfLifeEngine
  attr_reader :grid, :rows, :cols

  def initialize(grid, rows, cols)
    @grid = grid # Matrice bidimensionale (Array of Arrays)
    @rows = rows
    @cols = cols
  end

  # Calcola la prossima generazione - versione semplice
  # def next_generation
  #   new_grid = Array.new(@rows) { Array.new(@cols) }
  #
  #   @rows.times do |r|
  #     @cols.times do |c|
  #       alive_neighbors = count_alive_neighbors(r, c)
  #       is_alive = @grid[r][c] == "*"
  #
  #       if is_alive
  #         # Regole per cellule vive
  #         new_grid[r][c] = (alive_neighbors == 2 || alive_neighbors == 3) ? "*" : "."
  #       else
  #         # Regola per cellule morte
  #         new_grid[r][c] = (alive_neighbors == 3) ? "*" : "."
  #       end
  #     end
  #   end
  #
  #   new_grid
  # end

  # Calcola la prossima generazione - versione ottimizzata
  def next_generation
    live_cells = Set.new
    # Converti la griglia attuale in un insieme di coordinate [r, c]
    @grid.each_with_index { |row, r| row.each_with_index { |cell, c| live_cells << [ r, c ] if cell == "*" } }

    # Identifica tutte le celle da controllare: tutte le celle vive e i loro vicini
    cells_to_check = Set.new
    live_cells.each do |r, c|
      cells_to_check << [ r, c ] # Controlla la cella stessa
      # Controlla gli 8 vicini
      get_neighbors_coords(r, c).each { |nc| cells_to_check << nc }
    end

    new_live_cells = Set.new
    cells_to_check.each do |r, c|
      alive_neighbors = count_alive_neighbors(r, c)
      is_alive = live_cells.include?([ r, c ])

      # Applica le regole del gioco
      if is_alive && (alive_neighbors == 2 || alive_neighbors == 3)
        new_live_cells << [ r, c ]
      elsif !is_alive && alive_neighbors == 3
        new_live_cells << [ r, c ]
      end
    end

    # Conversione al formato della griglia
    render_set_to_grid(new_live_cells)
  end

  def render_set_to_grid(live_cells_set)
    # 1. Crea una nuova griglia vuota delle dimensioni originali
    new_grid = Array.new(@rows) { Array.new(@cols, ".") }

    # 2. Itera sui sopravvissuti e posiziona le celle vive
    live_cells_set.each do |r, c|
      # 3. Piazzale solo se dentro i confini della griglia (dato che i vicini potrebbero esserene all'esterno)
      if r >= 0 && r < @rows && c >= 0 && c < @cols
        new_grid[r][c] = "*"
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

  def get_neighbors_coords(row, col)
    # 1. Definisci gli offset per i vicini
    offsets = [ -1, 0, 1 ].product([ -1, 0, 1 ]) - [ [ 0, 0 ] ]

    # 2. Mappa gli offset alle coordinate reali e filtra quelle valide
    offsets.map do |dr, dc|
      [ row + dr, col + dc ]
    end.select do |r, c|
      # 3. Filtra solo le coordinate valide
      r >= 0 && r < @rows && c >= 0 && c < @cols
    end
  end
end

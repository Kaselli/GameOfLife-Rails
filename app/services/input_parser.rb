class InputParser
  class InvalidFormatError < StandardError; end

  def self.parse(file_content)
    # Puliamo il contenuto da spazi bianchi extra a inizio/fine e gestiamo i ritorni a capo
    lines = file_content.strip.split(/\r?\n/).map(&:strip).reject(&:empty?)

    raise InvalidFormatError, "File troppo corto o vuoto" if lines.length < 3

    # 1. Parsing Generazione
    gen_match = lines[0].match(/Generation\s+(\d+):/i)
    raise InvalidFormatError, "Prima riga deve essere 'Generation X:'" unless gen_match
    generation = gen_match[1].to_i

    # 2. Parsing Dimensioni (es: 4 8)
    dims = lines[1].split(/\s+/).map(&:to_i)
    raise InvalidFormatError, "Seconda riga deve contenere Altezza e Largh (es: 4 8)" unless dims.length == 2
    rows, cols = dims

    # 3. Parsing Griglia
    grid_lines = lines[2..]
    if grid_lines.length != rows
      raise InvalidFormatError, "Il numero di righe nella griglia (#{grid_lines.length}) non corrisponde a quanto dichiarato (#{rows})"
    end

    grid = grid_lines.map.with_index do |line, index|
      chars = line.chars
      if chars.length != cols
        raise InvalidFormatError, "La riga #{index + 1} della griglia ha #{chars.length} colonne invece di #{cols}"
      end
      chars
    end

    { generation: generation, rows: rows, cols: cols, grid: grid }
  end
end

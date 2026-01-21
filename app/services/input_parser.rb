class InputParser
  class InvalidFormatError < StandardError; end

  def self.parse(file_content)
    lines = file_content.strip.split("\n")
    
    # Validazione base e parsing
    gen_match = lines[0].match(/Generation (\d+):/)
    raise InvalidFormatError, "Formato Generazione non valido" unless gen_match
    generation = gen_match[1].to_i

    dims = lines[1].split.map(&:to_i)
    raise InvalidFormatError, "Dimensioni non valide" unless dims.length == 2
    rows, cols = dims

    grid_lines = lines[2..]
    raise InvalidFormatError, "Altezza griglia non corrispondente" unless grid_lines.length == rows

    grid = grid_lines.map do |line|
      chars = line.strip.chars
      raise InvalidFormatError, "Larghezza griglia non corrispondente" if chars.length != cols
      chars
    end

    { generation: generation, rows: rows, cols: cols, grid: grid }
  end
end
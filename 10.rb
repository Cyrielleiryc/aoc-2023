# # # DATA # # #

# getting the data from the terminal
lines = []

puts "Entrez les lignes (tapez 'fin' pour terminer la saisie) :"
input = gets.chomp

while input.downcase != 'fin'
  lines << input
  input = gets.chomp
end

LAST_LINE_INDEX = lines.length - 1
LAST_CHARACTER_INDEX = lines[0].length - 1

POSSIBLE_NEXT_TILE = {
  'top' => ['|', 'F', '7', 'S'],
  'bottom' => ['|', 'J', 'L', 'S'],
  'left' => ['-', 'L', 'F', 'S'],
  'right' => ['-', 'J', '7', 'S']
}

POSSIBLE_DIRECTIONS = {
  '|' => ['top', 'bottom'],
  'F' => ['bottom', 'right'],
  'J' => ['top', 'left'],
  '7' => ['bottom', 'left'],
  'L' => ['top', 'right'],
  '-' => ['left', 'right'],
  'S' => ['top', 'bottom', 'left', 'right']
}

# # # PART ONE # # #

# méthode pour trouver les coordonnées de S => [x, y]
# entrée => toutes les lignes sous format [[line1], [line2], etc]
# sortie => [1, 1] || [0, 2]
def find_start(tiles)
  tiles.each_with_index do |tile, y|
    next unless tile.include?('S')

    tile.chars.each_with_index do |char, x|
      return [x, y] if char == 'S'
    end
  end
end

# méthode pour donner l'action suivante
# entrée => lines, position précédente, position actuelle x, position actuelle y
# sortie => { next_dir: 'top', next_col: x, next_row: y }
def find_next_move(lines, prev_position, actual_x, actual_y)
  current_tile = lines[actual_y][actual_x]
  possible_directions = POSSIBLE_DIRECTIONS[current_tile]
  above = [actual_x, actual_y - 1]
  below = [actual_x, actual_y + 1]
  right = [actual_x + 1, actual_y]
  left = [actual_x - 1, actual_y]
  possible_directions.each do |dir|
    next if prev_position == dir

    next_move = {}
    if dir == 'top' && actual_y > 0 && POSSIBLE_NEXT_TILE[dir].include?(lines[above[1]][above[0]])
      next_move[:next_dir] = 'bottom'
      next_move[:next_col] = above[0]
      next_move[:next_row] = above[1]
      return next_move
    end
    if dir == 'bottom' && actual_y < LAST_LINE_INDEX && POSSIBLE_NEXT_TILE[dir].include?(lines[below[1]][below[0]])
      next_move[:next_dir] = 'top'
      next_move[:next_col] = below[0]
      next_move[:next_row] = below[1]
      return next_move
    end
    if dir == 'right' && actual_x < LAST_CHARACTER_INDEX && POSSIBLE_NEXT_TILE[dir].include?(lines[right[1]][right[0]])
      next_move[:next_dir] = 'left'
      next_move[:next_col] = right[0]
      next_move[:next_row] = right[1]
      return next_move
    end
    if dir == 'left' && actual_x > 0 && POSSIBLE_NEXT_TILE[dir].include?(lines[left[1]][left[0]])
      next_move[:next_dir] = 'right'
      next_move[:next_col] = left[0]
      next_move[:next_row] = left[1]
      return next_move
    end
  end
end

def answer1(lines, first_pos)
  start = find_start(lines)
  actual_x = start[0]
  actual_y = start[1]
  prev_position = first_pos
  path = {}
  count = 0
  while lines[actual_y][actual_x] != 'S' || count.zero?
    next_move = find_next_move(lines, prev_position, actual_x, actual_y)
    actual_x = next_move[:next_col]
    actual_y = next_move[:next_row]
    prev_position = next_move[:next_dir]
    if path[actual_y]
      path[actual_y] << actual_x
    else
      path[actual_y] = [actual_x]
    end
    count += 1
  end
  { count: count / 2, path: path }
end
# puts answer1(lines, 'top')[:path].to_s

# # # PART TWO # # #

class Array
  def deep_dup
    map { |x| x.is_a?(Array) ? x.deep_dup : x }
  end
end

# méthode pour préparer la grille pour la scanner
def transform_grid(lines, path, new_start)
  new_grid = lines.deep_dup.map(&:chars)
  path.each do |key, value|
    new_grid[key].map!.with_index do |char, index|
      value.include?(index) ? char : '.'
    end
  end
  start = find_start(lines)
  new_grid[start[1]][start[0]] = new_start
  new_grid
end

# méthode pour compter le nombre de 'inside' sur une ligne ligne
# entrée => ['.', '.', '.', '.', 'F', '-', 'J', '.', '.', 'F', '7', 'F', 'J', '|', 'L', '7', 'L', '7', 'L', '7'], line_index
# sortie => [[7, line_index], [8, line_index]]
# we count each L----J or F----7 as non existent
# and each L----7 or F----J as existent region boundary
def scan_line(line)
  count = 0
  in_region = false
  previous_edge = nil
  line.each do |char|
    next if char == '-'

    if char == '|'
      in_region = !in_region
    elsif ['L', 'F'].include?(char)
      previous_edge = char
    elsif char == 'J'
      in_region = !in_region if previous_edge == 'F'
      previous_edge = nil
    elsif char == '7'
      in_region = !in_region if previous_edge == 'L'
      previous_edge = nil
    elsif char == '.' && in_region
      count += 1
    end
  end
  count
end

# méthode pour scanner le tableau en entier
def answer2(grid)
  tiles_inside_loop = []
  grid.each do |line|
    tiles_inside_loop << scan_line(line)
  end
  tiles_inside_loop.sum
end

# # # ANSWERS # # #

puts '-----------'
# puts 'Réponse de la partie 1 :'
answer = answer1(lines, 'left')
# puts answer[:count]
# puts '-----------'

puts 'Réponse de la partie 2 :'
path = answer[:path]
grid = transform_grid(lines, path, '-')
puts answer2(grid)
puts '-----------'
# wrong = 268, 308 || 298 (too high)

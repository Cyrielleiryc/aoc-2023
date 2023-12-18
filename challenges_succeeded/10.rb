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
  path = []
  count = 0
  while lines[actual_y][actual_x] != 'S' || count.zero?
    next_move = find_next_move(lines, prev_position, actual_x, actual_y)
    actual_x = next_move[:next_col]
    actual_y = next_move[:next_row]
    prev_position = next_move[:next_dir]
    path << [actual_x, actual_y]
    count += 1
  end
  { count: count / 2, path: path }
end

# # # PART TWO # # #

def shoelace_formula(vertices)
  total = 0
  i = 0
  while i < vertices[0].length - 1
    total += (vertices[0][i] * vertices[1][i + 1])
    total -= (vertices[1][i] * vertices[0][i + 1])
    i += 1
  end
  total / 2
end

def vertices(lines, path)
  vertices = [path[-1]]
  path.each do |pos|
    char = lines[pos[1]][pos[0]]
    vertices << pos if %w[S 7 F L J].include?(char)
  end
  vertices
end

def answer2(lines, path)
  demi_perimeter = path.length / 2
  vertices = vertices(lines, path)
  aera = shoelace_formula(vertices.transpose)
  aera.abs - demi_perimeter + 1
end

# # # ANSWERS # # #

puts '-----------'
puts 'Réponse de la partie 1 :'
answer = answer1(lines, 'left')
puts answer[:count]
puts '-----------'

puts 'Réponse de la partie 2 :'
path = answer[:path]
puts answer2(lines, path)
puts '-----------'

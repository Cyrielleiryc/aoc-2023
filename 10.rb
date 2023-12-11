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

def answer1(lines)
  start = find_start(lines)
  actual_x = start[0]
  actual_y = start[1]
  prev_position = 'left'
  count = 0
  while lines[actual_y][actual_x] != 'S' || count.zero?
    next_move = find_next_move(lines, prev_position, actual_x, actual_y)
    actual_x = next_move[:next_col]
    actual_y = next_move[:next_row]
    prev_position = next_move[:next_dir]
    count += 1
  end
  count / 2
end

# # # PART TWO # # #

# # # ANSWERS # # #

puts '-----------'
puts answer1(lines)
puts 'Réponse de la partie 1 :'

# puts '-----------'

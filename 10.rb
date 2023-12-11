# # # PART ONE # # #

test1 = %w[
  ..F-7
  ..S7|
  ...LJ
]
# test1_start = [2, 1]
# begin_of_test1 =

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

# méthode pour trouver un caractère à un emplacement donné
# entrée => toutes les lignes, [x, y]
# sortie => '-' ou un autre
def character(lines, coordinates)
  lines[coordinates[1]][coordinates[0]]
end

def handle_exceptions(lines, path_ending, penultimate, last_x, last_y, above, below, left, right)
  if path_ending == '||' && penultimate[1] > last_y
    return above if %w[| 7 F S].include?(character(lines, above))
  elsif path_ending == '||' && penultimate[1] < last_y
    return below if %w[| L J S].include?(character(lines, below))
  elsif path_ending == '--' && penultimate[0] < last_x
    return right if %w[- J 7 S].include?(character(lines, right))
  elsif path_ending == '--' && penultimate[0] > last_x
    return left if %w[- F L S].include?(character(lines, left))
  end
end

todo = [] # "JF", "L7", "LJ", "LF", "J7", "7F"
todo2 = [] # "F7", "FJ", "FL", "7J", "7L", "JL"

# méthode pour donner les coordonnées de la case suivante si c'est possible
# entrée => lines, antépunultième, avant-dernier, dernier
# sortie => [next_x, next_y] or nil
def find_next_tile(lines, path)
  last_x = path[-1][0]
  last_y = path[-1][1]
  above = [last_x, last_y - 1]
  below = [last_x, last_y + 1]
  left = [last_x - 1, last_y]
  right = [last_x + 1, last_y]
  path_ending = "#{lines[path[-2][1]][path[-2][0]]}#{lines[last_y][last_x]}"
  if ['|7', '|J', 'J-', 'J7', '7-', 'FJ', 'L7'].include?(path_ending) && left != path[-2]
    return left if %w[- F L S].include?(character(lines, left))
  elsif ['|L', '|F', 'LF', 'L-', 'F-', 'FL', 'JF', '7L'].include?(path_ending) && right != path[-2]
    return right if %w[- J 7 S].include?(character(lines, right))
  elsif ['-7', '-F', '7|', '7F', 'F|', 'F7', 'JF', 'L7'].include?(path_ending) && below != path[-2]
    return below if %w[| L J S].include?(character(lines, below))
  elsif ['-J', '-L', 'LJ', 'L|', 'J|', 'JL', '7L', '7J', 'FJ'].include?(path_ending) && above != path[-2]
    return above if %w[| 7 F S].include?(character(lines, above))
  elsif ['||', '--'].include?(path_ending)
    return handle_exceptions(lines, path_ending, path[-2], last_x, last_y, above, below, left, right)
  end
end
# puts find_next_tile(test1, [[2, 1], [2, 0], [3, 0], [4, 0], [4, 1], [4, 2], [3, 2], [3, 1]]).to_s

# méthode pour trouver la 2e étape d'un chemin
# entrée => lines, [[1, 1], [1, 2]]
# sortie => [1, 3] or nil
def second_step(lines, path)
  start_x = path[0][0]
  start_y = path[0][1]
  last_x = path[-1][0]
  last_y = path[-1][1]
  last_char = lines[last_y][last_x]
  case last_char
  when '|'
    if last_y > start_y # | is below
      return [last_x, last_y + 1] if %w[| L J].include?(lines[last_y + 1][last_x]) # below
    else # | is above
      return [last_x, last_y - 1] if %w[| 7 F].include?(lines[last_y - 1][last_x]) # above
    end
  when '-'
    if last_x > start_x # - is on the right
      return [last_x + 1, last_y] if %w[- J 7].include?(lines[last_y][last_x + 1]) # right
    else # - is on the left
      return [last_x - 1, last_y] if %w[- L F].include?(lines[last_y][last_x - 1]) # left
    end
  when 'L'
    if last_y > start_y # L is below
      return [last_x + 1, last_y] if %w[- J 7].include?(lines[last_y][last_x + 1]) # right
    else # L is on the left
      return [last_x, last_y - 1] if %w[| 7 F].include?(lines[last_y - 1][last_x]) # above
    end
  when 'J'
    if last_y > start_y # J is below
      return [last_x - 1, last_y] if %w[- L F].include?(lines[last_y][last_x - 1]) # left
    else # J is on the right
      return [last_x, last_y - 1] if %w[| 7 F].include?(lines[last_y - 1][last_x]) # above
    end
  when '7'
    if last_y < start_y # 7 is above
      return [last_x - 1, last_y] if %w[- L F].include?(lines[last_y][last_x - 1]) # left
    else # 7 is on the right
      return [last_x, last_y + 1] if %w[| L J].include?(lines[last_y + 1][last_x]) # below
    end
  when 'F'
    if last_y < start_y # F is above
      return [last_x + 1, last_y] if %w[- J 7].include?(lines[last_y][last_x + 1]) # right
    else # F is on the left
      return [last_x, last_y + 1] if %w[| L J].include?(lines[last_y + 1][last_x]) # below
    end
  end
end

# méthode pour trouver les chemins possibles à partir du départ
# entrée => lines, [1, 1]
# sortie => [[[1, 1], [1, 2], [1, 3]], [[1, 1], [2, 1], [3, 1]]]
def begin_maze(lines, start)
  paths = []
  x = start[0]
  y = start[1]
  # above
  if !y.zero? && %w[| 7 F].include?(lines[y - 1][x])
    if second_step(lines, [start, [x, y - 1]])
      paths << [start, [x, y - 1], second_step(lines, [start, [x, y - 1]])]
    end
  end
  # below
  if y < lines.length - 1 && %w[| L J].include?(lines[y + 1][x])
    if second_step(lines, [start, [x, y + 1]])
      paths << [start, [x, y + 1], second_step(lines, [start, [x, y + 1]])]
    end
  end
  # left
  if !x.zero? && %w[- L F].include?(lines[y][x - 1])
    if second_step(lines, [start, [x - 1, y]])
      paths << [start, [x - 1, y], second_step(lines, [start, [x - 1, y]])]
    end
  end
  # right
  if x < lines[y].length - 1 && %w[- 7 J].include?(lines[y][x + 1])
    if second_step(lines, [start, [x + 1, y]])
      paths << [start, [x + 1, y], second_step(lines, [start, [x + 1, y]])]
    end
  end
  paths
end
# puts begin_maze(test1, [2, 1]).to_s

# méthode pour vérifier si le chemin a fini sa boucle
def back_to_start?(path)
  path[0] == path[-1]
end

# méthode pour aller le plus loin possible à partir d'un chemin
# entrée => lines, [[1, 1], [1, 2], [1, 3]]
# sortie => path en entier
def find_end_of_path(lines, path)
  path_dup = path.dup
  keep_going = 'go'
  while keep_going == 'go'
    next_tile = find_next_tile(lines, path_dup)
    if next_tile.nil?
      keep_going = 'stop'
    else
      path_dup << next_tile
      # puts "next_tile #{next_tile.to_s}"
      keep_going = 'stop' if back_to_start?(path)
    end
  end
  path_dup
end

def through_the_maze(lines)
  start = find_start(lines)
  paths = begin_maze(lines, start)
  if paths.length == 2
    [find_end_of_path(lines, paths[0])]
  else
    paths.map do |path|
      find_end_of_path(lines, path)
    end
  end
end

def answer1(paths)
  longest_path = paths.max_by(&:length)
  (longest_path.length - 1) / 2
end

# # # PART TWO # # #
# # # ANSWERS # # #

# getting the data from the terminal
lines = []
puts "Entrez les lignes (tapez 'fin' pour terminer la saisie) :"
input = gets.chomp

while input.downcase != 'fin'
  lines << input
  input = gets.chomp
end

puts '-----------'
puts 'Réponse de la partie 1 :'
# puts lines[91][39] # 7
# puts lines[92][39] # L
paths = through_the_maze(lines)
puts answer1(paths)
puts '-----------'
# wrong => 35

test1 = %w[
  .....
  .S-7.
  .|.|.
  .L-J.
  .....
]

test1bis = %w[
  -L|F7
  7S-7|
  L|7||
  -L-J|
  L|-JF
]

test2 = %w[
  ..F7.
  .FJ|.
  SJ.L7
  |F--J
  LJ...
]

test2bis = %w[
  7-F7-
  .FJ|7
  SJLL7
  |F--J
  LJ.LJ
]

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

def handle_exceptions(lines, path_ending, antepenultimate, last_x, last_y, above, below, left, right)
  if path_ending == '||'
    if antepenultimate[1] > last_y
      return above if %w[| 7 F].include?(character(lines, above))
    else
      return below if %w[| L J].include?(character(lines, below))
    end
  else
    if antepenultimate[0] > last_x
      return right if %w[- J 7 S].include?(character(lines, right))
    else
      return left if %w[- F L S].include?(character(lines, left))
    end
  end
end

# méthode pour donner les coordonnées de la case suivante si c'est possible
# entrée => lines, antépunultième, avant-dernier, dernier
# sortie => [next_x, next_y] or nil
def find_next_tile(lines, antepenultimate, penultimate, last)
  last_x = last[0]
  last_y = last[1]
  above = [last_x, last_y - 1]
  below = [last_x, last_y + 1]
  left = [last_x - 1, last_y]
  right = [last_x + 1, last_y]
  path_ending = "#{lines[penultimate[1]][penultimate[0]]}#{lines[last_y][last_x]}"
  case path_ending
  when '|7' || '|J' || 'J-' || 'J7' || '7-' || 'FJ'
    return left if %w[- F L S].include?(character(lines, left))
  when '|L' || '|F' || 'LF' || 'L-' || 'JF' || 'F-' || 'FL'
    return right if %w[- J 7 S].include?(character(lines, right))
  when '-7' || '-F' || 'L7' || '7|' || '7F' || 'F|' || 'F7'
    return below if %w[| L J S].include?(character(lines, below))
  when '-J' || '-L' || 'LJ' || 'L|' || 'J|' || 'JL' || '7L' || '7J'
    return above if %w[| 7 F S].include?(character(lines, above))
  when '||' || '--'
    handle_exceptions(lines, path_ending, antepenultimate, last_x, last_y, above, below, left, right)
  end
end

# méthode pour vérifier si le chemin a fini sa boucle
def back_to_start?(path)
  path[0] == path[-1] && path.length > 4
end

# def through_the_maze(lines)
#   start = find_start(lines)
#   paths = [[start]]
# end

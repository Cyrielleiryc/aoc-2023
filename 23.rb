# # # DATA # # #

map1 = []
map2 = []
puts "Entrez les lignes (tapez 'fin' pour terminer la saisie) :"
input = gets.chomp

while input.downcase != 'fin'
  map1 << input.chars
  new_line = input.gsub('v', '.').gsub('<', '.').gsub('>', '.').gsub('^', '.')
  map2 << new_line.chars
  input = gets.chomp
end

test_map = [
  #           2              5              8             11              14            17              20
  ['#', '.', '#', '#', '#', '#', '#', '#', '#', '#', '#', '#', '#', '#', '#', '#', '#', '#', '#', '#', '#', '#', '#'], # 0
  ['#', '.', '.', '.', '.', '.', '.', '.', '#', '#', '#', '#', '#', '#', '#', '#', '#', '.', '.', '.', '#', '#', '#'], # 1
  ['#', '#', '#', '#', '#', '#', '#', '.', '#', '#', '#', '#', '#', '#', '#', '#', '#', '.', '#', '.', '#', '#', '#'], # 2
  ['#', '#', '#', '.', '.', '.', '.', '.', '#', '.', '>', '.', '>', '.', '#', '#', '#', '.', '#', '.', '#', '#', '#'], # 3
  ['#', '#', '#', 'v', '#', '#', '#', '#', '#', '.', '#', 'v', '#', '.', '#', '#', '#', '.', '#', '.', '#', '#', '#'], # 4
  ['#', '#', '#', '.', '>', '.', '.', '.', '#', '.', '#', '.', '#', '.', '.', '.', '.', '.', '#', '.', '.', '.', '#'], # 5
  ['#', '#', '#', 'v', '#', '#', '#', '.', '#', '.', '#', '.', '#', '#', '#', '#', '#', '#', '#', '#', '#', '.', '#'], # 6
  ['#', '#', '#', '.', '.', '.', '#', '.', '#', '.', '#', '.', '.', '.', '.', '.', '.', '.', '#', '.', '.', '.', '#'], # 7
  ['#', '#', '#', '#', '#', '.', '#', '.', '#', '.', '#', '#', '#', '#', '#', '#', '#', '.', '#', '.', '#', '#', '#'], # 8
  ['#', '.', '.', '.', '.', '.', '#', '.', '#', '.', '#', '.', '.', '.', '.', '.', '.', '.', '#', '.', '.', '.', '#'], # 9
  ['#', '.', '#', '#', '#', '#', '#', '.', '#', '.', '#', '.', '#', '#', '#', '#', '#', '#', '#', '#', '#', 'v', '#'], # 10
  ['#', '.', '#', '.', '.', '.', '#', '.', '.', '.', '#', '.', '.', '.', '#', '#', '#', '.', '.', '.', '>', '.', '#'], # 11
  ['#', '.', '#', '.', '#', 'v', '#', '#', '#', '#', '#', '#', '#', 'v', '#', '#', '#', '.', '#', '#', '#', 'v', '#'], # 12
  ['#', '.', '.', '.', '#', '.', '>', '.', '#', '.', '.', '.', '>', '.', '>', '.', '#', '.', '#', '#', '#', '.', '#'], # 13
  ['#', '#', '#', '#', '#', 'v', '#', '.', '#', '.', '#', '#', '#', 'v', '#', '.', '#', '.', '#', '#', '#', '.', '#'], # 14
  ['#', '.', '.', '.', '.', '.', '#', '.', '.', '.', '#', '.', '.', '.', '#', '.', '#', '.', '#', '.', '.', '.', '#'], # 15
  ['#', '.', '#', '#', '#', '#', '#', '#', '#', '#', '#', '.', '#', '#', '#', '.', '#', '.', '#', '.', '#', '#', '#'], # 16
  ['#', '.', '.', '.', '#', '#', '#', '.', '.', '.', '#', '.', '.', '.', '#', '.', '.', '.', '#', '.', '#', '#', '#'], # 17
  ['#', '#', '#', '.', '#', '#', '#', '.', '#', '.', '#', '#', '#', 'v', '#', '#', '#', '#', '#', 'v', '#', '#', '#'], # 18
  ['#', '.', '.', '.', '#', '.', '.', '.', '#', '.', '#', '.', '>', '.', '>', '.', '#', '.', '>', '.', '#', '#', '#'], # 19
  ['#', '.', '#', '#', '#', '.', '#', '#', '#', '.', '#', '.', '#', '#', '#', '.', '#', '.', '#', 'v', '#', '#', '#'], # 20
  ['#', '.', '.', '.', '.', '.', '#', '#', '#', '.', '.', '.', '#', '#', '#', '.', '.', '.', '#', '.', '.', '.', '#'], # 21
  ['#', '#', '#', '#', '#', '#', '#', '#', '#', '#', '#', '#', '#', '#', '#', '#', '#', '#', '#', '#', '#', '.', '#']  # 22
]

# # # PART ONE # # #

# méthode pour donner le départ ou l'arrivée
# /!\ méthode qui modifie la première ou la dernière ligne
def start_finish(cat, lines)
  y = cat == 'start' ? 0 : lines.length - 1
  x = lines[y].index('.')
  lines[y][x] = '#'
  cat == 'start' ? [x, y + 1] : [x, y - 1]
end

# méthode pour trouver toutes les cases possibles
@m_next_tiles = {}
def possible_tiles(origin, lines)
  x_max = lines[0].length - 2
  y_max = lines.length - 2
  x, y = origin
  next_tiles = []
  # top
  if y > 1 && ['.', '^'].include?(lines[y - 1][x])
    next_tiles << [[x, y - 1], 'path'] if lines[y - 1][x] == '.'
    next_tiles << [[x, y - 2], 'slope'] if lines[y - 1][x] == '^'
  end
  # bottom
  if y < y_max && ['.', 'v'].include?(lines[y + 1][x])
    next_tiles << [[x, y + 1], 'path'] if lines[y + 1][x] == '.'
    next_tiles << [[x, y + 2], 'slope'] if lines[y + 1][x] == 'v'
  end
  # left
  if x > 1 && ['.', '<'].include?(lines[y][x - 1])
    next_tiles << [[x - 1, y], 'path'] if lines[y][x - 1] == '.'
    next_tiles << [[x - 2, y], 'slope'] if lines[y][x - 1] == '<'
  end
  # right
  if x < x_max && ['.', '>'].include?(lines[y][x + 1])
    next_tiles << [[x + 1, y], 'path'] if lines[y][x + 1] == '.'
    next_tiles << [[x + 2, y], 'slope'] if lines[y][x + 1] == '>'
  end
  @m_next_tiles[origin] = next_tiles
  next_tiles
end

# méthode pour dire quel chemin on peut prendre en fonction de l'historique
def next_steps(path, lines)
  possible_tiles = @m_next_tiles[path[:origin]] || possible_tiles(path[:origin], lines)
  possible_tiles.reject { |tile| path[:visited].include?(tile[0]) }
end

# méthode qui renvoie 'true' si tous les chemins ont atteint l'arrivée
def all_paths_ended?(paths)
  !paths.map { |path| path[:status] }.include?('in process')
end

# méthode pour trouver tous les chemins possibles entre le départ et l'arrivée
def find_paths(lines)
  start = start_finish('start', lines)
  finish = start_finish('finish', lines)
  paths = [{ visited: [start], origin: start, status: 'in process', slopes: 0 }]
  until all_paths_ended?(paths)
    new_paths = []
    paths.each do |path|
      if path[:status] == 'reached end'
        new_paths << path
        next
      end

      next_steps = next_steps(path, lines)
      next_steps.each do |next_step|
        visited = path[:visited].clone
        slopes = 0 + path[:slopes]
        new_path = { visited: visited, slopes: slopes, status: 'in process' }
        new_path[:visited] << next_step[0]
        new_path[:slopes] += 1 if next_step[1] == 'slope'
        new_path[:origin] = next_step[0]
        new_path[:status] = 'reached end' if next_step[0] == finish
        new_paths << new_path
      end
    end
    paths = new_paths
  end
  paths
end

test2_map = [
  ['#', '.', '#', '#', '#', '#'],
  ['#', '.', '.', '>', '.', '#'],
  ['#', 'v', '#', '#', '.', '#'],
  ['#', '.', '.', '<', '.', '#'],
  ['#', '#', '.', '#', '#', '#'],
]

def path_length(path)
  path[:visited].length + path[:slopes] + 1
end

def answer1(lines)
  paths = find_paths(lines)
  paths.map { |path| path_length(path) }.max
end

# # # PART TWO # # #

# méthode pour trouver toutes les cases possibles
@m_next_tiles2 = {}
def possible_tiles2(origin, lines)
  x_max = lines[0].length - 2
  y_max = lines.length - 2
  x, y = origin
  next_tiles = []
  # top
  if y > 1 && lines[y - 1][x] == '.'
    next_tiles << [x, y - 1] if lines[y - 1][x] == '.'
  end
  # bottom
  if y < y_max && lines[y + 1][x] == '.'
    next_tiles << [x, y + 1] if lines[y + 1][x] == '.'
  end
  # left
  if x > 1 && lines[y][x - 1] == '.'
    next_tiles << [x - 1, y] if lines[y][x - 1] == '.'
  end
  # right
  if x < x_max && lines[y][x + 1] == '.'
    next_tiles << [x + 1, y] if lines[y][x + 1] == '.'
  end
  @m_next_tiles2[origin] = next_tiles
  next_tiles
end

# méthode pour dire quel chemin on peut prendre en fonction de l'historique
def next_steps2(path, lines)
  possible_tiles = @m_next_tiles2[path[:origin]] || possible_tiles2(path[:origin], lines)
  possible_tiles.reject { |tile| path[:visited].include?(tile) }
end

# méthode pour trouver tous les chemins possibles entre le départ et l'arrivée
def find_paths2(lines)
  start = start_finish('start', lines)
  finish = start_finish('finish', lines)
  paths = [{ visited: [start], origin: start, status: 'in process' }]
  until all_paths_ended?(paths)
    new_paths = []
    paths.each do |path|
      if path[:status] == 'reached end'
        new_paths << path
        next
      end

      next_steps = next_steps2(path, lines)
      next_steps.each do |next_step|
        visited = path[:visited].clone
        new_path = { visited: visited, status: 'in process' }
        new_path[:visited] << next_step
        new_path[:origin] = next_step
        new_path[:status] = 'reached end' if next_step == finish
        new_paths << new_path
      end
    end
    paths = new_paths
  end
  paths
end

test2_map = [
  ['#', '.', '#', '#', '#', '#'],
  ['#', '.', '.', '>', '.', '#'],
  ['#', 'v', '#', '#', '.', '#'],
  ['#', '.', '.', '<', '.', '#'],
  ['#', '#', '.', '#', '#', '#'],
]

def answer2(lines)
  paths = find_paths(lines)
  paths.map { |path| path[:visited].length + 1 }.max
end

# # # ANSWERS # # #

# puts '-----------'
# puts 'Réponse de la partie 1 :'
# puts answer1(map1)
puts '-----------'

puts 'Réponse de la partie 2 :'
puts answer2(map2)
puts '-----------'

# méthode pour
# entrée =>
# sortie =>

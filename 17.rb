# # # DATA # # #

# map = []
# puts "Entrez les lignes (tapez 'fin' pour terminer la saisie) :"
# input = gets.chomp

# while input.downcase != 'fin'
#   map << input.chars.map(&:to_i)
#   input = gets.chomp
# end
# x_max = map[0].length - 1
# y_max = map.length - 1

test_map = [
  [2, 4, 1, 3, 4, 3, 2, 3, 1, 1, 3, 2, 3],
  [3, 2, 1, 5, 4, 5, 3, 5, 3, 5, 6, 2, 3],
  [3, 2, 5, 5, 2, 4, 5, 6, 5, 4, 2, 5, 4],
  [3, 4, 4, 6, 5, 8, 5, 8, 4, 5, 4, 5, 2],
  [4, 5, 4, 6, 6, 5, 7, 8, 6, 7, 5, 3, 6],
  [1, 4, 3, 8, 5, 9, 8, 7, 9, 8, 4, 5, 4],
  [4, 4, 5, 7, 8, 7, 6, 9, 8, 7, 7, 6, 6],
  [3, 6, 3, 7, 8, 7, 7, 9, 7, 9, 6, 5, 3],
  [4, 6, 5, 4, 9, 6, 7, 9, 8, 6, 8, 8, 7],
  [4, 5, 6, 4, 6, 7, 9, 9, 8, 6, 4, 5, 3],
  [1, 2, 2, 4, 6, 8, 6, 8, 6, 5, 5, 6, 3],
  [2, 5, 4, 6, 5, 4, 8, 8, 8, 7, 7, 3, 5],
  [4, 3, 2, 2, 6, 7, 4, 6, 5, 5, 5, 3, 3]
]
@test_x_max = test_map[0].length - 1
@test_y_max =test_map.length - 1

DIRECTIONS = {
  # origin: [possible directions]
  'top' => %w[left right bottom],
  'bottom' => %w[left right top],
  'left' => %w[right bottom top],
  'right' => %w[left bottom top]
}.freeze

# # # PART ONE # # #

# méthode pour trouver les cases suivante en fonction de la position et de la provenance
# entrée => [1, 1], 'top', 'bottom', [[0, 0], etc]
# sortie => [{:position=>[0, 1], :origin=>"right"}, {:position=>[2, 1], :origin=>"left"}]
def next_blocks(actual_pos, origin, forbidden_dir, visited)
  poss_dir = DIRECTIONS[origin].reject { |dir| dir == forbidden_dir }
  next_blocks = []
  x = actual_pos[0]
  y = actual_pos[1]
  poss_dir.each do |dir|
    if dir == 'bottom' && y < @test_y_max && !visited.include?([x, y + 1])
      next_blocks << { position: [x, y + 1], origin: 'top' }
    elsif dir == 'top' && y.positive? && !visited.include?([x, y - 1])
      next_blocks << { position: [x, y - 1], origin: 'bottom' }
    elsif dir == 'right' && x < @test_y_max && !visited.include?([x + 1, y])
      next_blocks << { position: [x + 1, y], origin: 'left' }
    elsif dir == 'left' && x.positive? && !visited.include?([x - 1, y])
      next_blocks << { position: [x - 1, y], origin: 'right' }
    end
  end
  next_blocks
end

# chemin = {
  #   total: 15,
  #   blocks_visited: [[x, y], etc],
  #   last_move: {
  #     position: [x, y],
  #     origin: 'top'
  #   },
  #   three_last_origins: ['top', 'right', 'left']
  # }
test_paths = {
  1 => { total: 7, visited: [[0, 0], [1, 0], [2, 0]], status: 'in progress',
    last_move: { position: [2, 0], origin: 'left' }, three_last: ['left', 'left', 'left'] },
  2 => { total: 8, visited: [[0, 0], [1, 0], [1, 1]], status: 'in progress',
    last_move: { position: [1, 1], origin: 'top' }, three_last: ['left', 'left', 'top'] },
  3 => { total: 8, visited: [[0, 0], [0, 1], [0, 2]], status: 'in progress',
    last_move: { position: [0, 2], origin: 'top' }, three_last: ['top', 'top', 'top'] },
  4 => { total: 8, visited: [[0, 0], [1, 0], [1, 1]], status: 'in progress',
    last_move: { position: [1, 1], origin: 'left' }, three_last: ['left', 'top', 'left'] }
}

# méthode pour trouver s'il y a une direction interdite
def forbidden_dir(path)
  three_last_moves = path[:three_last]
  three_last_moves.length == 3 && three_last_moves.uniq.length == 1 ? three_last_moves[0] : ''
end

# méthode pour trouver le chemin qui a le total le plus bas
def find_lowest_path(paths)
  totals = paths.values.map { |path| path[:total] }
  lowest_path = paths.values.find { |path| path[:total] == totals.min }
  paths.key(lowest_path)
end

# méthode pour donner les next blocks pour le chemin trouvé
@m_next_blocks = {}
def create_next_blocks(path)
  actual_pos = path[:last_move][:position]
  origin = path[:last_move][:origin]
  forbidden_dir = forbidden_dir(path)
  visited = path[:visited]
  next_blocks = next_blocks(actual_pos, origin, forbidden_dir, visited)
  @m_next_blocks[path] = next_blocks
  next_blocks
end

# méthode pour mettre à jour les chemins avec une action
def update_path(map, path, next_block)
  path[:total] += map[next_block[:position][1]][next_block[:position][0]]
  path[:visited] << next_block[:position]
  path[:last_move] = next_block
  path[:three_last] << next_block[:origin]
  path[:three_last].delete_at(0) if path[:three_last].length > 3
  path[:status] = 'reached end' if path[:last_move][:position] == [@test_x_max, @test_y_max]
  path
end

def deep_copy(o)
  Marshal.load(Marshal.dump(o))
end

@m_next_moves = {}
def next_move(map, key, path)
  puts "next_move with n°#{key} > #{path}"
  new_paths = []
  next_blocks = @m_next_blocks[path] || create_next_blocks(path)
  if next_blocks[0].nil?
    path[:status] = 'dead end'
    return [key, path]
  end
  if next_blocks.length > 1
    copy_of_path = deep_copy(path)
    next_blocks.each_with_index do |next_block, index|
      next if index.zero?

      new_paths << update_path(map, copy_of_path, next_block)
    end
  end
  new_paths << update_path(map, path, next_blocks[0])
  puts "new_paths = #{new_paths}"
  total_min = new_paths.map { |new_path| new_path[:total] }.min
  best_paths = new_paths.select { |new_path| new_path[:total] == total_min }
  puts "best_paths = #{best_paths}"
  @m_next_moves[[key, path]] = best_paths
  best_paths
end

# méthode qui cherche toutes les actions possibles pour chaque chemin et rend la meilleure option
def next_action(map, paths)
  new_paths = []
  last_key = paths.keys.max
  paths.each do |key, path|
    next_best_moves = @m_next_moves[[key, path]] || next_move(map, key, path)
    new_paths << [key, next_best_moves]
  end
  paths_copy = deep_copy(paths)
  new_paths.each do |new_path|
    if new_path[1].size > 1
      new_path[1].each_with_index do |n_new_path, index|
        next if index.zero?

        last_key += 1
        paths_copy[last_key] = n_new_path
      end
    end
    paths_copy[new_path[0]] = new_path[1][0]
  end
  lowest_path_key = find_lowest_path(paths_copy)
  # puts "best move = #{lowest_path_key} > #{paths[lowest_path_key]}"
  puts "-----------------------"
  { key: lowest_path_key, path: paths_copy[lowest_path_key] }
end

# méthode pour dire si un chemin a fini son parcours
def path_ended(paths)
  paths.values.find { |path| path[:status] == 'reached end' }
end

# méthode pour trouver le chemin qui a le total le plus bas
def find_dead_end_path(paths)
  dead_end = paths.values.find { |path| path[:status] == 'dead end' }
  paths.key(dead_end)
end

def update_paths(map, paths)
  puts "paths before > #{paths}"
  best_action = next_action(map, paths)
  puts "best_action > #{best_action}"
  paths[best_action[:key]] = best_action[:path]
  puts "paths after > #{paths}"
  dead_end_key = find_dead_end_path(paths)
  paths.delete(dead_end_key)
  paths
end
test_paths_start = {
  1=>{
    :total=>5,
    :visited=>[[0, 0], [1, 0], [2, 0]],
    :status=>"in progress",
    :last_move=>{:position=>[2, 0], :origin=>"left"},
    :three_last=>["left", "left", "left"]
  },
  2=>{
    :total=>5,
    :visited=>[[0, 0], [0, 1], [1, 1]],
    :status=>"in progress",
    :last_move=>{:position=>[1, 1], :origin=>"left"},
    :three_last=>["left", "top", "left"]
  }
}
puts update_paths(test_map, test_paths_start).to_s

def answer1(map)
  paths = {
    1 => {
      total: 4,
      visited: [[0, 0], [1, 0]],
      status: 'in progress',
      last_move: { position: [1, 0], origin: 'left' },
      three_last: ['left', 'left']
    },
    2 => {
      total: 3,
      visited: [[0, 0], [0, 1]],
      status: 'in progress',
      last_move: { position: [0, 1], origin: 'top' },
      three_last: ['left', 'top']
    }
  }
  # count = 0
  until path_ended(paths)

    # count += 1
    # puts "#{count} > #{paths.values.map { |path| path[:total] }}"
  end
  path_ended(paths)
end
# puts answer1(test_map)

# # # PART TWO # # #

# # # ANSWERS # # #

# puts '-----------'
# puts 'Réponse de la partie 1 :'
# puts '-----------'

# puts 'Réponse de la partie 2 :'
# puts '-----------'

# méthode pour
# entrée =>
# sortie =>

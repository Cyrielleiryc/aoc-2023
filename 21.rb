# # # DATA # # #

map = []
puts "Entrez les lignes (tapez 'fin' pour terminer la saisie) :"
input = gets.chomp

while input.downcase != 'fin'
  map << input
  input = gets.chomp
end

test_map = [
  '...........',
  '.....###.#.',
  '.###.##..#.',
  '..#.#...#..',
  '....#.#....',
  '.##..S####.',
  '.##..#...#.',
  '.......##..',
  '.##.#.####.',
  '.##..##.##.',
  '...........',
]

# # # PART ONE # # #

# méthode pour trouver le départ et remplacer 'S' par '.'
# sortie => [x, y] /!\ la carte a été modifiée
def start(map)
  start = []
  map.each_with_index do |line, y|
    next unless line.include?('S')

    start << line.index('S')
    start << y
  end
  map[start[1]] = map[start[1]].gsub('S', '.')
  start
end

# méthode pour trouver les positions possibles à partir d'un point
@m_next_tiles = {}
def next_tiles(pos, map)
  x, y = pos
  x_max = map[0].length - 1
  y_max = map.length - 1
  next_tiles = []
  next_tiles << [x - 1, y] if !x.zero? && map[y][x - 1] == '.' # && !@m_next_tiles.keys.include?([x - 1, y])
  next_tiles << [x + 1, y] if x != x_max && map[y][x + 1] == '.' # && !@m_next_tiles.keys.include?([x + 1, y])
  next_tiles << [x, y - 1] if !y.zero? && map[y - 1][x] == '.' # && !@m_next_tiles.keys.include?([x, y - 1])
  next_tiles << [x, y + 1] if y != y_max && map[y + 1][x] == '.' # && !@m_next_tiles.keys.include?([x, y + 1])
  @m_next_tiles[pos] = next_tiles
  next_tiles.reject { |tile| @m_next_tiles.keys.include?(tile) }
end

# méthode pour trouver toutes les possibilités pour un pas
def one_step(arr, map)
  next_tiles = []
  arr.each do |pos|
    result = @m_next_tiles[pos] || next_tiles(pos, map)
    next_tiles += result
  end
  next_tiles.uniq
end

def answer1(map, steps)
  start = start(map)
  pos = [start]
  evens = [start]
  odds = []
  steps.times do |i|
    pos = one_step(pos, map)
    if (i + 1).even?
      evens += pos
    else
      odds += pos
    end
  end
  return evens.length if steps.even?
  return odds.length if steps.odd?
end

# # # PART TWO # # #

# # # ANSWERS # # #

puts '-----------'
puts 'Réponse de la partie 1 :'
puts answer1(map, 64)
# puts answer1(test_map, 6)
puts '-----------'

# puts 'Réponse de la partie 2 :'
# puts '-----------'

# méthode pour
# entrée =>
# sortie =>

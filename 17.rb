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
# entrée => [1, 1], 'top', 'bottom'
# sortie => [{:next_block=>[0, 1], :next_origin=>"right"}, {:next_block=>[2, 1], :next_origin=>"left"}]
def next_blocks(actual_pos, origin, forbidden_dir = '')
  poss_dir = DIRECTIONS[origin].reject{ |dir| dir == forbidden_dir }
  next_blocks = []
  x = actual_pos[0]
  y = actual_pos[1]
  poss_dir.each do |dir|
    if dir == 'bottom' && y < @test_y_max
      next_blocks << { next_block: [x, y + 1], next_origin: 'top'}
    elsif dir == 'top' && y.positive?
      next_blocks << { next_block: [x, y - 1], next_origin: 'bottom'}
    elsif dir == 'right' && x < @test_y_max
      next_blocks << { next_block: [x + 1, y], next_origin: 'left'}
    elsif dir == 'left' && x.positive?
      next_blocks << { next_block: [x - 1, y], next_origin: 'right'}
    end
  end
  next_blocks
end

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

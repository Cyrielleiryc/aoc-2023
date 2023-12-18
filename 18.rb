# # # DATA # # #

# digplan = []
# colors = []
# puts "Entrez les lignes (tapez 'fin' pour terminer la saisie) :"
# input = gets.chomp

# while input.downcase != 'fin'
#   digplan << input.split(' ')[0..1]
#   digplan.map! { |step| [step[0], step[1].to_i] }
#   colors << input.split(' ')[-1].gsub('(', '').gsub(')', '')
#   input = gets.chomp
# end

test_input = [
  'R 6 (#70c710)',
  'D 5 (#0dc571)',
  'L 2 (#5713f0)',
  'D 2 (#d2c081)',
  'R 2 (#59c680)',
  'D 2 (#411b91)',
  'L 5 (#8ceee2)',
  'U 2 (#caa173)',
  'L 1 (#1b58a2)',
  'U 2 (#caa171)',
  'R 2 (#7807d2)',
  'U 3 (#a77fa3)',
  'L 2 (#015232)',
  'U 2 (#7a21e3)'
]
test_colors = %w[#70c710 #0dc571 #5713f0 #d2c081 #59c680 #411b91 #8ceee2 #caa173 #1b58a2 #caa171 #7807d2 #a77fa3 #015232 #7a21e3]
test_digplan = [
  ['R', 6],
  ['D', 5],
  ['L', 2],
  ['D', 2],
  ['R', 2],
  ['D', 2],
  ['L', 5],
  ['U', 2],
  ['L', 1],
  ['U', 2],
  ['R', 2],
  ['U', 3],
  ['L', 2],
  ['U', 2]
]
test_terrain = [
  ['#', '#', '#', '#', '#', '#', '#'],
  ['#', '.', '.', '.', '.', '.', '#'],
  ['#', '#', '#', '.', '.', '.', '#'],
  ['.', '.', '#', '.', '.', '.', '#'],
  ['.', '.', '#', '.', '.', '.', '#'],
  ['#', '#', '#', '.', '#', '#', '#'],
  ['#', '.', '.', '.', '#', '.', '.'],
  ['#', '#', '.', '.', '#', '#', '#'],
  ['.', '#', '.', '.', '.', '.', '#'],
  ['.', '#', '#', '#', '#', '#', '#']
]
test_terrain_int = [
  ['#', '#', '#', '#', '#', '#', '#'],
  ['#', '#', '#', '#', '#', '#', '#'],
  ['#', '#', '#', '#', '#', '#', '#'],
  ['.', '.', '#', '#', '#', '#', '#'],
  ['.', '.', '#', '#', '#', '#', '#'],
  ['#', '#', '#', '#', '#', '#', '#'],
  ['#', '#', '#', '#', '#', '.', '.'],
  ['#', '#', '#', '#', '#', '#', '#'],
  ['.', '#', '#', '#', '#', '#', '#'],
  ['.', '#', '#', '#', '#', '#', '#']
]

# # # PART ONE # # #

# méthodes pour suivre les instructions du digplan
def find_position(terrain)
  terrain.each_with_index do |line, y|
    next unless line.include?('P')

    line.each_with_index do |char, x|
      next unless char == 'P'

      return [x, y]
    end
  end
end

def add_line_below(terrain)
  new_line = Array.new(terrain[0].length, '.')
  terrain << new_line
  terrain
end

def add_line_above(terrain)
  new_line = Array.new(terrain[0].length, '.')
  terrain.insert(0, new_line)
  terrain
end

def add_column_right(terrain)
  terrain.map { |line| line << '.'}
end

def add_column_left(terrain)
  terrain.map { |line| line.insert(0, '.') }
end

def one_step(terrain, stage)
  position = find_position(terrain)
  terrain[position[1]][position[0]] = '#'
  stage[1].times do
    x_max = terrain[0].length - 1
    y_max = terrain.length - 1
    if stage[0] == 'D'
      terrain = add_line_below(terrain) if position[1] == y_max
      position[1] += 1
    elsif stage[0] == 'U'
      if position[1].zero?
        terrain = add_line_above(terrain)
        position[1] += 1
      end
      position[1] -= 1
    elsif stage[0] == 'R'
      terrain = add_column_right(terrain) if position[0] == x_max
      position[0] += 1
    elsif stage[0] == 'L'
      if position[0].zero?
        terrain = add_column_left(terrain)
        position[0] += 1
      end
      position[0] -= 1
    end
    terrain[position[1]][position[0]] = '#'
  end
  terrain[position[1]][position[0]] = 'P'
  terrain
end

def follow_plan(digplan)
  terrain = [['P']]
  digplan.each do |stage|
    terrain = one_step(terrain, stage)
  end
  last_position = find_position(terrain)
  terrain[last_position[1]][last_position[0]] = '#'
  terrain
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

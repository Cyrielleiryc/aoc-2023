# # # DATA # # #

# @contraption = []
# puts "Entrez les lignes (tapez 'fin' pour terminer la saisie) :"
# input = gets.chomp

# while input.downcase != 'fin'
#   @contraption << input.gsub('\', 'L')
#   input = gets.chomp
# end
# @x_max = @contraption[0].length - 1
# @y_max = @contration.length - 1

@contraption = [
  '.|...L....',
  '|.-.L.....',
  '.....|-...',
  '........|.',
  '..........',
  '.........L',
  '..../.LL..',
  '.-.-/..|..',
  '.|....-|.L',
  '..//.|....'
]
@x_max = @contraption[0].length - 1
@y_max = @contraption.length - 1

# # # PART ONE # # #

DIRECTIONS = {
  '.' => {
    'top' => ['bottom'],
    'bottom' => ['top'],
    'right' => ['left'],
    'left' => ['right']
  },
  '/' => {
    'top' => ['left'],
    'bottom' => ['right'],
    'right' => ['bottom'],
    'left' => ['top']
  },
  'L' => {
    'top' => ['right'],
    'bottom' => ['left'],
    'right' => ['top'],
    'left' => ['bottom']
  },
  '-' => {
    'top' => ['right', 'left'],
    'bottom' => ['right', 'left'],
    'right' => ['left'],
    'left' => ['right']
  },
  '|' => {
    'top' => ['bottom'],
    'bottom' => ['top'],
    'right' => ['top', 'bottom'],
    'left' => ['top', 'bottom']
  }
}.freeze

# méthode pour trouver les tuiles suivantes possibles
# entrée => actual_x, actual_y, direction
# sortie => { next_tile: [x, y], next_origin: '' }
@m_next_tile = {}
def next_tile(actual_x, actual_y, direction)
  next_tile = nil
  next_origin = ''
  if direction == 'right' && actual_x < @x_max
    next_tile = [actual_x + 1, actual_y]
    next_origin = 'left'
  elsif direction == 'left' && actual_x.positive?
    next_tile = [actual_x - 1, actual_y]
    next_origin = 'right'
  elsif direction == 'bottom' && actual_y < @y_max
    next_tile = [actual_x, actual_y + 1]
    next_origin = 'top'
  elsif direction == 'top' && actual_y.positive?
    next_tile = [actual_x, actual_y - 1]
    next_origin = 'bottom'
  end
  @m_next_tile[[actual_x, actual_y, direction]] = { next_tile: next_tile, next_origin: next_origin }
  { next_tile: next_tile, next_origin: next_origin }
end

# méthode pour donner les coordonnées de la (ou les) case.s suivante.s
# entrée => 0, 0, 'left'                               || 1, 7, 'top'
# sortie => [{next_tile: [1, 0], next_origin: "left"}] || [{next_tile: [2, 7], next_origin: "left"}, {next_tile: [0, 7], next_origin: "right"}]
@m_next_move = {}
def next_move(actual_x, actual_y, origin)
  actual_tile = @contraption[actual_y][actual_x]
  possible_directions = DIRECTIONS[actual_tile][origin]
  next_move = []
  possible_directions.each do |direction|
    next_tile = @m_next_tile[[actual_x, actual_y, direction]] || next_tile(actual_x, actual_y, direction)
    if next_tile[:next_tile]
      next_move << next_tile
    end
  end
  @m_next_move[[actual_x, actual_y, origin]] = next_move
  next_move
end
# puts next_move(1, 7, 'top')[1]

# méthode pour trouver la première direction du rayon
def second_tile(tile)
  if tile == '.' || tile == '-'
    { second_x: 1, second_y: 0, origin: 'left'}
  elsif tile == '|' || tile == 'L'
    { second_x: 0, second_y: 1, origin: 'top'}
  end
end

# méthode pour suivre la trace du rayon
# entrée => contraption
# sortie => nombre tuiles où le rayon est passé
def follow_beam
  second_tile = second_tile(@contraption[0][0])
  actual_x = second_tile[:second_x]
  actual_y = second_tile[:second_y]
  origin = second_tile[:origin]
  energized = [[0, 0], [actual_x, actual_y]]
  next_move = @m_next_move[[actual_x, actual_y, origin]] || next_move(actual_x, actual_y, origin)
  beams_followed = [next_move]
  # puts next_move.to_s
  beams_followed.each do |next_move|
    until next_move.empty?
      if next_move.length == 2
        beams_followed << next_move[1]
        next_move = [next_move[0]]
      end
      energized << next_move[0][:next_tile]
      actual_x = next_move[0][:next_tile][0]
      actual_y = next_move[0][:next_tile][1]
      origin = next_move[0][:next_origin]
      next_move = @m_next_move[[actual_x, actual_y, origin]] || next_move(actual_x, actual_y, origin)
    end
  end
  puts beams_followed.to_s
  puts "--------------------"
  energized
end
puts follow_beam.to_s

# on regarde le mouvement suivant
  # l'array contient un objet
    # on rajoute :next_tile dans les energized
    # on met à jour actual_x, actual_y et origin
    # on recommence
  # l'array contient 2 objets
    # on considère le premier pour faire comme l'étape 1
    # on garde le 2e objet dans un array
  # l'array est vide, on stoppe la boucle

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

# # # PART ONE # # #

# méthode pour faire déplacer les O vers la gauche
TILTED_LINES = {}
def tilt_line(line)
  pieces = []
  i = 0
  while i < line.length
    if line[i] == '#'
      pieces << ['#']
      i += 1
    else
      piece = [line[i]]
      i += 1
      while line[i] == 'O' || line[i] == '.'
        piece << line[i]
        i += 1
      end
      pieces << piece.sort.reverse
    end
  end
  new_line = pieces.map(&:join).join
  TILTED_LINES[line] = new_line
  new_line
end

def calculate_line_score(line)
  l = line.length
  count = 0
  line.chars.each_with_index do |char, index|
    next unless char == 'O'

    count += (l - index)
  end
  count
end

def answer1(platform)
  north_platform = platform.map(&:chars).transpose.map(&:join)
  north_platform.map { |line| calculate_line_score(tilt_line(line)) }.sum
end

# # # PART TWO # # #

# méthode pour tilter une grille entière
def tilt_platform(grid)
  tilted_grid = []
  grid.each do |line|
    tilted_line = TILTED_LINES[line] || tilt_line(line)
    tilted_grid << tilted_line
  end
  tilted_grid
end

# méthode pour faire tourner la plateforme dans les 4 directions
# entrée => plateforme de départ
# sortie => plateforme après un cycle complet
CYCLED_PLATFORMS = {}
def one_cycle(platform)
  before_north = tilt_platform(platform.map(&:chars).transpose.map(&:join))
  after_north = before_north.map(&:chars).transpose.map(&:join)
  west = tilt_platform(after_north)
  before_south = tilt_platform(west.map(&:chars).transpose.map(&:reverse).map(&:join))
  after_south = before_south.map(&:chars).map(&:reverse).transpose.map(&:join)
  before_east = tilt_platform(after_south.map(&:reverse))
  after_east = before_east.map(&:reverse)
  CYCLED_PLATFORMS[platform] = after_east
  after_east
end

def calculate_platform_score(platform)
  l = platform.length
  count = 0
  platform.each_with_index do |line, line_index|
    n = line.count('O')
    count += ((l - line_index) * n)
  end
  count
end

def answer2(platform, numbers_of_cycles)
  numbers_of_cycles.times do
    platform = CYCLED_PLATFORMS[platform] || one_cycle(platform)
  end
  calculate_platform_score(platform)
end

# # # ANSWERS # # #

# getting the data from the terminal
platform = []
puts "Entrez les lignes (tapez 'fin' pour terminer la saisie) :"
input = gets.chomp

while input.downcase != 'fin'
  platform << input
  input = gets.chomp
end

puts '-----------'
puts 'Réponse de la partie 1 :'
puts answer1(platform)
puts '-----------'

puts 'Réponse de la partie 2 :'
puts answer2(platform, 1000000000)
puts '-----------'

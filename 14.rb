# # # PART ONE # # #

test1 = %w[
  O....#....
  O.OO#....#
  .....##...
  OO.#O....O
  .O.....O#.
  O.#..O.#.#
  ..O..#O..O
  .......O..
  #....###..
  #OO..#....
]
@test1_tr = [
  'OO.O.O..##',
  '...OO....O',
  '.O...#O..O',
  '.O.#......',
  '.#.O......',
  '#.#..O#.##',
  '..#...O.#.',
  '....O#.O#.',
  '....#.....',
  '.#.O.#O...'
] # test1 transposé

# méthode pour faire déplacer les O vers la gauche
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
  pieces.map(&:join).join
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
  puts north_platform == @test1_tr
  north_platform.map { |line| calculate_line_score(tilt_line(line)) }.sum
end

# # # PART TWO # # #

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

# puts 'Réponse de la partie 2 :'
# puts '-----------'

# méthode pour
# entrée =>
# sortie =>

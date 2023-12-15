# # # PART ONE # # #

# méthode pour multiplier les lignes vides
def double_empty_lines(arr, factor)
  double = []
  arr.each do |line|
    if line.count('.') == line.length
      factor.times { double << line }
    else
      double << line
    end
  end
  double
end

# méthode pour expandre l'univers
def expand_universe(arr, factor)
  vertical_expansion = double_empty_lines(arr.transpose, factor)
  double_empty_lines(vertical_expansion.transpose, factor)
end

# méthode pour faire la liste des galaxies avec leurs coordonnées
# entrée => [[line1], [line2], etc]
# sortie => { 1 => [x, y], 2 => [x, y], etc}
def list_galaxies(arr)
  counter = 1
  galaxies = {}
  arr.each_with_index do |line, y|
    line.each_with_index do |char, x|
      next unless char == '#'

      galaxies[counter] = [x, y]
      counter += 1
    end
  end
  galaxies
end

# méthode pour créer les paires, calculer la distance entre chaque et faire la somme de tout
# entrée => { 1 => [x, y], 2 => [x, y], etc}
# sortie => 374
def answer1(galaxies)
  number_of_galaxies = galaxies.keys.length
  pairs = (1..number_of_galaxies).to_a.combination(2).to_a
  distances = []
  pairs.each do |pair|
    x_start = galaxies[pair[0]][0]
    y_start = galaxies[pair[0]][1]
    x_end = galaxies[pair[1]][0]
    y_end = galaxies[pair[1]][1]
    distance = (x_end - x_start).abs + (y_end - y_start).abs
    distances << distance
  end
  distances.sum
end

# # # PART TWO # # #

# méthode pour trouver les indexes de chaque ligne ou colonne vide
# entrée => giant_image
# sortie => { 'empty_rows' => [3, 7], 'empty_columns' => [2, 5, 8] }
def find_empty_lines(arr)
  output = { 'empty_rows' => [], 'empty_columns' => [] }
  arrays = [arr.dup, arr.dup.transpose]
  arrays.each_with_index do |array, index|
    array.each_with_index do |line, position|
      next unless line.count('.') == line.length

      key = index.zero? ? 'empty_rows' : 'empty_columns'
      output[key] << position
    end
  end
  output
end

# méthode pour calculer la distance entre 2 galaxies données
# entrée => [0, 2], [9, 6]
# sortie => 17 (si facteur 2), 49 (f = 10), 409 (f = 100)
def calculate_distance(galaxy1, galaxy2, factor, empty_lines)
  deltas = []
  coordinates = [galaxy1.dup, galaxy2.dup].transpose.map(&:sort)
  coordinates.each_with_index do |axe, index|
    range = axe[0]..axe[1]
    key = index.zero? ? 'empty_columns' : 'empty_rows'
    n = empty_lines[key].select { |r| range.include?(r) }.length
    deltas << ((n * factor) - n + axe[1] - axe[0])
  end
  deltas.sum
end

def answer2(galaxies, empty_lines, factor)
  number_of_galaxies = galaxies.keys.length
  pairs = (1..number_of_galaxies).to_a.combination(2).to_a
  distances = []
  pairs.each do  |pair|
    distances << calculate_distance(galaxies[pair[0]], galaxies[pair[1]], factor, empty_lines)
  end
  distances.sum
end

# # # ANSWERS # # #

# getting the data from the terminal
image_received = []
puts "Entrez les lignes (tapez 'fin' pour terminer la saisie) :"
input = gets.chomp

while input.downcase != 'fin'
  image_received << input.chars
  input = gets.chomp
end

puts '-----------'
puts 'Réponse de la partie 1 :'
factor_part_one = 2
expanded_universe = expand_universe(image_received, factor_part_one)
all_galaxies = list_galaxies(expanded_universe)
puts answer1(all_galaxies)
puts '-----------'

puts 'Réponse de la partie 2 :'
factor_part_two = 1000000
empty = find_empty_lines(image_received)
all_galaxies = list_galaxies(image_received)
puts answer2(all_galaxies, empty, factor_part_two)
puts '-----------'

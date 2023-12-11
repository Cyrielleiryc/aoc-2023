# # # PART ONE # # #

giant_image = [
  [".", ".", ".", "#", ".", ".", ".", ".", ".", "."],
  [".", ".", ".", ".", ".", ".", ".", "#", ".", "."],
  ["#", ".", ".", ".", ".", ".", ".", ".", ".", "."],
  [".", ".", ".", ".", ".", ".", ".", ".", ".", "."],
  [".", ".", ".", ".", ".", ".", "#", ".", ".", "."],
  [".", "#", ".", ".", ".", ".", ".", ".", ".", "."],
  [".", ".", ".", ".", ".", ".", ".", ".", ".", "#"],
  [".", ".", ".", ".", ".", ".", ".", ".", ".", "."],
  [".", ".", ".", ".", ".", ".", ".", "#", ".", "."],
  ["#", ".", ".", ".", "#", ".", ".", ".", ".", "."]
]

after_expansion = [
  [".", ".", ".", ".", "#", ".", ".", ".", ".", ".", ".", ".", "."],
  [".", ".", ".", ".", ".", ".", ".", ".", ".", "#", ".", ".", "."],
  ["#", ".", ".", ".", ".", ".", ".", ".", ".", ".", ".", ".", "."],
  [".", ".", ".", ".", ".", ".", ".", ".", ".", ".", ".", ".", "."],
  [".", ".", ".", ".", ".", ".", ".", ".", ".", ".", ".", ".", "."],
  [".", ".", ".", ".", ".", ".", ".", ".", "#", ".", ".", ".", "."],
  [".", "#", ".", ".", ".", ".", ".", ".", ".", ".", ".", ".", "."],
  [".", ".", ".", ".", ".", ".", ".", ".", ".", ".", ".", ".", "#"],
  [".", ".", ".", ".", ".", ".", ".", ".", ".", ".", ".", ".", "."],
  [".", ".", ".", ".", ".", ".", ".", ".", ".", ".", ".", ".", "."],
  [".", ".", ".", ".", ".", ".", ".", ".", ".", "#", ".", ".", "."],
  ["#", ".", ".", ".", ".", "#", ".", ".", ".", ".", ".", ".", "."]
]

universe_with_numbers = [
  [".", ".", ".", ".", "1", ".", ".", ".", ".", ".", ".", ".", "."],
  [".", ".", ".", ".", ".", ".", ".", ".", ".", "2", ".", ".", "."],
  ["3", ".", ".", ".", ".", ".", ".", ".", ".", ".", ".", ".", "."],
  [".", ".", ".", ".", ".", ".", ".", ".", ".", ".", ".", ".", "."],
  [".", ".", ".", ".", ".", ".", ".", ".", ".", ".", ".", ".", "."],
  [".", ".", ".", ".", ".", ".", ".", ".", "4", ".", ".", ".", "."],
  [".", "5", ".", ".", ".", ".", ".", ".", ".", ".", ".", ".", "."],
  [".", ".", ".", ".", ".", ".", ".", ".", ".", ".", ".", ".", "6"],
  [".", ".", ".", ".", ".", ".", ".", ".", ".", ".", ".", ".", "."],
  [".", ".", ".", ".", ".", ".", ".", ".", ".", ".", ".", ".", "."],
  [".", ".", ".", ".", ".", ".", ".", ".", ".", "7", ".", ".", "."],
  ["8", ".", ".", ".", ".", "9", ".", ".", ".", ".", ".", ".", "."]
]

galaxies = {
  1 => [4, 0],
  2 => [9, 1],
  3 => [0, 2],
  4 => [8, 5],
  5 => [1, 6],
  6 => [12, 7],
  7 => [9, 10],
  8 => [0, 11],
  9 => [5, 11]
}
# méthode pour doubler les lignes vides
def double_empty_lines(arr)
  double = []
  arr.each do |line|
    if line.count('.') == line.length
      2.times { double << line }
    else
      double << line
    end
  end
  double
end

# méthode pour expandre l'univers
def expand_universe(arr)
  vertical_expansion = double_empty_lines(arr.transpose)
  double_empty_lines(vertical_expansion.transpose)
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
expanded_universe = expand_universe(image_received)
all_galaxies = list_galaxies(expanded_universe)
puts answer1(all_galaxies)
puts '-----------'

# puts 'Réponse de la partie 2 :'
# puts '-----------'

# méthode pour
# entrée =>
# sortie =>

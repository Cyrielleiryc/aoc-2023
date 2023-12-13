# # # PART ONE # # #

test_pattern1 = [
  ["#", ".", "#", "#", ".", ".", "#", "#", "."],
  [".", ".", "#", ".", "#", "#", ".", "#", "."],
  ["#", "#", ".", ".", ".", ".", ".", ".", "#"],
  ["#", "#", ".", ".", ".", ".", ".", ".", "#"],
  [".", ".", "#", ".", "#", "#", ".", "#", "."],
  [".", ".", "#", "#", ".", ".", "#", "#", "."],
  ["#", ".", "#", ".", "#", "#", ".", "#", "."]
] # axe de sym vertical entre index 4 et 5 => 5 colonnes à gauche

test_pattern2 = [
  ["#", ".", ".", ".", "#", "#", ".", ".", "#"],
  ["#", ".", ".", ".", ".", "#", ".", ".", "#"],
  [".", ".", "#", "#", ".", ".", "#", "#", "#"],
  ["#", "#", "#", "#", "#", ".", "#", "#", "."],
  ["#", "#", "#", "#", "#", ".", "#", "#", "."],
  [".", ".", "#", "#", ".", ".", "#", "#", "#"],
  ["#", ".", ".", ".", ".", "#", ".", ".", "#"]
] # axe de sym horizontal entre index 3 et 4 => 4 lignes au dessus (* 100)

test_pattern3 = [
  [".", "#", "#", ".", ".", ".", "#", "#", ".", ".", "#"],
  [".", ".", ".", ".", "#", "#", "#", "#", "#", ".", "#"],
  ["#", ".", ".", "#", ".", "#", "#", "#", "#", ".", "#"],
  [".", ".", ".", ".", "#", "#", ".", ".", ".", "#", "#"],
  [".", "#", "#", ".", "#", ".", ".", ".", ".", ".", "."],
  ["#", "#", "#", "#", ".", "#", "#", "#", ".", "#", "#"],
  [".", "#", "#", ".", ".", ".", ".", ".", "#", "#", "#"],
  ["#", ".", ".", "#", "#", "#", ".", ".", ".", "#", "#"],
  ["#", ".", ".", "#", ".", "#", ".", ".", ".", "#", "."],
  [".", "#", "#", ".", "#", "#", "#", "#", "#", "#", "."],
  [".", "#", "#", ".", ".", "#", "#", "#", ".", ".", "#"],
  ["#", ".", ".", "#", "#", ".", "#", ".", ".", "#", "."],
  ["#", ".", ".", "#", "#", ".", "#", ".", ".", "#", "."],
  [".", "#", "#", ".", ".", "#", "#", "#", ".", ".", "#"],
  [".", "#", "#", ".", "#", "#", "#", "#", "#", "#", "."],
  ["#", ".", ".", "#", ".", "#", "#", ".", ".", "#", "."],
  ["#", ".", ".", "#", "#", "#", ".", ".", ".", "#", "#"]
]
# méthode pour trouver les paires à tester à partir d'une ligne précise
# entrée => 3, 8 (index max)      || 7, 8
# sortie => [[3, 4], [2, 5], [1, 6], [0, 7]] || [[7, 8]]
PAIRS_CHECKED = {}
def find_pairs_to_check(start, i_max)
  pairs = []
  a = start
  b = start + 1
  while a >= 0 && b <= i_max
    pairs << [a, b]
    a -= 1
    b += 1
  end
  PAIRS_CHECKED[[start, i_max]] = pairs
  pairs
end

# méthode pour trouver toutes les possibilités de la position de l'axe de sym
# entrée => 8 (index max)
# sortie => [[[0, 1]], [[1, 2], [0, 3]], [[2, 3], [1, 4], [0, 5]], etc. ]
POSITIONS = {}
def positions(i_max)
  positions = []
  (0...i_max).each do |i|
    if PAIRS_CHECKED[[i, i_max]]
      positions << PAIRS_CHECKED[[i, i_max]]
    else
      positions << find_pairs_to_check(i, i_max)
    end
  end
  POSITIONS[i_max] = positions
  positions
end

# méthode pour trouver la position de l'axe de symétrie
# entrée => pattern1 || pattern2
# sortie => nil      || '34'
def find_sym(pattern)
  i_max = pattern.length - 1
  positions = POSITIONS[i_max] ? POSITIONS[i_max] : positions(i_max)
  maybe_solution = true
  positions.each do |pairs|
    pairs.each do |pair|
      line1 = pair[0]
      line2 = pair[1]
      maybe_solution = pattern[line1] == pattern[line2]
      break unless maybe_solution
    end
    next unless maybe_solution

    return pairs[0]
  end
  nil
end

# méthode pour donner le score d'un pattern
def score(pattern)
  horizontal = find_sym(pattern)
  if horizontal
    return 100 * horizontal[1]
  else
    vertical = find_sym(pattern.transpose)
    return vertical[1]
  end
end
# puts score(test_pattern3)

def answer1(patterns)
  patterns.map { |pattern|
    score(pattern)
  }.sum
end

# # # PART TWO # # #

# # # ANSWERS # # #

# getting the data from the terminal
patterns = []
puts "Entrez les lignes (tapez 'fin' pour terminer la saisie) :"
input = gets.chomp

while input.downcase != 'fin'
  pattern = []
  while input != ''
    pattern << input
    input = gets.chomp
  end
  patterns << pattern.map(&:chars)
  input = gets.chomp
end

puts '-----------'
puts 'Réponse de la partie 1 :'
puts answer1(patterns)
puts '-----------'

# puts 'Réponse de la partie 2 :'
# puts '-----------'

# méthode pour
# entrée =>
# sortie =>

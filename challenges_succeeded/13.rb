# # # PART ONE # # #

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
# sortie => nil      || [3, 4]
def find_sym1(pattern)
  i_max = pattern.length - 1
  positions = POSITIONS[i_max] || positions(i_max)
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
def score1(pattern)
  horizontal = find_sym1(pattern)
  return 100 * horizontal[1] if horizontal

  vertical = find_sym1(pattern.transpose)
  vertical[1]
end

def answer1(patterns)
  patterns.map { |pattern| score1(pattern) }.sum
end

# # # PART TWO # # #

# méthode pour comparer 2 lignes
# entrée => line1, index_of_line1, line2, index_of_line2
# sortie => [x] or [] or [x1, x2, x3, etc]
def compare_lines(line1, line2)
  differences = []
  line1.each_with_index do |char, index|
    next if char == line2[index]

    differences << index
  end
  differences
end

# méthode pour trouver le smudge
# entrée => pattern
# sortie => {[2, 3]=>[[0, 5], 0], [3, 4]=>[[1, 6], 0]}
def fix_pattern(pattern)
  i_max = pattern.length - 1
  positions = POSITIONS[i_max] || positions(i_max)
  bugs = {}
  positions.each do |pairs|
    smudges = []
    pairs.each do |pair|
      line1 = pattern[pair[0]]
      line2 = pattern[pair[1]]
      next if line1 == line2

      differences = compare_lines(line1, line2)
      smudges << [pair, differences[0]] if differences.length == 1
    end
    bugs[pairs[0]] = smudges[0] unless smudges.empty?
  end
  bugs
end

class Array
  def deep_dup
    map { |x| x.is_a?(Array) ? x.deep_dup : x }
  end
end

def find_sym2(start_i, pattern, index_of_line1, index_of_line2, index_of_char)
  pairs = PAIRS_CHECKED[[start_i, pattern.length - 1]] || find_pairs_to_check(start_i, pattern.length - 1)
  new_pattern = pattern.deep_dup
  new_pattern[index_of_line1][index_of_char] = '.'
  new_pattern[index_of_line2][index_of_char] = '.'
  maybe_solution = true
  pairs.each do |pair|
    line_a = new_pattern[pair[0]]
    line_b = new_pattern[pair[1]]
    next if line_a == line_b

    maybe_solution = line_a == line_b
  end
  maybe_solution
end

# méthode pour tester chaque nouveau pattern et donner le score final du pattern
# entrée => pattern, {[2, 3]=>[[0, 5], 0], [3, 4]=>[[1, 6], 0]}
# sortie => score
def score2(pattern, bugs)
  bugs.each do |key, value|
    find_sym = find_sym2(key[0], pattern, value[0][0], value[0][1], value[1])
    return key[1] if find_sym
  end
end

def real_score2(pattern)
  h_bugs = fix_pattern(pattern)
  h_score = score2(pattern, h_bugs)
  return 100 * h_score unless h_score.instance_of?(Hash)

  v_bugs = fix_pattern(pattern.transpose)
  score2(pattern.transpose, v_bugs)
end

def answer2(patterns)
  patterns.map { |pattern| real_score2(pattern) }.sum
end

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

puts 'Réponse de la partie 2 :'
puts answer2(patterns)
puts '-----------'

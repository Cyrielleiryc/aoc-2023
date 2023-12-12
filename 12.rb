# # # PART ONE # # #

test1 = [
  '???.### 1,1,3',
  '.??..??...?##. 1,1,3',
  '?#?#?#?#?#?#?#? 1,3,1,6',
  '????.#...#... 4,1,1',
  '????.######..#####. 1,6,5',
  '?###???????? 3,2,1'
]
test1lines = ["???.###", ".??..??...?##.", "?#?#?#?#?#?#?#?", "????.#...#...", "????.######..#####.", "?###????????"]
test1contiguous = [[1, 1, 3], [1, 1, 3], [1, 3, 1, 6], [4, 1, 1], [1, 6, 5], [3, 2, 1]]
results1 = [
  1,
  4,
  1,
  1,
  4,
  10
] # sum = 21

# méthode pour récupérer deux tableaux :
# ["???.###", ".??..??...?##.", "?#?#?#?#?#?#?#?", "????.#...#...", "????.######..#####.", "?###????????"],
# [[1, 1, 3], [1, 1, 3], [1, 3, 1, 6], [4, 1, 1], [1, 6, 5], [3, 2, 1]]
def separate_data(rows)
  lines = []
  contiguous = []
  rows.each do |row|
    blocks = row.split(' ')
    lines << blocks[0]
    contiguous << blocks[1].split(',').map(&:to_i)
  end
  [lines, contiguous]
end

# méthode pour dire combien de '#' il manque dans la string
def missing_damaged(str, arr)
  arr.sum - str.count('#')
end

# méthode pour vérifier si une ligne correspond aux nombres donnés
def valid_arrangement?(str, arr)
  str_split = str.split('.').map { |item| item.count('#') }.reject(&:zero?)
  str_split == arr
end

# méthode pour casser la string en sous-groupes
# entrée => "???.###" || ".??..??...?##."
# sortie => ['???', '.', '###'] || ['.', '??', '..', '??', '...', '?', '##', '.']
def cut_the_string(str)
  substring = []
  i = 0
  while i < str.length
    characters = str[i]
    i += 1
    while str[i] == str[i - 1]
      characters += str[i]
      i += 1
    end
    substring << characters
  end
  substring
end

# méthode pour donner toutes les possibilités pour une série de '?'
# entrée => '???', nombre max
# sortie => ['...', '..#', '#.#', etc]
def all_possibilities(substr, m)
  l = substr.length
  n = m > l ? l : m
  arr = []
  n.times { arr << '#' }
  l.times { arr << '.' }
  arr.permutation(l).to_a.map(&:join).uniq
end

# méthode pour donner les substitutions à faire
# entrée => ['???', '.', '###'], nombre max
# sortie => [["0-##.", "0-#.#", "0-#..", "0-.##", "0-.#.", "0-..#", "0-..."]]
def all_substitutions(cutted_str, m)
  substitutions = []
  cutted_str.each_with_index do |chars, index|
    next unless chars[0] == '?'

    poss = all_possibilities(chars, m)
    these_subs = []
    poss.each do |pos|
      these_subs << "#{index}-#{pos}"
    end
    substitutions << these_subs
  end
  substitutions
end

# méthode pour donner le nombre d'arrangements possibles pour une string
# entrée => "???.###", [1, 1, 3]
# sortie => 1
def find_arrangements(str, arr)
  count = 0
  m = missing_damaged(str, arr)
  cutted_str = cut_the_string(str)
  substitutions = all_substitutions(cutted_str, m)
  if substitutions.size == 1
    all_possibilities = substitutions.dup.flatten.map { |a| [a] }
  else
    all_possibilities = substitutions.reduce { |acc, arr| acc.product(arr) }.map(&:flatten)
  end
  all_possibilities.each do |poss|
    next if poss.join.count('#') > m

    new_str = cutted_str.dup
    poss.each do |code|
      new_str[code.split('-')[0].to_i] = code.split('-')[1]
    end
    count += 1 if valid_arrangement?(new_str.join, arr)
  end
  count
end

def answer1(lines, contiguous)
  possible_arrangements = []
  lines.each_with_index do |line, index|
    possible_arrangements << find_arrangements(line, contiguous[index])
  end
  possible_arrangements.sum
end
# puts answer1(test1lines, test1contiguous)

# # # PART TWO # # #

# # # ANSWERS # # #

# getting the data from the terminal
all_rows = []
puts "Entrez les lignes (tapez 'fin' pour terminer la saisie) :"
input = gets.chomp

while input.downcase != 'fin'
  all_rows << input
  input = gets.chomp
end

puts '-----------'
puts 'Réponse de la partie 1 :'
data_splited = separate_data(all_rows)
lines = data_splited[0]
contiguous = data_splited[1]
puts answer1(lines, contiguous)
puts '-----------'

# puts 'Réponse de la partie 2 :'
# puts '-----------'

# méthode pour
# entrée =>
# sortie =>

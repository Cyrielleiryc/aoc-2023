# # # DATA # # #

all_rows = []
puts "Entrez les lignes (tapez 'fin' pour terminer la saisie) :"
input = gets.chomp

while input.downcase != 'fin'
  input_split = input.split(' ')
  contiguous = input_split[1].split(',').map(&:to_i)
  all_rows << [input_split[0], contiguous]
  input = gets.chomp
end

test1 = [
  '???.### 1,1,3',
  '.??..??...?##. 1,1,3',
  '?#?#?#?#?#?#?#? 1,3,1,6',
  '????.#...#... 4,1,1',
  '????.######..#####. 1,6,5',
  '?###???????? 3,2,1'
]
test1lines = [
  '???.###',
  '.??..??...?##.',
  '?#?#?#?#?#?#?#?',
  '????.#...#...',
  '????.######..#####.',
  '?###????????'
]
test1contiguous = [[1, 1, 3], [1, 1, 3], [1, 3, 1, 6], [4, 1, 1], [1, 6, 5], [3, 2, 1]]
results1 = [
  1,
  4,
  1,
  1,
  4,
  10
] # sum = 21

# # # PART ONE # # #

# méthode pour dire combien de '#' il manque dans la string
def missing_damaged(str, arr)
  arr.sum - str.count('#')
end

# méthode pour vérifier si une ligne correspond aux nombres donnés
def valid_arrangement?(str, arr)
  str_split = str.split('.').map { |item| item.count('#') }.reject(&:zero?)
  str_split == arr
end

# méthode pour donner les index des '?' dans la ligne
def question_marks(str)
  str.count('?')
end

# méthode pour donner les façons de remplacer les '?'
# entrée => m = nombre de '#' manquants, q = nombre de '?'
# sortie => [["#", "#", "."], ["#", ".", "#"], [".", "#", "#"]]
@m_pos_chars = {}
def sub_question(m, q)
  arr = []
  m.times { arr << '#' }
  (q - m).times { arr << '.' }
  answer = arr.permutation(q).to_a.uniq
  @m_pos_chars[[m, q]] = answer
  answer
end

def create_new_line(str, pos_chars)
  new_line = []
  str.chars.each do |char|
    if ['#', '.'].include?(char)
      new_line << char
    else
      new_line << pos_chars[0]
      pos_chars.delete_at(0)
    end
  end
  new_line.join
end

# on crée une nouvelle ligne en remplaçant chaque '?' par '#' ou par '.'
# on vérifie si elle est valide (count += 1 si oui)
def find_arrangements(str, arr)
  m = missing_damaged(str, arr)
  q = question_marks(str)
  possible_arrangements = @m_pos_chars[[m, q]] || sub_question(m, q)
  count = 0
  possible_arrangements.each do |pos_chars|
    new_line = create_new_line(str, pos_chars)
    count += 1 if valid_arrangement?(new_line, arr)
  end
  count
end

def answer1(rows)
  rows.sum { |row| find_arrangements(row[0], row[1]) }
end
# puts answer1(test1lines, test1contiguous)

# # # PART TWO # # #

# # # ANSWERS # # #

puts '-----------'
puts 'Réponse de la partie 1 :'
puts answer1(all_rows)
puts '-----------'

# puts 'Réponse de la partie 2 :'
# puts '-----------'

# méthode pour
# entrée =>
# sortie =>

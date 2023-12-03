# SYMBOLS = %w[* # + $ @ / % = - & _]
SYMBOLS = ['*', '#', '+', '$', '@', '/', '%', '=', '-', '&', '_', '£'].freeze

# # # PART ONE # # #

# méthode pour trouver les nombres sur une ligne et les indices des chiffres
# entrée = "..35..633."
# sortie = {"35"=> [2, 3], "633"=> [6, 7, 8]}
def find_numbers(line)
  numbers = line.split(/\D/).reject { |n| n == '' }
  answer = {}
  numbers.each do |number|
    index_start = line.index(number)
    index_end = index_start + number.length - 1
    answer[number] = (index_start..index_end).to_a
  end
  answer
end

# méthode pour donner les indices à étudier (en fonction de la longueur de la ligne)
# entrée = [2, 3]       || [0, 1]     || [8, 9] , 10
# sortie = [1, 2, 3, 4] || [0, 1, 2]  || [7, 8, 9]
def find_indexes_to_study(indexes, length)
  max_index = length - 1
  theses_indexes = [*indexes]
  theses_indexes << indexes.last + 1 unless indexes.last == max_index
  theses_indexes.unshift(indexes[0] - 1) unless indexes[0].zero?
  theses_indexes
end

# méthode pour voir s'il y a un symbole aux indices donnés
# entrées = "...*......", [2, 3]
# sortie = true
def adjacent_symbol?(line, indexes)
  indexes_to_check = find_indexes_to_study(indexes, line.length)
  count = 0
  indexes_to_check.each do |index|
    count += 1 if SYMBOLS.include?(line[index])
  end
  !count.zero?
end

# méthode pour vérifier les 3 lignes à étudier
# entrée = [lines], line_index, indexes
# sortie = true or false
# # # TODO TODO TODO TODO
def number_valid?(lines, line_index, indexes)
  previous = line_index.zero? ? false : adjacent_symbol?(lines[line_index - 1], indexes)
  actual = adjacent_symbol?(lines[line_index], indexes)
  next_line = lines.length == line_index + 1 ? false : adjacent_symbol?(lines[line_index + 1], indexes)
  previous || actual || next_line
end

# entrée = ["467..114..", "...*......", "..35..633."]
# sortie = [467, 35]
def numbers_to_add(lines)
  numbers_to_add = []
  lines.each_with_index do |line, line_index|
    numbers = find_numbers(line)
    numbers.each_key do |number|
      numbers_to_add << number if number_valid?(lines, line_index, numbers[number])
    end
  end
  numbers_to_add.map(&:to_i)
end

# on récupère les données
lines = []

puts "Entrez les lignes (tapez 'fin' pour terminer la saisie) :"
input = gets.chomp

while input.downcase != 'fin'
  lines << input
  input = gets.chomp
end

puts "Réponse de la partie 1 :"
numbers_to_be_added = numbers_to_add(lines)
puts numbers_to_be_added.sum
puts "-----------"
# 523085 is wrong

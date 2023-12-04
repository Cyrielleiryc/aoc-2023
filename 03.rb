# frozen_string_literal: true

SYMBOLS = %w[* # + $ @ / % = - & _ £ ^ { ( ) } ! : ;].freeze

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
def adjacent_symbol?(line, indexes_to_check)
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
  indexes_to_check = find_indexes_to_study(indexes, lines[line_index].length)
  previous = !line_index.zero? && adjacent_symbol?(lines[line_index - 1], indexes_to_check)
  actual = adjacent_symbol?(lines[line_index], indexes_to_check)
  next_line = lines.length != line_index + 1 && adjacent_symbol?(lines[line_index + 1], indexes_to_check)
  previous || actual || next_line
end

# entrée = ["467..114..", "...*......", "..35..633."]
# sortie = 4361
def calculate_answer(lines)
  answer = 0
  lines.each_with_index do |line, line_index|
    numbers = find_numbers(line)
    numbers.each_key do |number|
      answer += number.to_i if number_valid?(lines, line_index, numbers[number])
    end
  end
  answer
end

# on récupère les données
lines = []

puts "Entrez les lignes (tapez 'fin' pour terminer la saisie) :"
input = gets.chomp

while input.downcase != 'fin'
  lines << input
  input = gets.chomp
end

puts 'Réponse de la partie 1 :'
puts "calculate_answer => #{calculate_answer(lines)}"
puts '-----------'
# 523085 is wrong

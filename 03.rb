SYMBOLS = %w[* # + $ @ / % = - & _ £ ^ { ( ) } ! : ;].freeze

# # # PART ONE # # #

# méthode pour trouver les nombres sur une ligne et les indices des chiffres
# entrée = "..35..633."
# sortie = [["35", [2, 3]], ["633", [6, 7, 8]]]
def find_numbers(line)
  answer = []
  current_number = ''
  indexes = []
  line.chars.each_with_index do |char, index|
    if char.match?(/\d/)
      current_number << char
      indexes << index unless indexes.include?(index)
    else
      unless current_number.empty?
        answer << [current_number, indexes]
        current_number = ''
        indexes = []
      end
    end
  end
  answer << [current_number, indexes] unless current_number.empty?
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
def calculate_answer1(lines)
  answer = 0
  lines.each_with_index do |line, line_index|
    numbers = find_numbers(line)
    numbers.each do |number_arr|
      answer += number_arr[0].to_i if number_valid?(lines, line_index, number_arr[1])
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


# puts 'Réponse de la partie 1 :'
# puts calculate_answer1(lines)
# puts '-----------'

# # # PART TWO # # #

# # méthode pour récupèrer les indices où il y a un chiffre dans chaque ligne
# # entrée => lines
# # sortie => [[0, 1, 2, 5, 6, 7], [], [etc]]
# def where_are_digits(lines)
#   answer = []
#   lines.each do |line|
#     line_indexes = []
#     line.chars.each_with_index do |char, i|
#       line_indexes << i if ('0'..'9').to_a.include?(char)
#     end
#     answer << line_indexes
#   end
#   answer
# end
# DIGIT_POSITIONS = where_are_digits(lines)

# méthode pour dire s'il y a une étoile, si oui on donne ses coordonnées
# entrée => lines, actual_line_index, number_indexes
# sortie => false || [line_index, index on this line]
def find_star(lines, actual_line_index, number_indexes)
  indexes_to_check = find_indexes_to_study(number_indexes, lines[actual_line_index].length)
  indexes_of_surrounding_lines = find_indexes_to_study([actual_line_index], lines.length)
  answer = nil
  indexes_of_surrounding_lines.each do |i|
    indexes_to_check.each do |j|
      answer = "#{i}#{j}" if lines[i][j] == '*'
    end
  end
  answer.nil? ? false : answer
end

# def find_digits(lines, actual_line_index, star, number_indexes)
#   surrounding_lines = find_indexes_to_study([star[0]], lines.length)
#   indexes_to_check = find_indexes_to_study([star[1]], lines[actual_line_index].length)
#   indexes_of_digits = {}
#   surrounding_lines.each do |i|
#     if i == actual_line_index
#       common = (indexes_to_check - number_indexes) & DIGIT_POSITIONS[i]
#     else
#       common = indexes_to_check & DIGIT_POSITIONS[i]
#     end
#     indexes_of_digits[i] = common
#   end
#   indexes_of_digits
# end

# méthode pour créer un objet
expected_gears = {
  '13' => [467, 35],
  '43' => [617],
  '85' => [755, 598]
}
def create_gears(lines)
  gears = {}
  lines.each_with_index do |line, actual_line_index|
    numbers = find_numbers(line)
    # puts "###############################"
    # puts "iteration on line #{actual_line_index}"
    # puts "numbers = #{numbers}"
    numbers.each do |number_arr|
      # puts "-----------------------"
      # puts "iteration on number #{number_arr[0]}"
      # puts "star ? #{find_star(lines, actual_line_index, number_arr[1])}"
      next unless find_star(lines, actual_line_index, number_arr[1])

      star_key = find_star(lines, actual_line_index, number_arr[1])
      if gears[star_key]
        gears[star_key] << number_arr[0].to_i
      else
        gears[star_key] = [number_arr[0].to_i]
      end
    end
  end
  gears
end

def calculate_answer2(gears)

end

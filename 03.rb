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

# # # PART TWO # # #

# méthode pour dire s'il y a une ou plusieurs étoiles, si oui on donne leurs coordonnées
# entrée => lines, actual_line_index, number_indexes
# sortie => ["04", "12", etc.]
def find_stars(lines, actual_line_index, number_indexes)
  indexes_to_check = find_indexes_to_study(number_indexes, lines[actual_line_index].length)
  indexes_of_surrounding_lines = find_indexes_to_study([actual_line_index], lines.length)
  answer = []
  indexes_of_surrounding_lines.each do |i|
    indexes_to_check.each do |j|
      answer << "#{i}#{j}" if lines[i][j] == '*'
    end
  end
  answer
end

def create_gears(lines)
  gears = {}
  lines.each_with_index do |line, actual_line_index|
    numbers = find_numbers(line)
    numbers.each do |number_arr|
      star_keys = find_stars(lines, actual_line_index, number_arr[1])

      next if star_keys.empty?

      star_keys.each do |star_key|
        if gears[star_key]
          gears[star_key] << number_arr[0].to_i
        else
          gears[star_key] = [number_arr[0].to_i]
        end
      end
    end
  end
  gears
end

def gear_ratios(gears)
  ratios = []
  gears.each_value do |value|
    next if value.length != 2

    ratios << value[0] * value[1]
  end
  ratios
end

# # # ANSWERS # # #

# getting the data from the terminal
lines = []

puts "Entrez les lignes (tapez 'fin' pour terminer la saisie) :"
input = gets.chomp

while input.downcase != 'fin'
  lines << input
  input = gets.chomp
end

puts 'Réponse de la partie 1 :'
puts calculate_answer1(lines)
puts '-----------'

gears = create_gears(lines)
puts 'Réponse de la partie 2 :'
puts gear_ratios(gears).sum
puts '-----------'

# wrong => 74804681 (too low)

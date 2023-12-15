# frozen_string_literal: true

# on récupère les données
lines = []

puts "Entrez les lignes (tapez 'fin' pour terminer la saisie) :"
input = gets.chomp

while input.downcase != 'fin'
  lines << input
  input = gets.chomp
end

# # # PART ONE # # #

# on initialise le tableau pour les réponses
numbers_one = []
# pour chaque ligne
lines.each do |line|
  # on enlève toutes les lettres
  digits = line.chars.select { |c| ('0'..'9').to_a.include?(c) }
  # on écrit un nombre avec le premier chiffre et le dernier chiffre
  numbers_one << "#{digits[0]}#{digits[-1]}".to_i
end

# on additionne pour donner le résultat
puts 'Réponse de la partie 1 :'
puts numbers_one.sum
puts '-----------'

# # # PART TWO # # #

DIGITS_IN_LETTERS = %w[one two three four five six seven eight nine].freeze

# méthode pour trouver le nombre en lettres
def find_which_number(str)
  DIGITS_IN_LETTERS.each do |digit|
    return digit if str.start_with?(digit)
  end
end

# on initialise le tableau pour les réponses
numbers2 = []
# pour chaque ligne
lines.each do |line|
  # on initialise un tableau pour les nombres trouvés
  new_line = []
  while line.size.positive?
    # si ça commence par un chiffre
    if ('0'..'9').to_a.include?(line[0])
      new_line << line[0].to_i
      line.slice!(0)
    # si ça commence par un chiffre écrit en lettres
    elsif line.start_with?(*DIGITS_IN_LETTERS)
      digit_in_letters = find_which_number(line)
      new_line << DIGITS_IN_LETTERS.index(digit_in_letters) + 1
      line.slice!(0, digit_in_letters.size - 1)
    else
      line.slice!(0)
    end
  end
  numbers2 << "#{new_line[0]}#{new_line[-1]}".to_i
end

puts 'Réponse de la partie 2 :'
puts numbers2.sum
puts '-----------'

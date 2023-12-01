# # Exemple :
# 1abc2       => 12
# pqr3stu8vwx => 38
# a1b2c3d4e5f => 15
# treb7uchet  => 77
# sum of all = 142

# on récupère les données
lines = []
numbers = []

puts "Entrez les lignes (tapez 'fin' pour terminer la saisie) :"
input = gets.chomp

while input.downcase != 'fin'
  lines << input
  input = gets.chomp
end

# pour chaque ligne
lines.each do |line|
  # on enlève toutes les lettres
  digits = line.chars.select { |c| ('0'..'9').to_a.include?(c) }
  # on écrit un nombre avec le premier chiffre et le dernier chiffre
  numbers << "#{digits[0]}#{digits[-1]}".to_i
end

# on additionne pour donner le résultat
puts numbers.sum

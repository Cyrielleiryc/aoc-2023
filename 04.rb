# Card 1: 41 48 83 86 17 | 83 86  6 31 17  9 48 53 => 8
# Card 2: 13 32 20 16 61 | 61 30 68 82 17 32 24 19 => 2
# Card 3:  1 21 53 59 44 | 69 82 63 72 16 21 14  1 => 2
# Card 4: 41 92 73 84 69 | 59 84 76 51 58  5 54 83 => 1
# Card 5: 87 83 26 28 32 | 88 30 70 12 93 22 82 36 => 0
# Card 6: 31 18 13 56 72 | 74 77 10 23 35 67 36 11 => 0
# total = 13

# pour chaque ligne, récupérer le tableau des nombres gagnants et celui des nombres joués
# itérer sur les nombres joués, si c'est gagnant le compteur est augmenté
# additionner le score de chaque carte

# méthode pour récupérer les nombres gagnants ou joués
# entrée => "41 48 83 86 17 | 83 86  6 31 17  9 48 53", "winning"
# sortie => ['41', '48', '83', '86', '17']
# entrée => "41 48 83 86 17 | 83 86  6 31 17  9 48 53", "played"
# sortie => ['83', '86', '6', '31', '17', '9', '48', '53']
def numbers(card, category)
  index = category == 'winning' ? 0 : 1
  card.split('|')[index].split(' ').map(&:strip)
end

# méthode pour calculer les points d'une carte
# entrée => "41 48 83 86 17 | 83 86  6 31 17  9 48 53"
# sortie => 8
def points(card)
  count = 0
  winning_numbers = numbers(card, "winning")
  numbers(card, "played").each do |number|
    if winning_numbers.include?(number)
      count.zero? ? count += 1 : count *= 2
    end
  end
  count
end

# méthode pour calculer le nombre total de points
# entrée => toutes les cartes
# sortie => 13
def calculate_total(cards)
  total = 0
  cards.each { |card| total += points(card) }
  total
end

# on récupère les données
cards = []

puts "Entrez les lignes (tapez 'fin' pour terminer la saisie) :"
input = gets.chomp

while input.downcase != 'fin'
  input.slice!(0,8)
  cards << input
  input = gets.chomp
end

puts "Réponse de la partie 1 :"
puts calculate_total(cards).to_s
puts "-----------"

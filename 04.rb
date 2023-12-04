# frozen_string_literal: true

# # # PART ONE # # #

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
  winning_numbers = numbers(card, 'winning')
  numbers(card, 'played').each do |number|
    if winning_numbers.include?(number)
      count.zero? ? count += 1 : count *= 2
    end
  end
  count
end

# méthode pour calculer le nombre total de points
# entrée => toutes les cartes
# sortie => 13
def calculate_total1(cards)
  total = 0
  cards.each { |card| total += points(card[0]) }
  total
end

# on récupère les données
cards = []

puts "Entrez les lignes (tapez 'fin' pour terminer la saisie) :"
input = gets.chomp

while input.downcase != 'fin'
  input.slice!(0, 8)
  cards << [input, 1]
  input = gets.chomp
end

puts 'Réponse de la partie 1 :'
puts calculate_total1(cards)
puts '-----------'

# # # PART TWO # # #

# méthode pour donner le nombre de 'matching numbers' d'une carte
# entrée => '41 48 83 86 17 | 83 86  6 31 17  9 48 53'
def matching_numbers(card)
  count = 0
  winning_numbers = numbers(card, 'winning')
  numbers(card, 'played').each do |number|
    count += 1 if winning_numbers.include?(number)
  end
  count
end

# méthode pour joueur aux cartes et mettre à jour le nombre d'instances de chaque carte
# entrée => [['41 48 83 86 17 | 83 86  6 31 17  9 48 53', 1], ['13 32 20 16 61 | 61 30 68 82 17 32 24 19', 1], etc]
# sortie => [['41 48 83 86 17 | 83 86  6 31 17  9 48 53', 1], ['13 32 20 16 61 | 61 30 68 82 17 32 24 19', 2], etc]
def play_scratchcards(cards)
  cards.each_with_index do |scratchcard, index|
    wins = matching_numbers(scratchcard[0])
    (index + 1..index + wins).to_a.each do |i|
      cards[i][1] += 1 * scratchcard[1]
    end
  end
  cards
end

# méthode pour calculer le nombre total de scratchcards
# entrée => [['41 48 83 86 17 | 83 86  6 31 17  9 48 53', 1], ['13 32 20 16 61 | 61 30 68 82 17 32 24 19', 2], etc]
# sortie => 30
def calculate_total2(cards)
  total = 0
  cards.each { |scratchcard| total += scratchcard[1] }
  total
end

puts 'Réponse de la partie 2 :'
after_game = play_scratchcards(cards)
puts calculate_total2(after_game)
puts '-----------'

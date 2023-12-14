# # # PART ONE # # #

# cards by order of strength
CARD_TYPES = {
  'A' => 14,
  'K' => 13,
  'Q' => 12,
  'J' => 11,
  'T' => 10,
  '9' => 9,
  '8' => 8,
  '7' => 7,
  '6' => 6,
  '5' => 5,
  '4' => 4,
  '3' => 3,
  '2' => 2
}.freeze
CARD_TYPES2 = {
  'A' => 14,
  'K' => 13,
  'Q' => 12,
  'T' => 10,
  '9' => 9,
  '8' => 8,
  '7' => 7,
  '6' => 6,
  '5' => 5,
  '4' => 4,
  '3' => 3,
  '2' => 2,
  'J' => 1
}.freeze

# types by crescent order of strength
HAND_TYPES = %w[high_card one_pair two_pairs brelan full_house four_of_a_kind five_of_a_kind].freeze

# méthode pour faire correspondre les mains avec leur paris
# entrée => ["32T3K", "T55J5", "KK677", "KTJJT", "QQQJA"], [765, 684, 28, 220, 483]
# sortie => {"32T3K"=>765, "T55J5"=>684, "KK677"=>28, "KTJJT"=>220, "QQQJA"=>483}
def hands_with_bids(hands, bids)
  hands_with_bids = {}
  hands.each_with_index do |hand, index|
    hands_with_bids[hand] = bids[index]
  end
  hands_with_bids
end

# méthodes pour donner le type d'une main (et gérer les difficultés)
def pairs_or_else(hand)
  reduced = hand.chars.uniq.size
  if reduced == 5
    return 'high_card'
  elsif reduced == 4
    return 'one_pair'
  else
    return 'two_pairs'
  end
end

MEMOIZED_HANDS = {}
def hand_type(hand)
  occurences = hand.chars.to_h { |char| [char, hand.count(char)] }
  occurences.each_value do |count|
    case count
    when 5
      return 'five_of_a_kind'
    when 4
      return 'four_of_a_kind'
    when 3
      return hand.chars.uniq.size == 2 ? 'full_house' : 'brelan'
    end
  end
  pairs_or_else(hand)
end

# méthode pour grouper les mains selon leur type
# entrée => ['32T3K', 'T55J5', 'KK677', 'KTJJT', 'QQQJA']
# sortie => {'five_of_a_kind' => [hands], 'four_of_a_kind' => [hands], etc }
def group_hands(hands)
  groups = {}
  hands.each do |hand|
    if MEMOIZED_HANDS[hand]
      hand_type = MEMOIZED_HANDS[hand]
    else
      hand_type = hand_type(hand)
      MEMOIZED_HANDS[hand] = hand_type
    end
    if groups[hand_type]
      groups[hand_type] << hand
    else
      groups[hand_type] = [hand]
    end
  end
  groups
end

# méthode pour mettre dans l'ordre les mains identiques
# entrée => ["KK677", "KTJJT", "5588A"]
# sortie => ['5588A', 'KTJJT', 'KK677']
def handle_evens(hands, model_card_types)
  hands.sort_by do |hand|
    hand.chars.map { |char| model_card_types[char] }
  end
end

# méthode pour mettre les mains dans l'ordre final
def hands_in_order(hands_by_groups, model_card_types)
  order = []
  HAND_TYPES.each do |hand_type|
    next unless hands_by_groups[hand_type]

    if hands_by_groups[hand_type].size == 1
      order << hands_by_groups[hand_type]
    else
      order << handle_evens(hands_by_groups[hand_type], model_card_types)
    end
  end
  order.flatten
end

# méthode pour calculer les gains pour chaque main
def calculate_total_winnings(hands_with_bids, hands_in_order)
  wins = []
  hands_in_order.each_with_index do |hand, index|
    wins << hands_with_bids[hand] * (index + 1)
  end
  wins.sum
end

def answer1(hands, bids)
  hands_grouped_by_type = group_hands(hands)
  hands_in_final_order = hands_in_order(hands_grouped_by_type, CARD_TYPES)
  hands_with_bids = hands_with_bids(hands, bids)
  calculate_total_winnings(hands_with_bids, hands_in_final_order)
end

# # # PART TWO # # #

def handle_joker(hand)
  return 'five_of_a_kind' if hand == 'JJJJJ'
  
  occurences_of_cards = hand.gsub('J', '').chars.to_h { |l| [l, hand.count(l)] }
  card_value = occurences_of_cards.key(occurences_of_cards.values.max)
  new_hand = hand.gsub('J', card_value)
  hand_type(new_hand)
end

def hand_type2(hand)
  if hand.include?('J')
    handle_joker(hand)
  else
    hand_type(hand)
  end
end

def group_hands2(hands)
  groups = {}
  hands.each do |hand|
    hand_type = hand_type2(hand)
    if groups[hand_type]
      groups[hand_type] << hand
    else
      groups[hand_type] = [hand]
    end
  end
  groups
end

def answer2(hands, bids)
  hands_grouped_by_type = group_hands2(hands)
  hands_in_final_order = hands_in_order(hands_grouped_by_type, CARD_TYPES2)
  hands_with_bids = hands_with_bids(hands, bids)
  calculate_total_winnings(hands_with_bids, hands_in_final_order)
end

# # # ANSWERS # # #

# on récupère les données
hands = []
bids = []

puts "Entrez les lignes (tapez 'fin' pour terminer la saisie) :"
input = gets.chomp

while input.downcase != 'fin'
  hands << input[0..4]
  bids << input[5..].strip.to_i
  input = gets.chomp
end

puts '-----------'
puts 'Réponse de la partie 1 :'
puts answer1(hands, bids)
puts '-----------'

puts 'Réponse de la partie 2 :'
puts answer2(hands, bids)
puts '-----------'

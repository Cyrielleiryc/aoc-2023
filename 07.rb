# # # PART ONE # # #

# 32T3K 765 => one pair        => rank 1 => 1 * 765
# T55J5 684 => three of a kind => rank 4 => 4 * 684
# KK677 28  => two pairs       => rank 3 => 3 * 28
# KTJJT 220 => two pairs       => rank 2 => 2 * 220
# QQQJA 483 => three of a kind => rank 5 => 5 * 483
# TOTAL = 6440

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
}

# types by order of strength
HAND_TYPES = {
  'five_of_a_kind' => 7,
  'four_of_a_kind' => 6,
  'full_house' => 5,
  'brelan' => 4,
  'two_pairs' => 3,
  'one_pair' => 2,
  'high_card' => 1
}

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

# méthode pour déterminer si c'est un full house ou un brelan
# entrée => 'T55J5'  || 'A2A22'
# sortie => 'brelan' || 'full_house'
def full_or_brelan(hand)
  hand.chars.uniq.size == 2 ? 'full_house' : 'brelan'
end

# méthode pour déterminer si c'est 2 pairs ou 1 pair ou rien
# entrée => 'KTJJT'     || '32T3K'    || 'KJ84T'
# sortie => 'two_pairs' || 'one_pair' || 'high_card'
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

# méthode pour donner le type d'une main
# entrée => '32T3K'
# sortie => 'one_pair'
def hand_type(hand)
  occurences = hand.chars.to_h { |char| [char, hand.count(char)] }
  occurences.each_value do |count|
    case count
    when 5
      return 'five_of_a_kind'
    when 4
      return 'four_of_a_kind'
    when 3
      return full_or_brelan(hand)
    end
  end
  pairs_or_else(hand)
end

# méthode pour donner le score de chaque main
# entrée => ['32T3K', 'T55J5', 'KK677', 'KTJJT', 'QQQJA']
# sortie => {'32T3K'=>2, 'KK677'=>3, 'KTJJT'=>3, 'QQQJA'=>4, 'T55J5'=>4}
def hands_score(hands)
  output = {}
  hands.each do |hand|
    output[hand] = HAND_TYPES[hand_type(hand)]
  end
  output.sort.to_h
end

# méthode pour mettre dans l'ordre les mains identiques
# entrée => ["KK677", "KTJJT", "5588A"]
# sortie => ['5588A', 'KTJJT', 'KK677']
def handle_evens(hands)
  hands.sort_by do |hand|
    hand.chars.map { |char| CARD_TYPES[char] }
  end
end

# méthode pour donner les mains dans l'ordre final
# entrée => {'32T3K'=>2, 'KK677'=>3, 'KTJJT'=>3, '5588A'=>3, 'QQQJA'=>4, 'T55J5'=>4}
# provisoire = [["32T3K"], ["KK677", "KTJJT", "5588A"], ["QQQJA", "T55J5"]]
# sortie => ['32T3K', '5588A', 'KTJJT', 'KK677', 'T55J5', 'QQQJA']
def final_order(hands_with_score)
  grouped = hands_with_score.group_by { |hand, score| score }
  groups = grouped.values.map { |array| array.map(&:first) }
  final_order = []
  groups.each do |group|
    if group.size == 1
      final_order << group
    else
      final_order << handle_evens(group)
    end
  end
  final_order.flatten
end

# méthode pour calculer les gains pour chaque main
# entrées => {"32T3K"=>765, "T55J5"=>684, "KK677"=>28, "KTJJT"=>220, "QQQJA"=>483}
#         => ['32T3K', '5588A', 'KTJJT', 'KK677', 'T55J5', 'QQQJA']
# sortie => 6440
def calculate_total_winnings(hands_with_bids, hands_in_order)
  wins = []
  hands_in_order.each_with_index do |hand, index|
    wins << hands_with_bids[hand] * (index + 1)
  end
  wins.sum
end

# # # ANSWERS # # #

# on récupère les données
hands = [] # ["32T3K", "T55J5", "KK677", "KTJJT", "QQQJA"]
bids = []  # [765, 684, 28, 220, 483]

puts "Entrez les lignes (tapez 'fin' pour terminer la saisie) :"
input = gets.chomp

while input.downcase != 'fin'
  hands << input[0..4]
  bids << input[5..].strip.to_i
  input = gets.chomp
end

puts '-----------'
puts 'Réponse de la partie 1 :'
hands_with_bids = hands_with_bids(hands, bids)
hands_score = hands_score(hands)
hands_in_order = final_order(hands_score)
puts calculate_total_winnings(hands_with_bids, hands_in_order)
puts '-----------'
# wrong = 252068215 (too high)

# puts 'Réponse de la partie 2 :'

# puts '-----------'


# méthode pour
# entrée =>
# sortie =>

# # # PART ONE # # #

# 32T3K 765 => one pair        => rank 1 => 1 * 765
# T55J5 684 => three of a kind => rank 4 => 4 * 684
# KK677 28  => two pairs       => rank 3 => 3 * 28
# KTJJT 220 => two pairs       => rank 2 => 2 * 220
# QQQJA 483 => three of a kind => rank 5 => 5 * 483
# TOTAL = 6440

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

# # # ANSWERS # # #

# on récupère les données
# hands = [] # ["32T3K", "T55J5", "KK677", "KTJJT", "QQQJA"]
# bids = []  # [765, 684, 28, 220, 483]

# puts "Entrez les lignes (tapez 'fin' pour terminer la saisie) :"
# input = gets.chomp

# while input.downcase != 'fin'
#   hands << input[0..4]
#   bids << input[5..].strip.to_i
#   input = gets.chomp
# end

# puts '-----------'
# puts 'Réponse de la partie 1 :'

# puts '-----------'

# puts 'Réponse de la partie 2 :'

# puts '-----------'


# méthode pour
# entrée =>
# sortie =>

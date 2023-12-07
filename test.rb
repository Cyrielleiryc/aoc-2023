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

# arr = ["KK677", "KTJJT", "5588A"]
arr = ["QQQJA", "T55J5"]

arr_sorted = arr.sort_by do |item|
  item.chars.map { |char| CARD_TYPES[char] }
end

p arr_sorted

require 'set'

accepted_parts = [
  { 'x' => 1..4000, 'm' => 2090..4000, 'a' => 2006..4000, 's' => 1..1351 },
  { 'x' => 1..1416, 'm' => 1..4000, 'a' => 1..2006, 's' => 1..1351 },
  { 'x' => 1..2440, 'm' => 1..2090, 'a' => 2006..4000, 's' => 537..1351 },
  { 'x' => 1..4000, 'm' => 1..4000, 'a' => 1..4000, 's' => 3448..4000 },
  { 'x' => 1..4000, 'm' => 838..1801, 'a' => 1..4000, 's' => 1351..2770 },
  { 'x' => 2662..4000, 'm' => 1..4000, 'a' => 1..2006, 's' => 1..1351 },
  # { 'x' => 1..4000, 'm' => 1548..4000, 'a' => 1..4000, 's' => 2770..3448 },
  # { 'x' => 1..4000, 'm' => 1..1548, 'a' => 1..4000, 's' => 2770..3448 },
  # { 'x' => 1..4000, 'm' => 1..838, 'a' => 1..1716, 's' => 1351..2770 }
]

# Initialiser un ensemble vide pour stocker les combinaisons uniques
unique_combinations = Set.new

# Parcourir chaque objet dans la liste
accepted_parts.each do |part|
  # Parcourir les plages de valeurs pour chaque attribut
  part['x'].each do |x|
    part['m'].each do |m|
      part['a'].each do |a|
        part['s'].each do |s|
          # Créer une combinaison et l'ajouter à l'ensemble des combinaisons uniques
          combination = { 'x' => x, 'm' => m, 'a' => a, 's' => s }
          unique_combinations.add(combination)
        end
      end
    end
  end
end

# Afficher le nombre total de combinaisons uniques
puts unique_combinations.size

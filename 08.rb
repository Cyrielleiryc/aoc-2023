# # # PART ONE # # #

# méthode pour donner l'élément suivant en fonction de droite ou gauche
def next_element(direction, arr)
  direction == 'L' ? arr[0] : arr[1]
end

# méthode pour faire une boucle tant qu'on n'arrive pas à 'ZZZ'
def answer1(instructions, nodes)
  position = 'AAA'
  count = 0
  while position != 'ZZZ'
    instructions.each do |direction|
      position = next_element(direction, nodes[position])
      count += 1
    end
  end
  count
end

# # # PART TWO # # #

test1_instructions = ['R', 'L']
test1_nodes = {
  'AAA' => ['BBB', 'CCC'],
  'BBB' => ['DDD', 'EEE'],
  'CCC' => ['ZZZ', 'GGG'],
  'DDD' => ['DDD', 'DDD'],
  'EEE' => ['EEE', 'EEE'],
  'GGG' => ['GGG', 'GGG'],
  'ZZZ' => ['ZZZ', 'ZZZ']
}

test2_instructions = ['L', 'L', 'R']
test2_nodes = {
  'AAA' => ['BBB', 'BBB'],
  'BBB' => ['AAA', 'ZZZ'],
  'ZZZ' => ['ZZZ', 'ZZZ']
}

test3_instructions = ['L', 'R']
test3_nodes = {
  '11A' => ['11B', 'XXX'],
  '11B' => ['XXX', '11Z'],
  '11Z' => ['11B', 'XXX'],
  '22A' => ['22B', 'XXX'],
  '22B' => ['22C', '22C'],
  '22C' => ['22Z', '22Z'],
  '22Z' => ['22B', '22B'],
  'XXX' => ['XXX', 'XXX']
}

# méthode pour trouver les positions de départ
def find_starts(arr)
  arr.select { |pos| pos[-1] == 'A' }
end

# méthode pour trouver la position suivante pour chaque trajet
# entrée => [direction, positions, nodes]
# sortie => [nouvelles positions]
def next_positions(direction, positions, nodes)
  key = direction == 'L' ? 0 : 1
  positions.map { |pos| nodes[pos][key] }
end

# méthode pour dire si on est arrivé
def reached_end(arr)
  arr.length == arr.map { |p| p[-1] }.count('Z')
end

def answer2(instructions, nodes)
  positions = find_starts(nodes.keys)
  count = 0
  while !reached_end(positions)
    instructions.each do |direction|
      positions = next_positions(direction, positions, nodes)
      count += 1
    end
  end
  count
end
# puts answer2(test3_instructions, test3_nodes)

# # # ANSWERS # # #

# getting the data from the terminal
puts "Entrez les lignes (tapez 'fin' pour terminer la saisie) :"
instructions = gets.chomp.chars
gets.chomp
nodes = {}
input = gets.chomp
while input.downcase != 'fin'
  key = input[0..2]
  value = input[7..14].split(', ')
  nodes[key] = value
  input = gets.chomp
end

puts '-----------'
# puts 'Réponse de la partie 1 :'
# puts answer1(instructions, nodes)
# puts '-----------'

puts 'Réponse de la partie 2 :'
puts answer2(instructions, nodes)
puts '-----------'

# méthode pour
# entrée =>
# sortie =>

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


# # # ANSWERS # # #

# # getting the data from the terminal
# puts "Entrez les lignes (tapez 'fin' pour terminer la saisie) :"
# instructions = gets.chomp.chars
# gets.chomp
# nodes = {}
# input = gets.chomp
# while input.downcase != 'fin'
#   key = input[0..2]
#   value = input[7..14].split(', ')
#   nodes[key] = value
#   input = gets.chomp
# end

# puts '-----------'
# puts 'Réponse de la partie 1 :'
# puts answer1(instructions, nodes)
# puts '-----------'

# puts 'Réponse de la partie 2 :'
# puts '-----------'

# méthode pour
# entrée =>
# sortie =>

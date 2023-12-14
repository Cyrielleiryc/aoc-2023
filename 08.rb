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

# méthode pour trouver les positions de départ
def find_starts(arr)
  arr.select { |pos| pos[-1] == 'A' }
end

def answer2(instructions, nodes)
  positions = find_starts(nodes.keys)
  numbers = []
  positions.each do |position|
    pos = position
    count = 0
    until pos[-1] == 'Z'
      instructions.each do |direction|
        pos = next_element(direction, nodes[pos])
        count += 1
        break if pos[-1] == 'Z'
      end
    end
    numbers << count
  end
  numbers.reduce(1, :lcm)
end

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
puts 'Réponse de la partie 1 :'
puts answer1(instructions, nodes)
puts '-----------'

puts 'Réponse de la partie 2 :'
puts answer2(instructions, nodes)
puts '-----------'

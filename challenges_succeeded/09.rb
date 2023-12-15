# # # PART ONE # # #

# méthode pour donner les différences entre chaque nombre
# entrée => [0, 3, 6, 9, 12, 15] || [10, 13, 16, 21, 30, 45]
# sortie => [3, 3, 3, 3, 3]      || [3, 3, 5, 9, 15, 23]
def deltas(arr)
  deltas = []
  arr.each_cons(2) do |number, next_number|
    deltas << next_number - number
  end
  deltas
end

# méthode pour dire si le tableau ne contient que des zéros
# entrée => [0, 3, 6, 9, 12, 15] || [3, 3, 3, 3, 3] || [0, 0, 0, 0]
# sortie => false                || false           || true
def all_zeros?(arr)
  arr.count(0) == arr.length
end

# méthode pour créer les lignes de l'arbre jusqu'au bout
# entrée => [0, 3, 6, 9, 12, 15]
# sortie => [[0, 3, 6, 9, 12, 15], [3, 3, 3, 3, 3], [0, 0, 0, 0]]
def create_tree(arr)
  tree = [arr.dup]
  until all_zeros?(tree[-1])
    tree << deltas(tree[-1])
  end
  tree
end

# méthode pour trouver le nombre à rajouter à la séquence de l'historique
# entrée => [0, 3, 6, 9, 12, 15]
# sortie => 18
def next_number(arr)
  tree = create_tree(arr).reverse
  tree.each_with_index do |sequence, index|
    next if all_zeros?(sequence)

    sequence << sequence[-1] + tree[index - 1][-1]
  end
  tree[-1][-1]
end

# méthode pour itérer sur chaque historique et en sortir la réponse finale
# entrée => histories
# sortie => la somme
def answer1(histories)
  final_numbers = []
  histories.each { |history| final_numbers << next_number(history) }
  final_numbers.sum
end

# # # PART TWO # # #
# méthode pour itérer sur chaque historique inversé et en sortir la réponse finale
# entrée => histories
# sortie => la somme
def answer2(histories)
  final_numbers = []
  histories.each { |history| final_numbers << next_number(history.reverse) }
  final_numbers.sum
end

# # # ANSWERS # # #

# getting the data from the terminal
histories = [] # [[0, 3, 6, 9, 12, 15], [1, 3, 6, 10, 15, 21], [10, 13, 16, 21, 30, 45]]
puts "Entrez les lignes (tapez 'fin' pour terminer la saisie) :"
input = gets.chomp

while input.downcase != 'fin'
  histories << input.split(' ').map(&:to_i)
  input = gets.chomp
end

puts '-----------'
puts 'Réponse de la partie 1 :'
puts answer1(histories)
puts '-----------'

puts 'Réponse de la partie 2 :'
puts answer2(histories)
puts '-----------'

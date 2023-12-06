# # # PART ONE # # #

# Time:      7  15   30   milliseconds
# Distance:  9  40  200   millimeters

# speed = 0 mm/ms
# button hold for 1 millisecond => speed += 1 mm/ms

# exemple pour la première course
# tenue du bouton     0   1   2   3   4   5   6   7
# temps qui reste     7   6   5   4   3   2   1   0
# distance parcourue  0   6   10  12  12  10  6   0
# win or loose        -   -   x   x   x   x   -   -     => 4 possibilités
# réponse => on multiplie le nombre de possibilités de victoire pour chaque course



# # # ANSWERS # # #

# méthode pour transformer la ligne récupérée en tableau de données
# entrée => "Time:      7  15   30" || "Distance:  9  40  200"
# sortie => [7, 15, 30]             || [9, 40, 200]
def input_to_array(input)
  input.slice(10, input.length - 1).split(' ').map(&:to_i)
end

# data from the test
times = input_to_array("Time:      7  15   30")
distances = input_to_array("Distance:  9  40  200")

# data from the puzzle input
# times = input_to_array()
# distances = input_to_array()

# puts '-----------'
# puts 'Réponse de la partie 1 :'

# puts '-----------'

# puts 'Réponse de la partie 2 :'

# puts '-----------'


# méthode pour
# entrée =>
# sortie =>

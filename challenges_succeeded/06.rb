# # # PART ONE # # #

# méthode pour créer les courses sour forme de hash
# entrée => [7, 15, 30], [9, 40, 200]
# sortie => [{time: 7, distance: 9}, {time: 15, distance: 40}, {time: 30, distance: 200}]
def create_races(times, distances)
  races = []
  grid = [times, distances].transpose
  grid.each do |race|
    races << { time: race[0], distance: race[1] }
  end
  races
end

# méthode pour donner le nombre de possibilités de victoires
# entrée => {time: 7, distance: 9}
# sortie => 4
def number_of_wins(race)
  count = 0
  (1...race[:time]).each do |t|
    count += 1 if t * (race[:time] - t) > race[:distance]
  end
  count
end

# méthode pour calculer le produit final
# entrée => [4, 8, 9]
# sortie => 288
def calculate_ratio(arr)
  ratio = 1
  arr.each { |n| ratio *= n }
  ratio
end

def answer1(races)
  w = []
  races.each { |race| w << number_of_wins(race) }
  calculate_ratio(w)
end

# # # PART TWO # # #

# méthode pour créer la course sour forme de hash
# entrée => [7, 15, 30], [9, 40, 200]
# sortie => {time: 71530, distance: 940200}
def create_only_one_race(times, distances)
  race = {}
  race[:time] = times.map(&:to_s).join('').to_i
  race[:distance] = distances.map(&:to_s).join('').to_i
  race
end

# # # ANSWERS # # #

# méthode pour transformer la ligne récupérée en tableau de données
# entrée => "Time:      7  15   30" || "Distance:  9  40  200"
# sortie => [7, 15, 30]             || [9, 40, 200]
def input_to_array(input)
  input.slice(10, input.length - 1).split(' ').map(&:to_i)
end

# data from the test
# times = input_to_array("Time:      7  15   30")
# distances = input_to_array("Distance:  9  40  200")

# data from the puzzle input
times = input_to_array("Time:        44     89     96     91")
distances = input_to_array("Distance:   277   1136   1890   1768")

puts '-----------'
puts 'Réponse de la partie 1 :'
races = create_races(times, distances)
answer1 = answer1(races)
puts answer1
puts '-----------'

puts 'Réponse de la partie 2 :'
race = create_only_one_race(times, distances)
puts number_of_wins(race)
puts '-----------'

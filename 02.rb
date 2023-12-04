# frozen_string_literal: true

# # # PART ONE # # #

# méthode pour récupérer les parties
# entrée = "Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green"
# sortie = ["3 blue, 4 red", "1 red, 2 green, 6 blue", "2 green"]
def sets(str)
  str.slice!(0, 8)
  str.split(';').map(&:strip)
end

# méthode pour créer un objet pour une partie
# entrée = "1 red, 2 green, 6 blue"
# sortie = {red: 1, green: 2, blue: 6}
def one_set_to_hash(str)
  draws = str.split(',').map(&:strip)
  draws.map! { |s| s.split(' ').reverse }
  draws.map! { |s| [s[0].to_sym, s[1].to_i] }.to_h
end

# méthode transformer la ligne de texte en pair clé-valeur
# entrée = "Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green"
# sortie = [{blue: 3, red: 4}, {red: 1, green: 2, blue: 6}, {green: 2}]
def create_value(str)
  sets = sets(str)
  sets.map { |set| one_set_to_hash(set) }
end

# méthode pour vérifier un set
# entrées = {:blue=>3, :red=>4}  || {:green=>8, :red=>20, :blue=>6}
# sorties = 0                    || 1
def this_set_possible?(set)
  count = 0
  count += 1 if set[:red] && set[:red] > 12
  count += 1 if set[:green] && set[:green] > 13
  count += 1 if set[:blue] && set[:blue] > 14
  count
end

# méthode pour vérifier si un jeu est possible
# entrée = [{:blue=>3, :red=>4}, {:red=>1, :green=>2, :blue=>6}, {:green=>2}]
# sortie = true
def game_possible?(game)
  answer = 0
  game.each do |set|
    answer += this_set_possible?(set)
  end
  answer.zero?
end

# méthode pour trouver la réponse
# entrée = [[{}, {}], [{}, {}]]
# sortie = 8
def give_answer1(games)
  games_possible = []
  games.each_with_index do |game, index|
    games_possible << index + 1 if game_possible?(game)
  end
  games_possible.sum
end

# on récupère les données
games = []

puts "Entrez les lignes (tapez 'fin' pour terminer la saisie) :"
input = gets.chomp

while input.downcase != 'fin'
  games << create_value(input)
  input = gets.chomp
end

puts 'Réponse de la partie 1 :'
puts give_answer1(games)
puts '-----------'

# # # PART TWO # # #

# méthode pour trouver les 3 nombres minimums
# entrée = [{:blue=>3, :red=>4}, {:red=>1, :green=>2, :blue=>6}, {:green=>2}]
# sortie = {blue: 6, red: 4, green: 2}
def find_minimums(arr)
  mins = { blue: 0, red: 0, green: 0 }
  colors = mins.keys
  arr.each do |set|
    colors.each do |color|
      mins[color] = set[color] if set[color] && mins[color] < set[color]
    end
  end
  mins
end

# méthode pour trouver le produit des minimums
# entrée = {blue: 6, red: 4, green: 2}
# sortie = 48
def calculate_product(mins)
  product = 1
  mins.each_value { |m| product *= m }
  product
end

# méthode pour trouver la réponse
# entrée = [[{}, {}], [{}, {}]]
# sortie = 2286
def give_answer2(games)
  answer = []
  games.each do |game|
    mins = find_minimums(game)
    answer << calculate_product(mins)
  end
  answer.sum
end

puts 'Réponse de la partie 1 :'
puts give_answer2(games)
puts '-----------'

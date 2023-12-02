# # # PART ONE # # #
# Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green
# Game 2: 1 blue, 2 green; 3 green, 4 blue, 1 red; 1 green, 1 blue
# Game 3: 8 green, 6 blue, 20 red; 5 blue, 4 red, 13 green; 5 green, 1 red
# Game 4: 1 green, 3 red, 6 blue; 3 green, 6 red; 3 green, 15 blue, 14 red
# Game 5: 6 red, 1 blue, 3 green; 2 blue, 1 red, 2 green
# games possible => 1, 2, 5
# sum => 8

# méthode pour récupérer les parties
# entrée = "Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green"
# sortie = ["3 blue, 4 red", "1 red, 2 green, 6 blue", "2 green"]
def sets(str)
  str.slice!(0,8)
  str.split(';').map(&:strip)
end

# méthode pour créer un objet pour une partie
# entrée = "1 red, 2 green, 6 blue"
# sortie = {red: 1, green: 2, blue: 6}
def set_to_hash(str)
  draws = str.split(',').map(&:strip)
  draws.map! { |s| s.split(' ').reverse }
  draws.map! { |s| [s[0].to_sym, s[1].to_i]}.to_h
end

# méthode transformer la ligne de texte en pair clé-valeur
# entrée = "Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green"
# sortie = [{blue: 3, red: 4}, {red: 1, green: 2, blue: 6}, {green: 2}]
def create_value(str)
  sets = sets(str)
  sets.map{ |set| set_to_hash(set)}
end

# méthode pour vérifier un set
# entrées = {:blue=>3, :red=>4}  || {:green=>8, :red=>20, :blue=>6}
# sorties = 0                    || 1
def is_set_possible(set)
  count = 0
  count += 1 if set[:red] && set[:red] > 12
  count += 1 if set[:green] && set[:green] > 13
  count += 1 if set[:blue] && set[:blue] > 14
  count
end

# méthode pour vérifier si un jeu est possible
# entrée = [{:blue=>3, :red=>4}, {:red=>1, :green=>2, :blue=>6}, {:green=>2}]
# sortie = true
def is_game_possible(game)
  answer = 0
  game.each do |set|
    answer += is_set_possible(set)
  end
  answer == 0
end

# méthode pour trouver la réponse
# entrée = [[{}, {}], [{}, {}]]
# sortie = 8
def give_answer(games)
  games_possible = []
  games.each_with_index do |game, index|
    games_possible << index + 1 if is_game_possible(game)
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

puts "Réponse de la partie 1 :"
puts give_answer(games)
puts "-----------"

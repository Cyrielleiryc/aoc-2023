# # # PART ONE # # #
# Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green
# Game 2: 1 blue, 2 green; 3 green, 4 blue, 1 red; 1 green, 1 blue
# Game 3: 8 green, 6 blue, 20 red; 5 blue, 4 red, 13 green; 5 green, 1 red
# Game 4: 1 green, 3 red, 6 blue; 3 green, 6 red; 3 green, 15 blue, 14 red
# Game 5: 6 red, 1 blue, 3 green; 2 blue, 1 red, 2 green
# only 12 red cubes, 13 green cubes, and 14 blue cubes
# games possible => 1, 2, 5
# sum => 8

# méthode pour récupérer le numéro du jeu
# entrée = "Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green"
# sortie = 1
def number_of_game(str)
  str[5].to_i
end

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
# puts "create_value('Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green')"
# puts "should return an object : "
# puts create_value("Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green") == [{blue: 3, red: 4}, {red: 1, green: 2, blue: 6}, {green: 2}]

# on récupère les données
games = {}

puts "Entrez les lignes (tapez 'fin' pour terminer la saisie) :"
input = gets.chomp

while input.downcase != 'fin'
  games[number_of_game(input)] = create_value(input)
  input = gets.chomp
end

puts games.to_s

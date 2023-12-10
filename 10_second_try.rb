require 'set'

# Représentation du labyrinthe sous forme de chaîne de caractères
# labyrinth_str = "
# ┌┌┐┌┼┌┐┌┐┌┐┌┐┌┐┌───┐
# └│└┘││││││││││││┌──┘
# ┌└─┐└┘└┘││││││└┘└─┐┐
# ┌──┘┌──┐││└┘└┘┐┌┐┌┘─
# └───┘┌─┘└┘ ││─┌┘└┘┘┐
# │┌│┌─┘┌───┐┌┐─└┐└│┐│
# │┌┌┘┌┐└┐┌─┘┌┐│┘└───┐
# ┐─└─┘└┐││┌┐│└┐┌─┐┌┐│
# └ └┐└┌┘│││││┌┘└┐││└┘
# └┐┘└┘└─┘└┘└┘└──┘└┘ └
# "
labyrinth_str = "
  ─└|┌┐
  ┐┼─┐|
  └|┐||
  ─└─┘|
  └|─┘┌
"

# Convertir la chaîne en une structure de données (matrice)
labyrinth = labyrinth_str.strip.split("\n").map { |line| line.chars }

# Fonction pour trouver un chemin à travers le labyrinthe en utilisant la recherche en profondeur (DFS)
def find_path_dfs(labyrinth, start_x, start_y, end_x, end_y, visited = Set.new)
  return false if start_x < 0 || start_x >= labyrinth.length || start_y < 0 || start_y >= labyrinth[0].length
  return false if labyrinth[start_x][start_y] == "─" || visited.include?([start_x, start_y])

  return true if start_x == end_x && start_y == end_y

  visited.add([start_x, start_y])

  # Déplacements possibles : haut, bas, gauche, droite
  directions = [[-1, 0], [1, 0], [0, -1], [0, 1]]

  directions.each do |dx, dy|
    new_x = start_x + dx
    new_y = start_y + dy

    if find_path_dfs(labyrinth, new_x, new_y, end_x, end_y, visited)
      return true
    end
  end

  visited.delete([start_x, start_y]) # Retirer la position actuelle du chemin
  return false
end

# Exemple d'utilisation pour trouver un chemin du coin supérieur gauche au coin inférieur droit
start_x, start_y = 0, 0
end_x, end_y = labyrinth.length - 1, labyrinth[0].length - 1

if find_path_dfs(labyrinth, 1, 1, 1, 1)
  puts "Chemin trouvé !"
else
  puts "Aucun chemin trouvé."
end

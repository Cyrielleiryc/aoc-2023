# # # DATA # # #

# méthode pour trouver les coordonnées de chaque partie d'une brique
# /!\ cette méthode modifie directement dans le snapshot
def find_direction(brick)
  return :x if brick[0][:x] != brick[1][:x]
  return :y if brick[0][:y] != brick[1][:y]
  return :z if brick[0][:z] != brick[1][:z]
end
def whole_brick(brick)
  dir = find_direction(brick)
  min_max = brick.map { |ext| ext[dir] }
  min = min_max.min + 1
  max = min_max.max
  return if min == max
  other_dir = [:x, :y, :z].reject { |d| d == dir }
  (min...max).each do |new_coord|
    new_part = {
      other_dir[0] => brick[0][other_dir[0]],
      other_dir[1] => brick[0][other_dir[1]]
    }
    new_part[dir] = new_coord
    brick << new_part
  end
end

# méthode pour donner le plus bas 'z' d'une brique
def lowest_z(brick)
  brick.map { |part| part[:z] }.min
end

# méthode pour trier les briques en fonction de z
# /!\ cette méthode modifie directement l'ordre des briques
def sort_bricks(bricks)
  bricks.sort_by! { |brick| lowest_z(brick) }
end

snapshot = []
puts "Entrez les lignes (tapez 'fin' pour terminer la saisie) :"
input = gets.chomp

while input.downcase != 'fin'
  pieces = input.split('~')
  brick = []
  pieces.each do |extremity|
    coordinates = extremity.split(',').map(&:to_i)
    brick << { x: coordinates[0], y: coordinates[1], z: coordinates[2] }
  end
  whole_brick(brick) unless brick[0] == brick[1]
  snapshot << brick
  input = gets.chomp
end

test_bricks = [
  [{ x: 1, y: 0, z: 1 }, { x: 1, y: 2, z: 1 }, { x: 1, z: 1, y: 1 }], # A > 0
  [{ x: 0, y: 0, z: 2 }, { x: 2, y: 0, z: 2 }, { y: 0, z: 2, x: 1 }], # B > 1
  [{ x: 0, y: 2, z: 3 }, { x: 2, y: 2, z: 3 }, { y: 2, z: 3, x: 1 }], # C > 2
  [{ x: 0, y: 0, z: 4 }, { x: 0, y: 2, z: 4 }, { x: 0, z: 4, y: 1 }], # D > 3
  [{ x: 2, y: 0, z: 5 }, { x: 2, y: 2, z: 5 }, { x: 2, z: 5, y: 1 }], # E > 4
  [{ x: 0, y: 1, z: 6 }, { x: 2, y: 1, z: 6 }, { y: 1, z: 6, x: 1 }], # F > 5
  [{ x: 1, y: 1, z: 8 }, { x: 1, y: 1, z: 9 }]                        # G > 6
]

test_bricks_collapsed = [
  [{:x=>1, :y=>0, :z=>1}, {:x=>1, :y=>2, :z=>1}, {:x=>1, :z=>1, :y=>1}], # A > 0
  [{:x=>0, :y=>0, :z=>2}, {:x=>2, :y=>0, :z=>2}, {:y=>0, :z=>2, :x=>1}], # B > 1
  [{:x=>0, :y=>2, :z=>2}, {:x=>2, :y=>2, :z=>2}, {:y=>2, :z=>2, :x=>1}], # C > 2
  [{:x=>0, :y=>0, :z=>3}, {:x=>0, :y=>2, :z=>3}, {:x=>0, :z=>3, :y=>1}], # D > 3
  [{:x=>2, :y=>0, :z=>3}, {:x=>2, :y=>2, :z=>3}, {:x=>2, :z=>3, :y=>1}], # E > 4
  [{:x=>0, :y=>1, :z=>4}, {:x=>2, :y=>1, :z=>4}, {:y=>1, :z=>4, :x=>1}], # F > 5
  [{:x=>1, :y=>1, :z=>5}, {:x=>1, :y=>1, :z=>6}]                         # G > 6
]

test_simple_structure = {
  0=>[1, 2],
  1=>[3, 4],
  2=>[3, 4],
  3=>[5],
  4=>[5],
  5=>[6]
}

# # # PART ONE # # #

def vertical_brick?(my_brick)
  my_brick.map { |part| part[:z] }.uniq.length > 1
end

# méthode pour trouver toutes les cases occupées par des briques sur un étage
# entrée => z, toutes les briques
# sortie => [{:x=>1, :y=>0, :z=>1}, {:x=>1, :y=>2, :z=>1}, {:x=>1, :z=>1, :y=>1}]
def busy_tiles(z, bricks)
  bricks.flatten.select { |part| part[:z] == z }
end

# méthode pour donner les cases juste en dessous
def tiles_below(my_brick)
  if vertical_brick?(my_brick)
    lowest_z = lowest_z(my_brick)
    return [{ x: my_brick[0][:x], y: my_brick[0][:y], z: lowest_z - 1}]
  end
  tiles_below = []
  my_brick.each do |part|
    tiles_below << { x: part[:x], y: part[:y], z: part[:z] - 1 }
  end
  tiles_below
end

# méthode pour dire si les cases du dessous sont vides
def below_is_empty?(my_brick, bricks)
  z_below = lowest_z(my_brick) - 1
  busy_tiles = busy_tiles(z_below, bricks)
  return true if busy_tiles.empty?

  tiles_below(my_brick).each do |tile|
    return false if busy_tiles.include?(tile)
  end
  true
end

# méthode pour trouver à quelle brique appartient une partie qui supporte une brique
# entrée => {:x=>1, :y=>0, :z=>1}, toutes les briques
# sortie => brique 'A'
def find_brick_on_tile(tile, bricks)
  bricks.find { |brick| brick.include?(tile) }
end

# méthode pour faire descendre une brique jusqu'à ce qu'elle soit posée sur une autre
# entrée => briquée étudiée, toutes les briques
# sortie => [briques dessous]
def fall_downward(my_brick, bricks)
  while below_is_empty?(my_brick, bricks)
    my_brick.each { |part| part[:z] -= 1 }
  end
  supporting_tiles = tiles_below(my_brick).select do |tile|
    busy_tiles(tile[:z], bricks).include?(tile)
  end
  supporting_tiles.map { |tile| find_brick_on_tile(tile, bricks) }.uniq
end

# méthode pour faire tomber toutes les briques le plus bas possible
def collapse_bricks(bricks)
  structure = {}
  bricks.each_with_index do |brick, index|
    next if lowest_z(brick) == 1

    bricks_below = fall_downward(brick, bricks)
    bricks_below.each do |brick_below|
      if structure[bricks.index(brick_below)]
        structure[bricks.index(brick_below)] << index
      else
        structure[bricks.index(brick_below)] = [index]
      end
    end
  end
  structure
end

# méthode pour dire si une brique est supprimable
def brick_can_go?(index, structure)
  return true if !structure.keys.include?(index)

  structure[index].each do |brick_above|
    return false if structure.values.flatten.count(brick_above) == 1
  end
  true
end

def answer1(snapshot)
  count = 0
  # snapshot.each { |brick| whole_brick(brick) }
  sort_bricks(snapshot)
  structure = collapse_bricks(snapshot)
  (0...snapshot.length).each do |i|
    count += 1 if brick_can_go?(i, structure)
  end
  count
end

# # # PART TWO # # #

# # # ANSWERS # # #

puts '-----------'
puts 'Réponse de la partie 1 :'
puts answer1(snapshot)
puts '-----------'
# right 439

# puts 'Réponse de la partie 2 :'
# puts '-----------'
# right 43056

# méthode pour
# entrée =>
# sortie =>

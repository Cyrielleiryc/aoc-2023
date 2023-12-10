test1 = %w[
  .....
  .S-7.
  .|.|.
  .L-J.
  .....
]

test1bis = %w[
  -L|F7
  7S-7|
  L|7||
  -L-J|
  L|-JF
]

test2 = %w[
  ..F7.
  .FJ|.
  SJ.L7
  |F--J
  LJ...
]

test2bis = %w[
  7-F7-
  .FJ|7
  SJLL7
  |F--J
  LJ.LJ
]

=begin
        | is a vertical pipe connecting north and south
        - is a horizontal pipe connecting east and west
        L is a 90-degree bend connecting north and east
        J is a 90-degree bend connecting north and west
        7 is a 90-degree bend connecting south and west
        F is a 90-degree bend connecting south and east
=end

# méthode pour trouver les coordonnées de S => [x, y]
# entrée => toutes les lignes sous format [[line1], [line2], etc]
# sortie => [1, 1] || [0, 2]
def find_start(tiles)
  tiles.each_with_index do |tile, y|
    next unless tile.include?('S')

    tile.chars.each_with_index do |char, x|
      return [x, y] if char == 'S'
    end
  end
end













# méthode pour
# entrée =>
# sortie =>

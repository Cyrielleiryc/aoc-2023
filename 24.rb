# # # DATA # # #

# méthode pour calculer la fonction affine d'un grêlon
def affine_function(hailstone)
  point_a = { x: hailstone[:p][:x], y: hailstone[:p][:y] }
  point_b = { x: point_a[:x] + hailstone[:v][0], y: point_a[:y] + hailstone[:v][1]}
  a = (point_b[:y] - point_a[:y]).fdiv(point_b[:x] - point_a[:x])
  b = point_a[:y] - (a * point_a[:x])
  hailstone[:f] = { a: a, b: b }
end

hailstones = []
puts "Entrez les lignes (tapez 'fin' pour terminer la saisie) :"
input = gets.chomp

while input.downcase != 'fin'
  infos = input.split(' @ ')
  position = infos[0].split(', ').map(&:to_i)
  speed = infos[1].split(', ').map(&:to_i)
  hailstone = { p: { x: position[0], y: position[1], z: position[2] }, v: speed }
  affine_function(hailstone)
  hailstones << hailstone
  input = gets.chomp
end

test_hailstones = [
  { p: { x: 19, y: 13, z: 30 }, v: [-2, 1, -2], f: { :a=>-0.5, :b=>22.5 } },
  { p: { x: 18, y: 19, z: 22 }, v: [-1, -1, -2], f: { :a=>1.0, :b=>1.0 } },
  { p: { x: 20, y: 25, z: 34 }, v: [-2, -2, -4], f: { :a=>1.0, :b=>5.0 } },
  { p: { x: 12, y: 31, z: 28 }, v: [-1, -2, -1], f: { :a=>2.0, :b=>7.0 } },
  { p: { x: 20, y: 19, z: 15 }, v: [1, -5, -3], f: { :a=>-5.0, :b=>119.0 } }
]

# # # PART ONE # # #

# méthode pour trouver les coordonnées [x, y] du point d'intersection de deux droites
def intersection(h1, h2)
  return if h1[:f][:a] == h2[:f][:a]
  x = (h2[:f][:b] - h1[:f][:b]).fdiv(h1[:f][:a] - h2[:f][:a])
  y = (h1[:f][:a] * x) + h1[:f][:b]
  cond11 = h1[:v][0].positive? ? x > h1[:p][:x] : x < h1[:p][:x]
  cond12 = h1[:v][1].positive? ? y > h1[:p][:y] : y < h1[:p][:y]
  cond21 = h2[:v][0].positive? ? x > h2[:p][:x] : x < h2[:p][:x]
  cond22 = h2[:v][1].positive? ? y > h2[:p][:y] : y < h2[:p][:y]
  [x, y] if [cond11, cond12, cond21, cond22].all?
end

def answer1(hailstones, min, max)
  count = 0
  hailstones.combination(2).to_a.each do |pair|
    intersection = intersection(pair[0], pair[1])
    if intersection && (min..max).include?(intersection[0]) && (min..max).include?(intersection[1])
      count += 1
    end
  end
  count
end

# # # PART TWO # # #

# # # ANSWERS # # #

puts '-----------'
puts 'Réponse de la partie 1 :'
puts answer1(hailstones, 200000000000000, 400000000000000)
puts '-----------'

# puts 'Réponse de la partie 2 :'
# puts '-----------'

# méthode pour
# entrée =>
# sortie =>

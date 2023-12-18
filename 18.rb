# # # DATA # # #

digplan = []
colors = []
puts "Entrez les lignes (tapez 'fin' pour terminer la saisie) :"
input = gets.chomp

while input.downcase != 'fin'
  digplan << input.split(' ')[0..1]
  digplan.map! { |step| [step[0], step[1].to_i] }
  colors << input.split(' ')[-1].gsub('(', '').gsub(')', '')
  input = gets.chomp
end

# # # PART ONE # # #

# méthodes pour suivre les instructions du digplan
def one_step(last_pos, stage)
  case stage[0]
  when 'U'
    return [last_pos[0], last_pos[1] - stage[1]]
  when 'D'
    return [last_pos[0], last_pos[1] + stage[1]]
  when 'L'
    return [last_pos[0] - stage[1], last_pos[1]]
  when 'R'
    return [last_pos[0] + stage[1], last_pos[1]]
  end
end

def follow_plan(digplan)
  pos = [0, 0]
  corners = [pos]
  digplan.each do |stage|
    pos = one_step(pos, stage)
    corners << pos
  end
  corners
end

# méthodes pour calculer l'aire total
def shoelace_formula(vertices)
  total = 0
  i = 0
  while i < vertices[0].length - 1
    total += (vertices[0][i] * vertices[1][i + 1])
    total -= (vertices[1][i] * vertices[0][i + 1])
    i += 1
  end
  total / 2
end

def perimeter(digplan)
  digplan.sum { |stage| stage[1] }
end

def answer1(digplan)
  vertices = follow_plan(digplan)
  aera = shoelace_formula(vertices.transpose)
  demi_perimeter = perimeter(digplan) / 2
  aera + demi_perimeter + 1
end

# # # PART TWO # # #

DIRECTION_TO_DIG = {
  '0' => 'R',
  '1' => 'D',
  '2' => 'L',
  '3' => 'U'
}.freeze

# méthode pour convertir une couleur en digplan
# entrée => '#70c710'
# sortie => ['R', 461937]
def convert_color(color)
  hexadecimal = color[1..5]
  direction = DIRECTION_TO_DIG[color[6]]
  [direction, hexadecimal.to_i(16)]
end

def answer2(colors)
  new_digplan = colors.map { |color| convert_color(color) }
  answer1(new_digplan)
end

# # # ANSWERS # # #

puts '-----------'
puts 'Réponse de la partie 1 :'
puts answer1(digplan)
puts '-----------'

puts 'Réponse de la partie 2 :'
puts answer2(colors)
puts '-----------'

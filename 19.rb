# # # DATA # # #

workflows = {}
puts "Entrez les lignes (tapez 'fin' pour terminer la saisie) :"
input = gets.chomp

while input.downcase != ''
  workflow = input.chop.split('{')
  conditions = workflow[1].split(',').map { |c| c.split(':') }
  workflows[workflow[0]] = conditions
  input = gets.chomp
end

parts = []
input = gets.chomp

while input.downcase != 'fin'
  part_array = input.chop.split('{')[1].split(',')
  part = {}
  part_array.each do |ratings|
    rating = ratings.split('=')
    part[rating[0]] = rating[1].to_i
  end
  parts << part
  input = gets.chomp
end

test_workflows = {
  'px' => [['a<2006', 'qkq'], ['m>2090', 'A'], ['rfg']],
  'pv' => [['a>1716', 'R'], ['A']],
  'lnx' => [['m>1548', 'A'], ['A']],
  'rfg' => [['s<537', 'gd'], ['x>2440', 'R'], ['A']],
  'qs' => [['s>3448', 'A'], ['lnx']],
  'qkq' => [['x<1416', 'A'], ['crn']],
  'crn' => [['x>2662', 'A'], ['R']],
  'in' => [['s<1351', 'px'], ['qqz']],
  'qqz' => [['s>2770', 'qs'], ['m<1801', 'hdj'], ['R']],
  'gd' => [['a>3333', 'R'], ['R']],
  'hdj' => [['m>838', 'A'], ['pv']]
}

test_parts = [
  {'x' => 787, 'm' => 2655, 'a' => 1222, 's' => 2876}, # in -> qqz -> qs -> lnx -> A
  {'x' => 1679, 'm' => 44, 'a' => 2067, 's' => 496}, # in -> px -> rfg -> gd -> R
  {'x' => 2036, 'm' => 264, 'a' => 79, 's' => 2244}, # in -> qqz -> hdj -> pv -> A
  {'x' => 2461, 'm' => 1339, 'a' => 466, 's' => 291}, # in -> px -> qkq -> crn -> R
  {'x' => 2127, 'm' => 1623, 'a' => 2188, 's' => 1013} # in -> px -> rfg -> A
]

test_accepted_parts = [
  {'x' => 787, 'm' => 2655, 'a' => 1222, 's' => 2876},
  {'x' => 2036, 'm' => 264, 'a' => 79, 's' => 2244},
  {'x' => 2127, 'm' => 1623, 'a' => 2188, 's' => 1013}
]

# # # PART ONE # # #

# méthode pour donner la destination d'une pièce
# entrée => pièce, conditions => {:x => 787, :m => 2655, :a => 1222, :s => 2876}, [['s<1351', 'px'], ['qqz']]
# sortie => destination       => 'qqz'
def destination(part, conditions)
  conditions.each do |condition|
    if condition[0].include?('<')
      cat = condition[0].split('<')[0]
      ref = condition[0].split('<')[1].to_i
      return condition[1] if part[cat] < ref
    elsif condition[0].include?('>')
      cat = condition[0].split('>')[0]
      ref = condition[0].split('>')[1].to_i
      return condition[1] if part[cat] > ref
    else
      return condition[0]
    end
  end
end

# méthode pour savoir si une pièce est acceptée ou rejetée
def accepted?(part, workflows)
  destination = destination(part, workflows['in'])
  until ['A', 'R'].include?(destination)
    destination = destination(part, workflows[destination])
  end
  destination == 'A'
end

# méthode pour trouver toutes les pièces acceptées
def accepted_parts(parts, workflows)
  accepted_parts = []
  parts.each do |part|
    accepted_parts << part if accepted?(part, workflows)
  end
  accepted_parts
end

# méthode pour calculer le total d'une pièce
def total_one_part(part)
  part.values.sum
end

def answer1(parts, workflows)
  accepted_parts = accepted_parts(parts, workflows)
  accepted_parts.sum { |part| total_one_part(part) }
end

# # # PART TWO # # #

# # # ANSWERS # # #

# puts '-----------'
# puts 'Réponse de la partie 1 :'
puts answer1(parts, workflows)
# puts '-----------'

# puts 'Réponse de la partie 2 :'
# puts '-----------'

# méthode pour
# entrée =>
# sortie =>

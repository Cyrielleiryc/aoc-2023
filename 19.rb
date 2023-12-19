# # # DATA # # #

# workflows = {}
# puts "Entrez les lignes (tapez 'fin' pour terminer la saisie) :"
# input = gets.chomp

# while input.downcase != ''
#   workflow = input.chop.split('{')
#   conditions = workflow[1].split(',').map { |c| c.split(':') }
#   workflows[workflow[0]] = conditions
#   input = gets.chomp
# end

# parts = []
# input = gets.chomp

# while input.downcase != 'fin'
#   part_array = input.chop.split('{')[1].split(',')
#   part = {}
#   part_array.each do |ratings|
#     rating = ratings.split('=')
#     part[rating[0]] = rating[1].to_i
#   end
#   parts << part
#   input = gets.chomp
# end

test_parts = [
  {'x' => 787, 'm' => 2655, 'a' => 1222, 's' => 2876}, # in -> qqz -> qs -> lnx -> A
  {'x' => 1679, 'm' => 44, 'a' => 2067, 's' => 496}, # in -> px -> rfg -> gd -> R
  {'x' => 2036, 'm' => 264, 'a' => 79, 's' => 2244}, # in -> qqz -> hdj -> pv -> A
  {'x' => 2461, 'm' => 1339, 'a' => 466, 's' => 291}, # in -> px -> qkq -> crn -> R
  {'x' => 2127, 'm' => 1623, 'a' => 2188, 's' => 1013} # in -> px -> rfg -> A
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

def change_part(range, symbol, ref)
  range_under = range.min..ref
  range_above = ref..range.max
  if symbol == '<' && range.include?(ref)
    [range.min...ref, ref..range.max]
    # [range_under, range_above]
  elsif symbol == '<' && range.max < ref
    [range]
  elsif symbol == '>' && range.include?(ref)
    [ref...range.max, range.min..ref]
    # [range_above, range_under]
  elsif symbol == '>' && range.min < ref
    [range]
  end
end

def destination2(part, conditions)
  output = []
  conditions.each do |cond|
    next if cond.length < 2

    part_copy = part.dup
    cat = cond[0][0]
    symbol = cond[0][1]
    ref = cond[0].split(symbol)[1].to_i
    comparison = change_part(part[cat], symbol, ref)
    if comparison[0] && comparison.length == 1
      part_copy[cat] = comparison[0]
      return [part_copy, cond[1]]
    elsif comparison[0] && comparison.length == 2
      part_copy[cat] = comparison[0]
      output << [part_copy, cond[1]]
      part[cat] = comparison[1]
    end
  end
  output << [part, conditions[-1][0]]
end

def through_all_workflows(workflows)
  accepted_parts = []
  start = { 'x' => 1..4000, 'm' => 1..4000, 'a' => 1..4000, 's' => 1..4000 }
  parts = [[start, 'in']]
  until parts.empty?
    accepted_parts << parts.select { |element| element[1] == 'A' }
    parts.reject! { |element| element[1] == 'R' || element[1] == 'A' }
    results = []
    parts.each do |part|
      results += destination2(part[0], workflows[part[1]])
    end
    parts = results
    # puts parts
    # puts "--------------------------------------------"
  end
  accepted_parts.flatten.reject { |item| item == 'A' }
end

accepted_parts = [
  { 'x' => 1..4000, 'm' => 2090...4000, 'a' => 2006..4000, 's' => 1...1351 },
  { 'x' => 1...1416, 'm' => 1..4000, 'a' => 1...2006, 's' => 1...1351 },
  { 'x' => 1..2440, 'm' => 1..2090, 'a' => 2006..4000, 's' => 537..1350 },
  { 'x' => 1..4000, 'm' => 1..4000, 'a' => 1..4000, 's' => 3448...3999 },
  { 'x' => 1..4000, 'm' => 838...1800, 'a' => 1..4000, 's' => 1351..2770 },
  { 'x' => 2662...4000, 'm' => 1..4000, 'a' => 1...2006, 's' => 1...1351 },
  { 'x' => 1..4000, 'm' => 1548...4000, 'a' => 1..4000, 's' => 2770..3448 },
  { 'x' => 1..4000, 'm' => 1..1548, 'a' => 1..4000, 's' => 2770..3448 },
  { 'x' => 1..4000, 'm' => 1..838, 'a' => 1..1716, 's' => 1351..2770 }
]

def total_one_part2(part)
  numbers = part.values.map(&:count)
  numbers.reduce(1) { |product, num| product * num }
end

def answer2(workflows)
  accepted_parts = through_all_workflows(workflows)
  puts accepted_parts
  accepted_parts.sum { |acc_part| total_one_part2(acc_part) }
end

# # # ANSWERS # # #

# puts '-----------'
# puts 'Réponse de la partie 1 :'
# puts answer1(parts, workflows)
puts '-----------'

puts 'Réponse de la partie 2 :'
puts answer2(test_workflows) == 167409079868000
# puts answer2(workflows)
puts '-----------'
# wrong => 125291062024086 (too low)

# méthode pour
# entrée =>
# sortie =>

# proba
# x => 1 2 3 => 3
# m => 4 5 6 => 3
# a => 7 8 9 => 3
# s => A B C => 1
# 3 * 3 * 3 * 1 = 27

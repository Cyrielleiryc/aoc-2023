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
  destination = destination(part, workflows[destination]) until %w[A R].include?(destination)
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

def change_part(range, symbol, ref)
  if symbol == '<' && range.include?(ref)
    [range.min...ref, ref..range.max]
  elsif symbol == '<' && range.max < ref
    [range]
  elsif symbol == '>' && range.include?(ref)
    [ref + 1..range.max, range.min..ref]
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
  end
  accepted_parts.flatten.reject { |item| item == 'A' }
end

def total_one_part2(part)
  numbers = part.values.map(&:count)
  numbers.reduce(1) { |product, num| product * num }
end

def answer2(workflows)
  accepted_parts = through_all_workflows(workflows)
  accepted_parts.sum { |acc_part| total_one_part2(acc_part) }
end

# # # ANSWERS # # #

puts '-----------'
puts 'Réponse de la partie 1 :'
puts answer1(parts, workflows)
puts '-----------'

puts 'Réponse de la partie 2 :'
puts answer2(workflows)
puts '-----------'

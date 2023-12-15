require_relative '15_data'

# # # DATA # # #

sequence = @data.split(',')

# # # PART ONE # # #

# méthode pour donner le résultat d'un algo
@codes = {} # memoized string and its output
def result_algo(algo)
  current_value = 0
  algo.bytes.each do |code|
    dividende = (current_value + code) * 17
    current_value = dividende.remainder(256)
  end
  @codes[algo] = current_value
  current_value
end

def answer1(sequence)
  sequence.sum { |algo| result_algo(algo) }
end

# # # PART TWO # # #

# méthode pour trouver la position d'une lentille en fonction de l'étiquette
def find_lense(label, box)
  i = nil
  box.each_with_index do |old_lens, index|
    i = index if old_lens[0] == label
  end
  i
end

# méthode pour gérer le fait que la boite contient déjà des lentilles
def handle_lenses(lens, box)
  i = find_lense(lens[0], box)
  i.nil? ? box << lens : box[i] = lens
  box
end

# méthode pour ajouter une lentille
def add_lens(algo, boxes)
  lens = [algo.split('=')[0], algo.split('=')[1].to_i]
  box_number = @codes[lens[0]] || result_algo(lens[0])
  if boxes[box_number] && boxes[box_number].empty?
    boxes[box_number] << lens
  elsif boxes[box_number] && !boxes[box_number].empty?
    boxes[box_number] = handle_lenses(lens, boxes[box_number])
  else
    boxes[box_number] = [lens]
  end
  boxes
end

# méthode pour supprimer une lentille
def remove_lens(algo, boxes)
  label = algo.split('-')[0]
  box_number = @codes[label] || result_algo(label)
  if boxes[box_number] && find_lense(label, boxes[box_number])
    boxes[box_number].delete_at(find_lense(label, boxes[box_number]))
  end
  boxes
end

# méthode pour donner le contenu des boites à la fin de l'algorithme
def steps_of_sequence(sequence)
  boxes = {}
  sequence.each do |algo|
    if algo.include?('=')
      boxes = add_lens(algo, boxes)
    else
      boxes = remove_lens(algo, boxes)
    end
  end
  boxes
end

# méthode pour calculer le score d'une boîte
def score_one_box(box_number, lenses)
  return 0 if lenses.empty?

  score = 0
  lenses.each_with_index do |lens, index|
    focusing_pwr = (box_number + 1) * (index + 1) * lens[1]
    score += focusing_pwr
  end
  score
end

def answer2(sequence)
  boxes = steps_of_sequence(sequence)
  final_score = 0
  boxes.each do |box_number, lenses|
    final_score += score_one_box(box_number, lenses)
  end
  final_score
end

# # # ANSWERS # # #

puts '-----------'
puts 'Réponse de la partie 1 :'
puts answer1(sequence)
puts '-----------'

puts 'Réponse de la partie 2 :'
puts answer2(sequence)
puts '-----------'

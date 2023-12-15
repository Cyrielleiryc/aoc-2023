# # # PART ONE # # #

test1_input = 'HASH'
test1_seq = ['HASH']
test1_result = 52

test2_input = 'rn=1,cm-,qp=3,cm=2,qp-,pc=4,ot=9,ab=5,pc-,pc=6,ot=7'
test2_seq = [
  'rn=1', # 30
  'cm-', # 253
  'qp=3', # 97
  'cm=2', # 47
  'qp-', # 14
  'pc=4', # 180
  'ot=9', # 9
  'ab=5', # 197
  'pc-', # 48
  'pc=6', # 214
  'ot=7' # 231
]
test2_result = 1320

# méthode pour donner le résultat d'un algo
# entrée => 'HASH' || 'rn=1'
# sortie => 52     || 30
def result_algo(algo)
  ascii_codes = algo.chars.map(&:ord)
  current_value = 0
  ascii_codes.each do |code|
    dividende = (current_value + code) * 17
    current_value = dividende.remainder(256)
  end
  current_value
end

def answer1(sequence)
  sequence.sum { |algo| result_algo(algo) }
end

# puts answer1(test2_seq)

# # # PART TWO # # #

# # # ANSWERS # # #

# getting the data from the terminal
puts "Entrez les lignes (tapez 'entrer' pour terminer la saisie) :"
sequence = gets.chomp.split(',').map(&:strip)

puts '-----------'
puts 'Réponse de la partie 1 :'
puts answer1(sequence)
puts '-----------'
# wrong => 90844 (too low)

# puts 'Réponse de la partie 2 :'
# puts '-----------'

# méthode pour
# entrée =>
# sortie =>

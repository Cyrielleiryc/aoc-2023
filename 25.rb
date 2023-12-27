# # # DATA # # #

# méthode pour créer les paires reliées
def create_pairs(line)
  first = line.split(':')[0]
  seconds = line.split(': ')[1].split(' ')
  seconds.map { |second| [first, second] }
end

# diagram = []
# components = {}
# puts "Entrez les lignes (tapez 'fin' pour terminer la saisie) :"
# input = gets.chomp

# while input.downcase != 'fin'
#   pairs = create_pairs(input).reject { |pair| diagram.include?(pair) || diagram.include?(pair.reverse) }
#   keys = input.gsub(':', '').split(' ')
#   keys.each do |key|
#     next if components[key]

#     components[key] = 'grey'
#   end
#   diagram += pairs
#   input = gets.chomp
# end

test_diagram = [
  ['jqt', 'rhn'],
  ['jqt', 'xhk'],
  ['jqt', 'nvd'], # to destroy
  ['rsh', 'frs'],
  ['rsh', 'pzl'],
  ['rsh', 'lsr'],
  ['xhk', 'hfx'],
  ['cmg', 'qnr'],
  ['cmg', 'nvd'],
  ['cmg', 'lhk'],
  ['cmg', 'bvb'], # to destroy
  ['rhn', 'xhk'],
  ['rhn', 'bvb'],
  ['rhn', 'hfx'],
  ['bvb', 'xhk'],
  ['bvb', 'hfx'],
  ['pzl', 'lsr'],
  ['pzl', 'hfx'], # to destroy
  ['pzl', 'nvd'],
  ['qnr', 'nvd'],
  ['ntq', 'jqt'],
  ['ntq', 'hfx'],
  ['ntq', 'bvb'],
  ['ntq', 'xhk'],
  ['nvd', 'lhk'],
  ['lsr', 'lhk'],
  ['rzs', 'qnr'],
  ['rzs', 'cmg'],
  ['rzs', 'lsr'],
  ['rzs', 'rsh'],
  ['frs', 'qnr'],
  ['frs', 'lhk'],
  ['frs', 'lsr']
]

test_components = {'jqt'=>'grey', 'rhn'=>'grey', 'xhk'=>'grey', 'nvd'=>'grey', 'rsh'=>'grey', 'frs'=>'grey', 'pzl'=>'grey', 'lsr'=>'grey', 'hfx'=>'grey', 'cmg'=>'grey', 'qnr'=>'grey', 'lhk'=>'grey', 'bvb'=>'grey', 'ntq'=>'grey', 'rzs'=>'grey'}

# # # PART ONE # # #

def color_components(pairs, components)
  
end
puts color_components(test_diagram, test_components).to_s

# # # PART TWO # # #

# # # ANSWERS # # #

# puts '-----------'
# puts 'Réponse de la partie 1 :'
# puts '-----------'

# puts 'Réponse de la partie 2 :'
# puts '-----------'

# méthode pour
# entrée =>
# sortie =>

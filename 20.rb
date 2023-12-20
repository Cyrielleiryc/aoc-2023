# # # DATA # # #

# config = {}
# puts "Entrez les lignes (tapez 'fin' pour terminer la saisie) :"
# input = gets.chomp

# while input.downcase != 'fin'
#   pieces = input.split(' -> ')
#   destinations = pieces[1].split(',').map(&:strip)
#   if pieces[0] == 'broadcaster'
#     config['broadcaster'] = { type: 'broadcaster', dest: destinations }
#   elsif pieces[0][0] == '%'
#     config[pieces[0][1..]] = { type: '%', dest: destinations, status: 'off' }
#   elsif pieces[0][0] == '&'
#     config[pieces[0][1..]] = { type: '&', dest: destinations, memory: [['low'], ['low']] }
#   end
#   input = gets.chomp
# end

#   flip-flop %         conjunction &             broadcaster     button
#   initially off       memory = low
#   high => nothing     high => memory += high    high => high    low to broad
#   low => was off?     low => memory += low      low => low
#         on + high     if memory all high
#       => was on?          => low
#         off + low     otherwise => high

# explication de la mémoire des conjunctions
# au départ => [['low'], ['low']]
# on appuie sur le bouton => on supprime la première mémoire, on rajoute une mémoire vide
# avant de recevoir les pulses => [['low'], []]
# lorsqu'on reçoit un pulse, on regarde la mémoire du premier tableau, on met à jour la mémoire du 2e tableau

test1_config = {
  'broadcaster' => { type: 'broadcaster', dest: ['a', 'b', 'c'] },
  'a' => { type: '%', dest: ['b'], status: 'off' },
  'b' => { type: '%', dest: ['c'], status: 'off' },
  'c' => { type: '%', dest: ['inv'], status: 'off' },
  'inv' => { type: '&', dest: ['a'], memory: [['low'], ['low']] }
}

test2_config = {
  'broadcaster' => { type: 'broadcaster', dest: ['a'] },
  'a' => { type: '%', dest: ['inv', 'con'], status: 'off' },
  'inv' => { type: '&', dest: ['b'], memory: [['low'], ['low']] },
  'b' => { type: '%', dest: ['con'], status: 'off' },
  'con' => { type: '&', dest: ['output'], memory: [['low'], ['low']] }
}

# # # PART ONE # # #

# méthode commune pour donner les sorties du module
def create_output(pulse, destinations)
  output = []
  destinations.each do |dest|
    output << [pulse, dest]
  end
  output
end

# méthode pour passer le broadcaster
# entrée => 'low', { dest: ['a', 'b', 'c'] }
# sortie => [['low', 'a'], ['low', 'b'], ['low', 'c']]
def broadcaster(pulse, object)
  output = []
  create_output(pulse, object[:dest])
end

# méthode pour passer un fliflop
# ATTENTION, on donne en paramètre config['a'], le statut sera changé en dehors
# entrée => 'low', { type: '%', dest: ['b'], status: 'off' }
# sortie => [['high', 'b']]
def flipflop(pulse, object)
  return if pulse == 'high'

  is_on = object[:status] == 'on'
  new_pulse = is_on ? 'low' : 'high'
  object[:status] = is_on ? 'off' : 'on'
  create_output(new_pulse, object[:dest])
end

def update_conjunctions(config)
  config.each_value do |object|
    next unless object[:type] == '&'

    object[:memory].delete_at(0)
    object[:memory] << []
  end
end

# méthode pour passer un conjunction
# entrée => 'high', { type: '&', dest: ['a'], memory: [['low'], []] }
# sortie => [['low', 'a']]
def conjunction(pulse, object)
  puts object.to_s
  all_high_pulses = !object[:memory][0].include?('low')
  puts "all high? => #{all_high_pulses}"
  new_pulse = all_high_pulses ? 'low' : 'high'
  puts new_pulse
  object[:memory][1] << pulse
  puts object.to_s
  create_output(new_pulse, object[:dest])
end
# update_conjunctions(test2_config)
# update_conjunctions(test2_config)
# puts conjunction('high', test2_config['inv']).to_s

# méthode pour appuyer sur le bouton
# entrée => config
# sortie => config
def push_button(config)
  update_conjunctions(config)
  outputs = broadcaster('low', config['broadcaster'])
  until outputs.empty?
    puts outputs.to_s
    new_outputs = []
    outputs.each do |output|
      module_type = config[output[1]][:type]
      if module_type == '%'
        fliflop_output = flipflop(output[0], config[output[1]])
        new_outputs += fliflop_output if fliflop_output
      elsif module_type == '&'
        new_outputs += conjunction(output[0], config[output[1]])
      end
    end
    update_conjunctions(config)
    outputs = new_outputs
  end
end
push_button(test2_config)

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

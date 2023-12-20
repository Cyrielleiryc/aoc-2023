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
  'inv' => { type: '&', dest: ['b'], memory: [] },
  'b' => { type: '%', dest: ['con'], status: 'off' },
  'con' => { type: '&', dest: ['output'], memory: [] }
}

# bc => low => a (off>on) => high => inv (H) => low => b (off>on) => high => con (H, H) => low => output
#                            high => con (H) => low => output
# bc => low => a (on>off) => low => inv (H | L) => high => b
#                            low => con (H, H | L) => high => output
# bc => low => a (off>on) => high => inv (H | L | H) => low => b (on>off) => low => con (H, H | L | H, L) => high => output
#                            high => con (H, H | L | H) => low => output
# bc => low => a (on>off) => low => inv (H | L | H | L ) => high => b
#                            low => con (H, H | L | H, L | L ) => high => output

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

# méthode pour passer un conjunction
# entrée => 'high', { type: '&', dest: ['a'], memory: [['low'], []] }
# sortie => [['low', 'a']]
def conjunction(pulse, object)
  object[:memory] << pulse
  all_high_pulses = !object[:memory].include?('low')
  new_pulse = all_high_pulses ? 'low' : 'high'
  create_output(new_pulse, object[:dest])
end

def update_conjunctions(config)
  config.each_value do |object|
    next unless object[:type] == '&'

    # object[:memory].delete_at(0)
    # object[:memory] << []
    object[:memory] = []
  end
end

def how_many(filter, outputs)
  outputs.select { |output| output[0] == filter }.length
end

# méthode pour appuyer sur le bouton
def push_button(config)
  # puts "THE BUTTON IS PUSHED AND SENDS A LOW PULSE"
  outputs = broadcaster('low', config['broadcaster'])
  # puts outputs.to_s
  lows = how_many('low', outputs) + 1
  highs = how_many('high', outputs)
  until outputs.empty?
    # puts "##################################"
    # puts config.to_s
    # puts "//////////////////////////////////"
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
    lows += how_many('low', new_outputs)
    highs += how_many('high', new_outputs)
    # puts new_outputs.to_s
    outputs = new_outputs.reject { |output| output[1] == 'output' }
  end
  update_conjunctions(config)
  { lows: lows, highs: highs }
end
# puts push_button(test2_config).to_s
# puts push_button(test2_config).to_s

def answer1(config, number)
  lows = 0
  highs = 0
  # config.each do |key, value|
  #   puts "#{key} => #{value.to_s}"
  # end
  number.times do
    button_pushed = push_button(config)
    lows += button_pushed[:lows]
    highs += button_pushed[:highs]
    # puts "##################################"
    # config.each do |key, value|
    #   puts "#{key} => #{value.to_s}"
    # end
  end
  lows * highs
end
# puts answer1(test2_config, 2)

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

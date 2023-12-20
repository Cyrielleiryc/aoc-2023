# # # DATA # # #

config = {}
puts "Entrez les lignes (tapez 'fin' pour terminer la saisie) :"
input = gets.chomp

while input.downcase != 'fin'
  pieces = input.split(' -> ')
  destinations = pieces[1].split(',').map(&:strip)
  if pieces[0] == 'broadcaster'
    config['broadcaster'] = { type: 'broadcaster', dest: destinations }
  elsif pieces[0][0] == '%'
    config[pieces[0][1..]] = { type: '%', dest: destinations, status: 'off' }
  elsif pieces[0][0] == '&'
    config[pieces[0][1..]] = { type: '&', dest: destinations, state: {} }
  end
  input = gets.chomp
end

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
  'inv' => { type: '&', dest: ['a'], state: {} }
}

test2_config = {
  'broadcaster' => { type: 'broadcaster', dest: ['a'] },
  'a' => { type: '%', dest: ['inv', 'con'], status: 'off' },
  'inv' => { type: '&', dest: ['b'], state: {} },
  'b' => { type: '%', dest: ['con'], status: 'off' },
  'con' => { type: '&', dest: ['output'], state: {} }
}

# bc => low => a (off>on) => high => inv (H) => low => b (off>on) => high => con (H, H) => low => output
#                            high => con (H, L) => high => output
# bc => low => a (on>off) => low => inv (L) => high => b
#                            low => con (L, L) => high => output
# bc => low => a (off>on) => high => inv (H) => low => b (on>off) => low => con (L, L) => high => output
#                            high => con (L, L) => low => output
# bc => low => a (on>off) => low => inv (L) => high => b
#                            low => con (L, L) => high => output

# # # PART ONE # # #

# méthode pour préparer les clés du state des conjunction modules
def create_keys(config)
  conjs = []
  config.each do |name, object|
    next unless object[:type] == '&'

    conjs << name
  end
  conjs.each do |conj|
    inputs = []
    config.each do |name, object|
      inputs << name if object[:dest].include?(conj)
    end
    inputs.each do |input|
      config[conj][:state][input] = 'low'
    end
  end
end

# méthode commune pour donner les sorties du module
def create_output(pulse, destinations, name)
  output = []
  destinations.each do |dest|
    output << [pulse, dest, name]
  end
  output
end

# méthode pour passer le broadcaster
def broadcaster(pulse, object, name)
  create_output(pulse, object[:dest], name)
end

# méthode pour passer un fliflop
def flipflop(pulse, object, name)
  return if pulse == 'high'

  is_on = object[:status] == 'on'
  new_pulse = is_on ? 'low' : 'high'
  object[:status] = is_on ? 'off' : 'on'
  create_output(new_pulse, object[:dest], name)
end

# méthode pour passer un conjunction
def conjunction(pulse, object, name, origin)
  object[:state][origin] = pulse
  all_highs = !object[:state].values.include?('low')
  new_pulse = all_highs ? 'low' : 'high'
  create_output(new_pulse, object[:dest], name)
end

def how_many(filter, outputs)
  outputs.select { |output| output[0] == filter }.length
end

def check_for_inexistant_modules(outputs, names_list)
  outputs.map do |output|
    names_list.include?(output[1]) ? output : [output[0], 'output', output[2]]
  end
end

# méthode pour appuyer sur le bouton
def push_button(config, names_list)
  outputs = broadcaster('low', config['broadcaster'], 'broadcaster')
  lows = how_many('low', outputs) + 1
  highs = how_many('high', outputs)
  until outputs.empty?
    new_outputs = []
    outputs.each do |output|
      module_type = config[output[1]][:type]
      if module_type == '%'
        fliflop_output = flipflop(output[0], config[output[1]], output[1])
        new_outputs += fliflop_output if fliflop_output
      elsif module_type == '&'
        new_outputs += conjunction(output[0], config[output[1]], output[1], output[2])
      end
    end
    lows += how_many('low', new_outputs)
    highs += how_many('high', new_outputs)
    new_outputs = check_for_inexistant_modules(new_outputs, names_list)
    outputs = new_outputs.reject { |output| output[1] == 'output' }
  end
  { lows: lows, highs: highs }
end

def answer1(config, number)
  create_keys(config)
  names_list = config.keys
  lows = 0
  highs = 0
  number.times do
    button_pushed = push_button(config, names_list)
    lows += button_pushed[:lows]
    highs += button_pushed[:highs]
  end
  lows * highs
end

# # # PART TWO # # #

# # # ANSWERS # # #

puts '-----------'
puts 'Réponse de la partie 1 :'
puts answer1(config, 1000)
puts '-----------'

# puts 'Réponse de la partie 2 :'
# puts '-----------'

# méthode pour
# entrée =>
# sortie =>

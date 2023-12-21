require_relative '20_data'

# # # DATA # # #

config = {}
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
#     config[pieces[0][1..]] = { type: '&', dest: destinations, state: {} }
#   end
#   input = gets.chomp
# end

@data.each do |line|
  pieces = line.split(' -> ')
  destinations = pieces[1].split(',').map(&:strip)
  if pieces[0] == 'broadcaster'
    config['broadcaster'] = { type: 'broadcaster', dest: destinations }
  elsif pieces[0][0] == '%'
    config[pieces[0][1..]] = { type: '%', dest: destinations, status: 'off' }
  elsif pieces[0][0] == '&'
    config[pieces[0][1..]] = { type: '&', dest: destinations, state: {} }
  end
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
create_keys(config)

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

first_outputs = [
  ['low', 'np', 'broadcaster'],
  ['low', 'mg', 'broadcaster'],
  ['low', 'vd', 'broadcaster'],
  ['low', 'xr', 'broadcaster']
]

def check_for_rx(outputs)
  new_outputs = []
  outputs.each do |output|
    if output[1] == 'rx' && output[0] == 'low'
      return 'stop'
    elsif output[1] != 'rx' && output[1] != 'output'
      new_outputs << output
    end
  end
  new_outputs
end

# méthode pour appuyer sur le bouton et observer un côté de la boucle
def push_button2(config, index)
  outputs = broadcaster('low', config['broadcaster'], 'broadcaster')
  # outputs[0] = ['low', 'np', 'broadcaster']
  outputs = [outputs[index]]
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
    outputs = check_for_rx(new_outputs)
    return 'stop' if outputs == 'stop'
  end
  config
end
5000.times do
  result = push_button2(config, 0)
  puts result.keys.to_s || result
end

# # # ANSWERS # # #

# puts '-----------'
# puts 'Réponse de la partie 1 :'
# puts answer1(config, 1)
# puts '-----------'

# puts 'Réponse de la partie 2 :'
# puts '-----------'

# méthode pour
# entrée =>
# sortie =>

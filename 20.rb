require_relative '20_data'

# # # DATA # # #

config = {}

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
# create_keys(config)

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

def update_rm_inputs(rm_inputs, outputs)
  outputs.each do |output|
    next unless output[1] == 'rm'

    rm_inputs[output[2]] = 'high' if output[0] == 'high'
  end
end

# méthode pour appuyer sur le bouton
def push_button(config, names_list, rm_inputs)
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
    update_rm_inputs(rm_inputs, new_outputs)
    new_outputs = check_for_inexistant_modules(new_outputs, names_list)
    outputs = new_outputs.reject { |output| output[1] == 'output' }
  end
  { lows: lows, highs: highs, rm: rm_inputs }
end

def answer1(config, number)
  create_keys(config)
  names_list = config.keys
  lows = 0
  highs = 0
  rm_inputs = { 'dh' => 'low', 'qd' => 'low', 'bb' => 'low', 'dp' => 'low' }
  number.times do
    button_pushed = push_button(config, names_list, rm_inputs)
    lows += button_pushed[:lows]
    highs += button_pushed[:highs]
  end
  puts rm_inputs.to_s
  lows * highs
end

# # # PART TWO # # #

def answer2(config)
  create_keys(config)
  names_list = config.keys
  rm_inputs = { 'dh' => 'low', 'qd' => 'low', 'bb' => 'low', 'dp' => 'low' }
  i = 0
  until rm_inputs['dp'] == 'high'
    push_button(config, names_list, rm_inputs)
    i += 1
  end
  i
end

# # # ANSWERS # # #

puts '-----------'
puts 'Réponse de la partie 1 :'
puts answer1(config, 2000)
puts '-----------'

puts 'Réponse de la partie 2 :'
puts answer2(config)
# dh = 3877
# qd = 4001
# bb = 3907
# dp = 4027
# lcm with the 4 numbers above
puts '-----------'

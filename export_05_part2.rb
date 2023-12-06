# # # PART TWO # # #

# méthode pour récupérer les seeds de départ
# entrée => "seeds: 79 14 55 13"
# sortie => ['79', '14', '55', '13']
def get_seeds(seeds_input)
  seeds_input.slice(7, seeds_input.length - 1).split(' ').map(&:to_i)
end

# méthode pour créer les ranges
# entrée => ["seed-to-soil map:", "50 98 2", "52 50 48"]
# sortie => { 50 => 98...100, 52 => 50...98 }
def ranges(paragraph)
  ranges = {}
  (1..paragraph.length - 1).to_a.each do |i|
    numbers = paragraph[i].split(' ')
    range_start = numbers[1].to_i
    range_end = range_start + numbers[2].to_i
    ranges[numbers[0].to_i] = range_start...range_end
  end
  ranges
end

# méthode pour récupérer les seeds dans les range dans l'ordre
# entrée => "seeds: 79 14 55 13"
# sortie => [55...68, 79...93]
def get_seed_ranges(seeds_input)
  seeds_in_array = get_seeds(seeds_input).map(&:to_i)
  pairs = seeds_in_array.each_slice(2).to_a
  ranges = []
  pairs.each do |pair|
    range_start = pair[0]
    range_end = range_start + pair[1]
    ranges << (range_start...range_end)
  end
  ranges.sort_by(&:first)
end

# méthode pour dire si la range est inclue ou non dans les propositions
# entrée => 79...93, { 50 => 98...100, 52 => 50...98 }
# sortie => true
def range_included?(one_seed, dico_range)
  output = 0
  dico_range.each_value do |d_range|
    output += 1 if d_range.cover?(one_seed.first) || d_range.cover?(one_seed.last)
  end
  !output.zero?
end

def create_new_seed(one_seed, key, first)
  delta = key - first
  one_seed.first + delta...one_seed.last + delta
end

# méthode pour transformer une range de seed à travers le dico
# entrée => 79...93, { 50 => 98...100, 52 => 50...98 }
# sortie => 81...95
# entrée => 45...53, { 50 => 98...100, 52 => 50...98 }
# sortie => [45...50, 52...55]
def handle_translation(one_seed, dico_range)
  dico_range.each do |key, value|
    return create_new_seed(one_seed, key, value.first) if value.cover?(one_seed)
  end
  sorted_dico_range = dico_range.values.sort_by(&:first)
  working_seed = []
  working_range = one_seed.dup
  if one_seed.first < sorted_dico_range[0].first
    working_seed << (one_seed.first...sorted_dico_range[0].first)
    working_range = sorted_dico_range[0].first...one_seed.last
  end
  if one_seed.last > sorted_dico_range[-1].last
    working_seed << (sorted_dico_range[-1].last...one_seed.last)
    working_range = working_range.first...sorted_dico_range[-1].last
  end
  sorted_dico_range.each do |r|
    key = dico_range.key(r)
    next unless r.cover?(working_range.first)

    if r.cover?(working_range.last)
      working_seed << create_new_seed(working_range, key, r.first)
    else
      working_seed << create_new_seed((working_range.first...r.last), key, r.first)
      working_range = r.last...working_range.last
    end
  end
  working_seed
end

# méthode pour faire passer toutes les ranges des seeds à travers une partie de l'almanace
# entrée => [79...93, 55...68], { 50 => 98...100, 52 => 50...98 }
# sortie => [81...95, 57...70]
def new_ranges(seeds, dico_range)
  new_ranges = []
  seeds.each do |seed|
    if range_included?(seed, dico_range)
      new_ranges << handle_translation(seed, dico_range)
    else
      new_ranges << seed
    end
  end
  new_ranges.flatten
end

def sort_and_collapse(ranges)
  sorted_ranges = ranges.sort_by(&:first)
  merged_ranges = [sorted_ranges.first]
  sorted_ranges[1..].each do |current_range|
    last_merged_range = merged_ranges.last
    if current_range.first <= last_merged_range.last
      new_range = last_merged_range.first...[last_merged_range.last, current_range.last].max
      merged_ranges[-1] = new_range
    else
      merged_ranges << current_range
    end
  end
  merged_ranges
end

# méthode pour trouver la plus petite localisation
# entrée => [81...95, 57...70]
# sortie => 57
def find_lowest_location(ranges)
  mins = []
  ranges.each { |r| mins << r.first }
  mins.min
end

# # # ANSWERS # # #

# getting the data from the terminal
almanac = []
puts "Entrez les lignes (tapez 'fin' pour terminer la saisie) :"
seeds_input = gets.chomp
gets.chomp
input = gets.chomp

while input.downcase != 'fin'
  group = []
  while input != ''
    group << input
    input = gets.chomp
  end
  almanac << group
  input = gets.chomp
end

puts 'Réponse de la partie 2 :'
all_seeds = get_seed_ranges(seeds_input)
almanac_ranges = almanac.map { |paragraph| ranges(paragraph) }
working_seed = all_seeds.dup
almanac_ranges.each do |dico_range|
  new_ranges = new_ranges(working_seed, dico_range)
  working_seed = sort_and_collapse(new_ranges)
end
puts find_lowest_location(working_seed)

# frozen_string_literal: true

# # # PART ONE # # #

# méthode pour récupérer les seeds de départ
# entrée => "seeds: 79 14 55 13"
# sortie => ['79', '14', '55', '13']
def get_seeds(seeds_input)
  seeds_input.slice(7, seeds_input.length - 1).split(' ').map(&:to_i)
end

# méthode pour trouver le plus petit source range start
# entrée => ["seed-to-soil map:", "50 98 2", "52 50 48"]
# sortie => 50
# def find_lowest_range_start(paragraph)
#   range_starts = []
#   (1..paragraph.length - 1).to_a.each do |i|
#     numbers = paragraph[i].split(' ')
#     range_starts << numbers[1].to_i
#   end
#   range_starts.min
# end

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

# méthode pour trouver le nombre associé
# entrée => 79, { 50 => 98...100, 52 => 50...98 }
# sortie => 81
def find_associate_number(start_number, range_of_paragraph)
  range_of_paragraph.each do |d_r_s, range|
    return (start_number - range.first + d_r_s) if range.include?(start_number)
  end
  start_number
end

# def find_highest_source(ranges)
#   high_numbers = []
#   ranges.each_value { |range| high_numbers << range.last }
#   high_numbers.max
# end

# # entrée => { 50 => 98...100, 52 => 50...98 }
# # sortie => { 0 => 0, 1 => 1, ..., 50 => 52, 51 => 53, ..., 97 => 99, 98 => 50, ... }
# def ranges2(ranges)
#   dico = {}
#   (0...find_highest_source(ranges)).each do |i|
#     dico[i] = find_associate_number(i, ranges)
#   end
#   dico
# end

def find_all_locations(seeds, almanac)
  locations = seeds.dup
  ranges = almanac.map { |paragraph| ranges(paragraph) }
  ranges.each do |range|
    locations.map! do |seed|
      find_associate_number(seed, range)
    end
  end
  locations
end

# # # PART TWO # # #

# méthode pour récupérer les seeds dans les range
# entrée => "seeds: 79 14 55 13"
# sortie => [79...93, 55...68]
def get_seed_ranges(seeds_input)
  seeds_in_array = get_seeds(seeds_input).map(&:to_i)
  pairs = seeds_in_array.each_slice(2).to_a
  ranges = []
  pairs.each do |pair|
    range_start = pair[0]
    range_end = range_start + pair[1]
    ranges << (range_start...range_end)
  end
  ranges
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
    next unless r.include?(working_range.first)

    if r.include?(working_range.last)
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

puts '-----------'
# puts 'Réponse de la partie 1 :'
# seeds = get_seeds(seeds_input)
# puts find_all_locations(seeds, almanac).min
# puts '-----------'

puts 'Réponse de la partie 2 :'
all_seeds = get_seed_ranges(seeds_input)
almanac_ranges = almanac.map { |paragraph| ranges(paragraph) }
working_seed = all_seeds.dup
almanac_ranges.each do |dico_range|
  working_seed = new_ranges(working_seed, dico_range)
end
puts find_lowest_location(working_seed)
puts '-----------'

# seeds_input = "seeds: 79 14 55 13"
# almanac = [
#   ["seed-to-soil map:", "50 98 2", "52 50 48"],
#   ["soil-to-fertilizer map:", "0 15 37", "37 52 2", "39 0 15"],
#   ["fertilizer-to-water map:", "49 53 8", "0 11 42", "42 0 7", "57 7 4"],
#   ["water-to-light map:", "88 18 7", "18 25 70"],
#   ["light-to-temperature map:", "45 77 23", "81 45 19", "68 64 13"],
#   ["temperature-to-humidity map:", "0 69 1", "1 0 69"],
#   ["humidity-to-location map:", "60 56 37", "56 93 4"]
# ]

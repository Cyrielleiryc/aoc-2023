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
def find_lowest_range_start(paragraph)
  range_starts = []
  (1..paragraph.length - 1).to_a.each do |i|
    numbers = paragraph[i].split(' ')
    range_starts << numbers[1].to_i
  end
  range_starts.min
end

# méthode pour créer les ranges
# entrée => ["seed-to-soil map:", "50 98 2", "52 50 48"]
# sortie => { 50 => 98...100, 52 => 50...98 }
def ranges(paragraph)
  ranges = {}
  # lowest_range_start = find_lowest_range_start(paragraph)
  # ranges[0] = 0...lowest_range_start unless lowest_range_start.zero?
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

def find_highest_source(ranges)
  high_numbers = []
  ranges.each_value { |range| high_numbers << range.last }
  high_numbers.max
end

# entrée => { 50 => 98...100, 52 => 50...98 }
# sortie => { 0 => 0, 1 => 1, ..., 50 => 52, 51 => 53, ..., 97 => 99, 98 => 50, ... }
def ranges2(ranges)
  dico = {}
  (0...find_highest_source(ranges)).each do |i|
    dico[i] = find_associate_number(i, ranges)
  end
  dico
end

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
# sortie => [79, 80, ..., 92, 55, 56, ..., 67]
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
puts 'Réponse de la partie 1 :'
seeds = get_seeds(seeds_input)
puts find_all_locations(seeds, almanac).min
puts '-----------'

puts 'Réponse de la partie 2 :'
all_seeds = get_seed_ranges(seeds_input)
puts find_all_locations(all_seeds, almanac).min
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

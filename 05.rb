# # # PART ONE # # #

# méthode pour récupérer les seeds de départ
# entrée => "seeds: 79 14 55 13"
# sortie => ['79', '14', '55', '13']
def get_seeds(seeds)
  seeds.slice!(0, 7)
  seeds.split(' ')
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
# sortie => { 0 => 0...50, 50 => 98...100, 52 => 50...98 }
def ranges(paragraph)
  ranges = {}
  lowest_range_start = find_lowest_range_start(paragraph)
  ranges[0] = 0...lowest_range_start unless lowest_range_start.zero?
  (1..paragraph.length - 1).to_a.each do |i|
    numbers = paragraph[i].split(' ')
    range_start = numbers[1].to_i
    range_end = range_start + numbers[2].to_i
    ranges[numbers[0].to_i] = range_start...range_end
  end
  ranges
end

# méthode pour trouver le nombre associé
# entrée => 79, ["seed-to-soil map:", "50 98 2", "52 50 48"]
# sortie => 81
def find_associate_number(start_number, paragraph)
  ranges = ranges(paragraph)
  ranges.each do |d_r_s, range|
    if range.include?(start_number)
      return (start_number - range.first + d_r_s)
    end
  end
  start_number
end

def find_all_locations(seeds, almanac)
  locations = []
  seeds.each do |seed|
    start_number = seed.to_i
    almanac.each do |paragraph|
      start_number = find_associate_number(start_number, paragraph)
    end
    locations << start_number
  end
  locations
end

# # # ANSWERS # # #

# getting the data from the terminal
almanac = []
puts "Entrez les lignes (tapez 'fin' pour terminer la saisie) :"
seeds_input = gets.chomp
space = gets.chomp
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

puts 'Réponse de la partie 1 :'
seeds = get_seeds(seeds_input)
puts find_all_locations(seeds, almanac).min
puts '-----------'


# seeds = "seeds: 79 14 55 13"
# almanac = [
#   ["seed-to-soil map:", "50 98 2", "52 50 48"],
#   ["soil-to-fertilizer map:", "0 15 37", "37 52 2", "39 0 15"],
#   ["fertilizer-to-water map:", "49 53 8", "0 11 42", "42 0 7", "57 7 4"],
#   ["water-to-light map:", "88 18 7", "18 25 70"],
#   ["light-to-temperature map:", "45 77 23", "81 45 19", "68 64 13"],
#   ["temperature-to-humidity map:", "0 69 1", "1 0 69"],
#   ["humidity-to-location map:", "60 56 37", "56 93 4"]
# ]












# méthode pour
# entrée =>
# sortie =>

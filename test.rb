one_seed = 45...53
values = [98...100, 50...98, 47...50]

# Initialisation du tableau résultant
cut_ranges = []

# Ajout de la première partie de one_seed
cut_ranges << (one_seed.first...values[0].first) if one_seed.first < values[0].first

# Ajout des plages du tableau values
values.each_cons(2) do |range1, range2|
  cut_ranges << (range1.last...range2.first) if range1.last < range2.first
end

# Vérification pour la dernière plage de values et la fin de one_seed
cut_ranges << (values[-1].last...one_seed.last) if values[-1].last < one_seed.last

puts cut_ranges.inspect

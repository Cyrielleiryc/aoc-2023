# 467..114..
# ...*......
# ..35..633.
# ......#...
# 617*......
# .....+.58.
# ..592.....
# ......755.
# ...$.*....
# .664.598..
# not adjacent => 114 et 58
# somme des autres => 4361

SYMBOLS = %w[* # + $ @ / % = - &]

# # # PART ONE # # #
# sur chaque ligne, on cherche les nombres
# on récupère les indices de chaque chiffre
# on regarde la ligne d'avant (indices + celui d'avant et celui d'après )
# on regarde la ligne d'après
# on regarde la ligne actuelle
# nombre à conserver ou pas ?

# méthode pour trouver les nombres sur une ligne et les indices des chiffres
# entrée = "..35..633."
# sortie = {"35"=> [2, 3], "633"=> [6, 7, 8]}
def find_numbers(line)
  numbers = line.split(/\D/).reject{ |n| n == "" }
  answer = {}
  numbers.each do |number|
    index_start = line.index(number)
    index_end = index_start + number.length - 1
    answer[number] = (index_start..index_end).to_a
  end
  answer
end

# méthode pour donner les indices à étudier (en fonction de la longueur de la ligne)
# entrée = [2, 3]       || [0, 1]     || [8, 9] , 10
# sortie = [1, 2, 3, 4] || [0, 1, 2]  || [7, 8, 9]
def find_indexes_to_study(indexes, length)
  max_index = length - 1
  indexes << indexes.last + 1 unless indexes.last == max_index
  indexes.unshift(indexes[0] - 1) unless indexes[0].zero?
  indexes
end

# méthode pour voir s'il y a un symbole aux indices donnés
# entrées = "...*......", [2, 3]
# sortie = true
def adjacent_symbol?(line, indexes)
  indexes_to_check = find_indexes_to_study(indexes, line.length)
  count = 0
  indexes_to_check.each do |index|
    count += 1 if SYMBOLS.include?(line[index])
  end
  !count.zero?
end


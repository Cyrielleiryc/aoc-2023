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

SYMBOLS = %w[*#+$@/%=-&]

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

ranges = [15...30, 25...59, 98...105]

# Tri des intervalles par leur début
sorted_ranges = ranges.sort_by(&:first)

merged_ranges = [sorted_ranges.first]

sorted_ranges[1..-1].each do |current_range|
  last_merged_range = merged_ranges.last

  if current_range.first <= last_merged_range.last
    new_range = last_merged_range.first...[last_merged_range.last, current_range.last].max
    merged_ranges[-1] = new_range
  else
    merged_ranges << current_range
  end
end

merged_ranges

load "WordSearch.rb"

print "Input the file path contianing the puzzle: "
puts
puzzle_file = gets.chomp
print "Input the file path contianing the word list: "
word_list_file= gets.chomp

ws = WordSearch.new(puzzle_file, word_list_file)

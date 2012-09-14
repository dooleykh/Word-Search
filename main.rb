load "WordSearch.rb"

print "Input the file path contianing the puzzle: "
puts
#puzzle_file = gets.chomp
puzzle_file = "./Testing/puzzle.txt"
print "Input the file path contianing the word list: "
#word_list_file= gets.chomp
word_list_file = "./Testing/wordlist.txt"
ws = WordSearch.new(puzzle_file, word_list_file)

ws.search
ws.print_puzzle

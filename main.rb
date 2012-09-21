load "WordSearch.rb"

verbose = false
if ARGF.argv.size >= 2
  puzzle_file = ARGF.argv[0]
  word_list_file = ARGF.argv[1]
  if ARGF.argv.include?("-v")
    verbose = true
  end
else
  print "Input the file path contianing the puzzle: "
  puzzle_file = gets.chomp
  #  puzzle_file = "./Testing/puzzle.txt"
  print "Input the file path contianing the word list: "
  word_list_file= gets.chomp
  #  word_list_file = "./Testing/wordlist.txt"
end

if !(File.file?(puzzle_file) && File.file?(word_list_file))
  raise "One or both files can't be read"
end

ws = WordSearch.new(puzzle_file, word_list_file, verbose)
ws.search
ws.print_puzzle

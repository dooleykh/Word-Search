print "Input the file path contianing the puzzle: "
puts
#PUZZLE_FILE = gets.chomp
PUZZLE_FILE = "./Testing/puzzle.txt"

puzzle = []
letters = {}
line = ""
c = ""
length= 0 
n = 0

f = File.open(PUZZLE_FILE);
while !(f.eof?)
  c = f.getc.upcase
  if c == "\n"
    if length == 0
      length = n
    else
      if length != n
        raise RuntimeError, "Puzzle contains lines of differing lengths"
      end
    end
    puzzle << line
    line = ""
    n = 0
  else
    n = n + 1
    line << c
    if letters.has_key?(c)
      letters[c] = letters[c] + 1
    else
      letters[c] = 1
    end
  end
end
f.close

letters.each {|key, value| puts "#{key} : #{value}"}
print "Input the file path contianing the word list: "
#WORDS_FILE = gets.chomp
WORDS_FILE = "./Testing/wordlist.txt"

words = File.readlines(WORDS_FILE)
words.map! do |word|
  word.chomp.upcase.gsub(' ', '')
end

puts


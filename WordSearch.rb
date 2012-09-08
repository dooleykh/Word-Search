class WordSearch
  attr_reader :puzzle, :letter_positions, :word_list

  def initialize(puzzle_file, word_list_file)
    @puzzle = []
    @letter_frequency = {}
    @letter_positions = {}
    @line_length = 0
    @lines = 0
    load_puzzle(puzzle_file)
    load_word_list(word_list_file)
  end
  
  def load_puzzle(puzzle_file)
    col = 0
    row = 0
    length = 0
    char = ""
    line = ""
    
    f = File.open(puzzle_file);
    while !(f.eof?)
      char = f.getc.upcase
      if char == "\n"
        if length == 0
          length = col
        else
          if length != col
            raise "Puzzle contains lines of differing lengths"
          end
        end
        @puzzle << line
        line = ""
        col = 0
        row = row + 1
      else
        if @letter_frequency[char]
          @letter_frequency[char] = @letter_frequency[char] + 1
          @letter_positions[char] = @letter_positions[char] << [row, col]
        else
          @letter_frequency[char] = 1
          @letter_positions[char] = [[row, col]]
        end
        col = col + 1
        line << char
      end
    end
    f.close
    @line_length = length - 1
    @lines = puzzle.size - 1
  end

  def load_word_list(word_list_file)
    @word_list = File.readlines(word_list_file)
    @word_list.map! do |word|
      word.chomp.upcase.gsub(' ', '')
    end
  end
end

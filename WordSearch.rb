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

  def check_legal_position(row, col)
    return  (row >= 0 and row <= @lines and col >= 0 and col <= @line_length)
  end
  
  def load_puzzle(puzzle_file)
    col = 0
    row = 0
    length = 0
    char = ""
    line = ""
    
    f = File.open(puzzle_file);
    while not f.eof?
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
        row += 1
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

  def load_word_list (word_list_file)
    @word_list = File.readlines(word_list_file)
    @word_list.map! {|word| word.chomp.upcase.gsub(' ', '')}
  end
  
  def search
    @word_list.each do |word|
      char = word[0]
      word.each_char do |c|
        if i = @letter_frequency[c]
          char = (@letter_frequency[char] > i) ? char : c
        else
          puts "The puzzle does not contain #{word} (check for spelling, common symobls, etc.)"
          next
        end
      end
      
      distance_to_first = word.index char
      gen = [0, 1, 0, -1, 1, 0, -1, 0, 1, 1, -1, 1, 1, -1, -1,-1].each
      pos_list = @letter_positions[char]
      found = false
      
      pos_list.each do |pos|
        next if found
        y, x = pos
        gen.rewind
        
        [
         [y, x - distance_to_first], [y, x + distance_to_first], [y - distance_to_first, x],
         [y + distance_to_first, x], [y - distance_to_first, x - distance_to_first],
         [y + distance_to_first, x - distance_to_first],
         [y - distance_to_first, x + distance_to_first],
         [y + distance_to_first, x + distance_to_first]
        ].each_with_index do |start_pos, pos_num|
          next if found
          y_s, x_s = start_pos
          y_delta = gen.next
          x_delta = gen.next
          i = 0
          y_d, x_d = y_s, x_s
          while check_legal_position(y_d, x_d) && (@puzzle[y_d][x_d] == word[i])
            if i == (word.length - 1)
              puts "Found #{word} from (#{y_s + 1}, #{x_s+1}) to (#{y_d + 1}, #{x_d+1})"
              found = true
              break
            end
            y_d += y_delta
            x_d += x_delta
            i += 1
          end
        end  
      end
      puts "Failed to find #{word}" if not found
    end
  end

end

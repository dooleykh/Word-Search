require "colorize"

class WordSearch
  attr_reader :puzzle, :letter_positions, :word_list

  def initialize(puzzle_file, word_list_file, v)
    @puzzle = []
    @letter_frequency = Hash.new {|h, k| h[k] = 0}
    @letter_positions = Hash.new {|h, k| h[k] = []}
    @positions_in_solution = Hash.new {|h, k| h[k] = []}
    @word_list = load_word_list(word_list_file)
    @verbose = v

    load_puzzle(puzzle_file)
    @line_length = @puzzle[0].size 
    @lines = @puzzle.size - 1
  end
  
  def check_legal_position(row, col)
    return ((0..@lines).include?(row) && (0..@line_length).include?(col))
  end

  def load_puzzle(puzzle_file)
    File.readlines(puzzle_file).each_with_index do |line, y|
      line.upcase!.chomp!.each_char.to_a.each_with_index do |char, x|
        @letter_frequency[char] = @letter_frequency[char] + 1
        @letter_positions[char] = @letter_positions[char] << [y, x]
      end
      if !(@puzzle.empty?)
        if line.size != @puzzle[0].size
          raise "Puzzle contains lines of differing lengths"
        end
      end
      @puzzle << line
    end
 end
  
  def load_word_list (word_list_file)
    File.readlines(word_list_file).
      map{|word| word.chomp.upcase.gsub(' ', '')}.sort_by {|x| x.length}.reverse
  end

  def search
    @word_list.each do |word|
      not_in_puzzle = false
      char = word[0]
      word.each_char do |c|
        if 0 != @letter_frequency[c] #Default value if key (c) isn't in hash
          char = (@letter_frequency[char] > @letter_frequency[c]) ? char : c
        else
          puts "The puzzle does not contain #{word}"
          not_in_puzzle = true
          break
        end
      end
      next if not_in_puzzle
      
      d = word.index(char) #Distance from least common character to first
      gen =
        [[0, 1], [0, -1], [1, 0], [-1, 0], [1, 1], [-1, 1], [1, -1], [-1,-1]].each
      found = false
      @letter_positions[char].each do |pos|
        break if found
        y, x = pos
        gen.rewind
        [[y, x - d], [y, x + d], [y - d, x], [y + d, x], [y - d, x - d],
         [y + d, x - d], [y - d, x + d], [y + d, x + d]].each do |start_pos|
          break if found
          y_i, x_i = start_pos
          y_delta, x_delta = gen.next
          i = 0
          letter_pos = []
          while (check_legal_position(y_i, x_i) && @puzzle[y_i][x_i] == word[i])
            letter_pos << [y_i, x_i]
            if i == (word.length - 1)
              puts "#{word}: (#{y}, #{x}) to (#{y_i}, #{x_i})" if @verbose
              found = true
              letter_pos.each do |solution_pos|
                a, b = solution_pos
                @positions_in_solution[a] = @positions_in_solution[a] << b
              end
              break
            end
            y_i += y_delta
            x_i += x_delta
            i += 1
          end
        end  
      end
      puts "Failed to find #{word}" if not found
    end
  end
  
  def print_puzzle
    @puzzle.each_with_index do |line, y|
      line.each_char.to_a.each_with_index do |char, x|
        if @positions_in_solution[y]
          if @positions_in_solution[y].include?(x)
            print "#{char.colorize(:green)}  "
            next
          end
        end
        print "#{char}  "
      end
      puts
    end
    puts
  end
end

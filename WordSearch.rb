require "colorize"

class WordSearch
  attr_reader :puzzle, :letter_positions, :word_list

  def initialize(puzzle_file, word_list_file, v)
    @puzzle = []
    @letter_frequency = Hash.new {|h, k| h[k] = 0}
    @letter_positions = Hash.new {|h, k| h[k] = []}
    @pos_in_sol = Hash.new {|h, k| h[k] = []}
    @deltas = [[0, 1], [0, -1], [1, 0], [-1, 0],
               [1, 1], [-1, 1], [1, -1], [-1,-1]].each
    @verbose = v
    load_puzzle(puzzle_file)
    @length = @puzzle[0].size 
    @lines = @puzzle.size - 1

    #Sort word list by size to avoid potential substring problem
    #(Where a smaller word is a complete substring of a larger word
    #that appears before it in the puzzle)
    @word_list = File.readlines(word_list_file).
      map{|word| word.chomp.upcase.gsub(' ', '')}.
      sort_by {|word| word.length}.reverse
  end

  #Check for substring problem
  def is_unique?(letter_pos)
    unique = []
    letter_pos.each do |char|
      y, x = char
      if @pos_in_sol.has_key?(y) && @pos_in_sol[y].include?(x)
        unique << false
        next
      end
      unique << true
    end
    unique.reduce(false) {|word, char| word | char}
  end
  
  def load_puzzle(puzzle_file)
    File.readlines(puzzle_file).each_with_index do |line, y|
      x = 0
      line.upcase!.chomp!.each_char do |char|
        @letter_frequency[char] = @letter_frequency[char] + 1
        @letter_positions[char] = @letter_positions[char] << [y, x]
        x += 1
      end
      if !(@puzzle.empty?)
        if line.size != @puzzle[0].size
          raise "Puzzle contains lines of differing lengths"
        end
      end
      @puzzle << line
    end
  end

  def least_frequent(word)
    char = word[0]
    word.each_char do |c|
      if @letter_frequency.has_key?(c)
        char = (@letter_frequency[char] > @letter_frequency[c]) ? char : c
      else
        char = ''
        break
      end
    end
    char
  end

  def first_letter_pos(y, x, d)
    [[y, x - d], [y, x + d], [y - d, x], [y + d, x], [y - d, x - d],
     [y + d, x - d], [y - d, x + d], [y + d, x + d]]
  end
  
  def search
    @word_list.each do |word|
      char = least_frequent(word)
      if char == ''
        puts "#{word} is not in the puzzle"
        next
      end
      found = false
      @letter_positions[char].each do |pos_char|
        next if found
        @deltas.rewind
        pos_list = first_letter_pos(pos_char[0], pos_char[1], word.index(char))
        pos_list.each do |pos|
          break if found
          y_i, x_i = pos
          y_delta, x_delta = @deltas.next
          i = 0
          potential_sol = []
          while (0..@lines).include?(y_i) && (0..@length).include?(x_i)
            break if @puzzle[y_i][x_i] != word[i]
            potential_sol << [y_i, x_i]
            if i == (word.length - 1) && is_unique?(potential_sol)
              puts "#{word}: (#{pos[0]}, #{pos[1]}) to (#{y_i}, #{x_i})" if @verbose
              found = true
              potential_sol.each do |sol|
                a, b = sol
                @pos_in_sol[a] = @pos_in_sol[a] << b
              end
              break
            end
            y_i += y_delta
            x_i += x_delta
            i += 1
          end
        end
      end  
      puts "Failed to find #{word}" if !found
    end
  end

  def print_puzzle
    @puzzle.each_with_index do |line, y|
      x = 0
      line.each_char do |char|
        if  @pos_in_sol.has_key?(y) && @pos_in_sol[y].include?(x)
          print "#{char.colorize(:green)}  "
        else
          print "#{char}  "
        end
        x += 1
      end
      puts
    end
  end
end

require "colorize"

class WordSearch
  attr_reader :puzzle, :letter_positions, :word_list

  def initialize(p_f, w_f, v)
    @puzzle = []
    @letter_frequency = Hash.new {|h, k| h[k] = 0}
    @letter_positions = Hash.new {|h, k| h[k] = []}
    @pos_in_sol = Hash.new {|h, k| h[k] = []}
    @deltas = [[0, 1], [0, -1], [1, 0], [-1, 0],
               [1, 1], [-1, 1], [1, -1], [-1,-1]].each
    @verbose = v
    load_puzzle(p_f)
    @length = @puzzle[0].size 
    @lines = @puzzle.size - 1

    #Sort word list by size to avoid potential substring problem
    #(Where a smaller word is a complete substring of a larger word
    #that appears before it in the puzzle)
    @word_list = File.readlines(w_f).map{|a| a.chomp.upcase.gsub(' ', '')}.
      sort_by {|a| a.length}.reverse
  end

  #Check for substring problem
  def is_unique?(letter_pos)
    unique = false
    letter_pos.each do |y, x|
      unique |= !(@pos_in_sol.has_key?(y) && @pos_in_sol[y].include?(x))
    end
    unique
  end
  
  def load_puzzle(p_f)
    File.readlines(p_f).map!{|a| a.upcase.chomp}.each_with_index do |line, y|
      line.each_char.each_with_index do |char, x|
        @letter_frequency[char] = @letter_frequency[char] + 1
        @letter_positions[char] = @letter_positions[char] << [y, x]
      end
      if !(@puzzle.empty?) && line.size != @puzzle[0].size
        raise "Puzzle contains lines of differing lengths"
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
        char = nil
        break
      end
    end
    char
  end

  def first_pos(y, x, d)
    [[y, x - d], [y, x + d], [y - d, x], [y + d, x], [y - d, x - d],
     [y + d, x - d], [y - d, x + d], [y + d, x + d]]
  end
  
  def search
    @word_list.each do |word|
      if !(char = least_frequent(word))
        puts "#{word} is not in the puzzle"
        next
      end
      found = false
      @letter_positions[char].each do |y_0, x_0|
        next if found
        @deltas.rewind
        first_pos(y_0, x_0, word.index(char)).each do |y_i, x_i|
          break if found
          y_delta, x_delta = @deltas.next
          i = 0
          potential_sol = []
          while (0..@lines).include?(y_i) && (0..@length).include?(x_i)
            break if @puzzle[y_i][x_i] != word[i]
            potential_sol << [y_i, x_i]
            if i == (word.length - 1) && is_unique?(potential_sol)
              found = true
              puts "#{word}: (#{pos[0]}, #{pos[1]}) to (#{y_i}, #{x_i})" if @verbose
              potential_sol.each {|a, b| @pos_in_sol[a] = @pos_in_sol[a] << b}
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
      line.each_char.each_with_index do |char, x|
        if  @pos_in_sol.has_key?(y) && @pos_in_sol[y].include?(x)
          print "#{char.colorize(:green)}  "
        else
          print "#{char}  "
        end
      end
      puts
    end
  end
end

require 'rspec'
require_relative '../WordSearch.rb'

describe WordSearch do
  context "A puzzle" do

    it "should have the same number of lines as the file" do
      i = File.readlines('puzzle.txt').size
      ws = WordSearch.new('puzzle.txt', 'wordlist.txt')
      ws.puzzle.should have(i).elements
    end

    it "should contain only capital letters" do
      ws = WordSearch.new('puzzle.txt', 'wordlist.txt')
      ws.puzzle.should satisfy do |puzzle|
        puzzle.each do |line|
          line.upcase.should eql(line)
        end
      end
    end

    it "should not raise a Runtime error on a valid puzzle" do
      lambda{WordSearch.new('puzzle.txt', 'wordlist.txt')}.should_not raise_error
    end
    
    it "should raise a Runtime error on an invalid puzzle" do
      lambda{WordSearch.new('bad_puzzle.txt', 'wordlist.txt')}.should raise_error
    end
  end
  
  context "A word list" do

    it "should have the same number of words as the file" do
      i = File.readlines("wordlist.txt").size
      ws = WordSearch.new('puzzle.txt', 'wordlist.txt')
      ws.word_list.should have(i).elements 
    end

    it "should contain only capital letters" do
      ws = WordSearch.new('puzzle.txt', 'wordlist.txt')
      ws.word_list.should satisfy do |word_list|
        word_list.each do |word|
          word.should eql(word.upcase)
        end
      end     
    end

    it "should contain no spaces" do
      ws = WordSearch.new('puzzle.txt', 'wordlist.txt')
      ws.word_list.should satisfy do |word_list|
        word_list.each do |word|
         word.should eql(word.gsub(' ', ''))
        end
      end     
 
    end
  end
end


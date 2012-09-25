Word-Search
===========

**A Ruby script designed to solve word searches quickly and efficiently.**

If you're like me, you probably solve word searches in the same tedious manner every time:

   1. Scan the puzzle from left to right, top to bottom looking for the first letter of the word.
   2. Once you find the first letter, look around it to see if the following letter is next to it.
   3. Continue until you find the word.
   4. Continue until you've found all of the words.

Unlike us, computers, when properly leveraged, have a few advantages in solving a word search.

**Computers can note the position of every letter.**
By keeping track of every position in the puzzle a certain letter appears as it reads in the puzzle, a computer has constant time access (O(1)) to a known position in the puzzle without having to scan through the puzzle each iteration.

**Computers can keep track of how many times each letter appears in the puzzle**
Knowing how often each letter occurs in the puzzle (once again as the puzzle is read) allows the computer to be smarter about how it searches. For example, words with letters or characters that don't appear in the puzzle can be thrown out immediately, instead of wasting time iterating over the puzzle looking for words which can't exist. Primarily, though, this allows the computer to shrink its search space by looking for a word based on its least common letter, not necessarily its first.

By using the more sophisticated brute force method provided by these two concepts, Word-Search provides a solver that scales well as the puzzle grows in size and difficulty.
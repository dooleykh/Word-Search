Word-Search
===========

**A Ruby program designed to solve particularly large word searches.**

When searching for words in a word search, a common strategy is to scan the puzzle letter by letter, line by line, looking for the first letter of the word they're looking for. Once our aspiring word sleuth has located one such letter somewhere in the puzzle, he or she checks the surrounding letters, looking for the second letter in the word. If they're lucky, they find the word in its entirety and move on to the next challenge in the list. If not, off they go searching for the first letter again. Tedious, but effective nonetheless.

How, then, should a computer approach such a puzzle? Of course, it could follow the same approach as a human would, effectively applying a brute force solution to a puzzle. While this is great for small puzzles, very large puzzles (especially those with a long word list) will take a while. However, why not play to the computer's strengths? Since a computer must read in the whole puzzle before it can begin solving it (unlike a human), we should have it do something the majority of human puzzle solvers can't do:

+   Note the position of each letter for fast lookup (read the puzzle once and mark positions)
+   Search for words based on how common the letters in the word are in the puzzle

By applying these two methods, we remove the bottleneck of searching through the puzzle for every word (instead consulting a hash table of positions, keyed by letter and generated during the initial file read) and gain the potential to significantly reduce the puzzle's sample space
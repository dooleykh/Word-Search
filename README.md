Word-Search
===========

**A Ruby program designed to solve particularly large word searches.**

When searching for words in a word search, a common strategy is to scan the puzzle letter by letter, line by line, looking for the first letter of the word they're looking for. Once our aspiring word sleuth has located one such letter somewhere in the puzzle, he or she checks the surrounding letters, looking for the second letter in the word. If they're lucky, they find the word in its entirety and move on to the next challenge in the list. If not, off they go searching for the first letter again. Tedious, but effective nonetheless.

How, then, should a computer approach such a puzzle? Of course, it could follow the same approach as a human would, effectively applying a brute force solution to a puzzle. However, why not play to the computer's strengths? Since a computer must read in the whole puzzle before it can begin solving it (unlike a human), we should have it do something the majority of human puzzle solvers won't ( or can't)do:

+   Save the position of each letter for fast lookup (as opposed to reading through each line searching for a letter every time)
+   Search for words based on how common the letters in the word are in the puzzle
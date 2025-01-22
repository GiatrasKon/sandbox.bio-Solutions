#==============================================NAVIGATING FILES AND DIRECTORIES===============================================

#-------------------------------------------------Absolute vs relative paths--------------------------------------------------

# Starting from /Users/nelle/data, which of the following commands could Nelle use to navigate to her home directory, 
# which is /Users/nelle?
cd ~
cd ~/data/..
cd
cd ..

# Using the filesystem diagram below, if pwd displays /Users/thing, what will ls -F ../backup display?
original/ pnas_final/ pnas_sub/

#--------------------------------------------------ls reading comprehension---------------------------------------------------

# Using the filesystem diagram below, if pwd displays /Users/backup, and -r tells ls to display things in reverse order, 
# what command(s) will result in the following output:
# pnas_sub/ pnas_final/ original/
ls -r -F
ls -r -F /Users/backup


#==============================================WORKING WITH FILES AND DIRECTORIES=============================================

#--------------------------------------------------Moving Files to a new folder-----------------------------------------------

# After running the following commands, Jamie realizes that she put the files sucrose.dat and maltose.dat into the wrong 
# folder. The files should have been placed in the raw folder:

# ls -F
# ls -F analyzed
# cd analyzed

# Fill in the blanks to move these files to the raw/ folder (i.e. the one she forgot to put them in)
mv sucrose.dat maltose.dat ../raw/

#-------------------------------------------------------Renaming Files--------------------------------------------------------

# Suppose that you created a plain-text file in your current directory to contain a list of the statistical tests you will 
# need to do to analyze your data, and named it statstics.txt. After creating and saving this file you realize you misspelled 
# the filename! You want to correct the mistake, which of the following commands could you use to do so?
mv statstics.txt statistics.txt

#------------------------------------------------------Moving and Copying-----------------------------------------------------

# What is the output of the closing ls command in the sequence shown below?

# $ pwd
# /Users/jamie/data
# $ ls
# proteins.dat
# $ mkdir recombined
# $ mv proteins.dat recombined/
# $ cp recombined/proteins.dat ../proteins-saved.dat
# $ ls
recombined/

#------------------------------------------------List filenames matching a pattern--------------------------------------------

# When run in the alkanes directory, which ls command(s) will produce this output?
# ethane.pdb methane.pdb
ls *t??ne.pdb # tells ls to look for any file ending in t, followed by two characters, then ne.pdb


#=======================================================PIPES AND FILTERS=====================================================

#---------------------------------------------------------Appending data------------------------------------------------------

# We have already met the head command, which prints lines from the start of a file. tail is similar, but prints lines from 
# the end of a file instead. Consider the file exercise-data/animal-counts/animals.csv. After these commands, select the 
# answer that corresponds to the file animals-subset.csv:

# $ head -n 3 animals.csv > animals-subset.csv
# $ tail -n 2 animals.csv >> animals-subset.csv
The first three lines and the last two lines of `animals.csv`

#----------------------------------------------------Piping commands together-------------------------------------------------

# In our current directory, we want to find the 3 files which have the least number of lines. 
# Which command listed below would work?
wc -l * | sort -n | head -n 3

#-------------------------------------------------------Pipe construction-----------------------------------------------------

# For the file animals.csv, consider the following command:

# cut -d , -f 2 ~/tutorial/exercise-data/animal-counts/animals.csv

# The cut command is used to remove or 'cut out' certain sections of each line in the file, and cut expects the lines to be 
# separated into columns by a Tab character. A character used in this way is a called a delimiter. In the example above we use
# the -d option to specify the comma as our delimiter character. We have also used the -f option to specify that we want to 
# extract the second field (column). 
# The uniq command filters out adjacent matching lines in a file. How could you extend this pipeline (using uniq and another
# command) to find out what animals the file contains (without any duplicates in their names)? Store the result in unique.csv:
cut -d , -f 2 ~/tutorial/exercise-data/animal-counts/animals.csv | sort | uniq > unique.csv

#----------------------------------------------------------Which pipe?--------------------------------------------------------

# Consider the file exercise-data/animal-counts/animals.csv:

# 2012-11-05,deer,5
# 2012-11-05,rabbit,22
# 2012-11-05,raccoon,7
# 2012-11-06,rabbit,19
# ...

# The uniq command has a -c option which gives a count of the number of times a line occurs in its input.
# What command would you use to produce a table that shows the total count of each type of animal in the file?
cut -d , -f 2 animals.csv | sort | uniq -c

#-----------------------------------------------------Removing unneeded files-------------------------------------------------

# Suppose you want to delete your processed data files, and only keep your raw files and processing script to save storage. 
# The raw files end in .dat and the processed files end in .txt. Which of the following would remove all the processed data 
# files, and only the processed data files?
rm *.txt


#=============================================================LOOPS===========================================================

#------------------------------------------------------Write your own loop----------------------------------------------------

# Go to the folder loops:

# cd ~/tutorial/loops/

# How would you write a loop that creates 5 files: 1.txt, 2.txt, 3.txt, 4.txt, 5.txt? The files can be empty.
for i in 1 2 3 4 5; do touch $i.txt; done

#-----------------------------------------------------Limiting sets of files--------------------------------------------------

# What would be the output of running the following loop in the exercise-data/alkanes directory?

# for filename in c*
# do
#     ls $filename
# done
Only cubane.pdb is listed.

# How would the output differ from using this command instead (*c* instead of c*):

# for filename in *c*
# do
#     ls $filename
# done
The files cubane.pdb and octane.pdb will be listed.

#---------------------------------------------------Saving to a file in a loop------------------------------------------------

# In the exercise-data/alkanes directory, what is the effect of this loop?

# for alkanes in *.pdb
# do
#     echo $alkanes
#     cat $alkanes > alkanes.pdb
# done
Prints cubane.pdb, ethane.pdb, methane.pdb, octane.pdb, pentane.pdb and propane.pdb, 
and the text from propane.pdb will be saved to a file called alkanes.pdb.

# Also in the exercise-data/alkanes directory, what would be the output of the following loop?

# for datafile in *.pdb
# do
#     cat $datafile >> all.pdb
# done
All of the text from cubane.pdb, ethane.pdb, methane.pdb, octane.pdb, pentane.pdb and propane.pdb would be concatenated and 
saved to a file called all.pdb.

#=========================================================SHELL SCRIPTS=======================================================

#------------------------------------------------------List unique species----------------------------------------------------

# Go to the folder exercise-data/:

# cd ~/tutorial/exercise-data/

# Leah has several hundred data files, each of which is formatted like this:

# 2013-11-05,deer,5
# 2013-11-05,rabbit,22
# 2013-11-05,raccoon,7
# 2013-11-06,rabbit,19
# 2013-11-06,deer,2
# 2013-11-06,fox,1
# 2013-11-07,rabbit,18
# 2013-11-07,bear,1

# An example of this type of file is given in animal-counts/animals.csv.

# We can use the command cut -d , -f 2 animal-counts/animals.csv | sort | uniq to produce the unique species in animals.csv. 
# In order to avoid having to type out this series of commands every time, a scientist may choose to write a shell script 
# instead. Write a shell script called species.sh that takes any number of filenames as command-line arguments and uses a 
# variation of the above command to print a list of the unique species appearing in each of those files separately.

nano species.sh # creates a new file called species.sh

#!/bin/bash
for filename in "$@"
do
    cut -d , -f 2 $filename | sort | uniq >> unique.txt # >> appends to the file
done

chmod +x species.sh # makes the file executable

./species.sh animal-counts/animals.csv # runs the script

#---------------------------------------------------Variables in shell scripts------------------------------------------------

# Go to the folder exercise-data/alkanes/:

# cd ~/tutorial/exercise-data/alkanes/

# In the alkanes directory, imagine you have a shell script called script.sh containing the following commands:

# head -n $2 $1
# tail -n $3 $1

# While you are in the alkanes directory, you type the following command:

# bash script.sh '*.pdb' 1 1

# Which of the following outputs would you expect to see?
The first and the last line of each file ending in .pdb in the alkanes directory. # head -n 1 *.pdb, tail -n 1 *.pdb

#----------------------------------------------Longest file with a given extension--------------------------------------------

# Go to the folder exercise-data/:

# cd ~/tutorial/exercise-data/

# Write a shell script called longest.sh that takes the name of a directory and a filename extension as its arguments, and 
# prints out the name of the file with the most lines in that directory with that extension. For example:

# bash longest.sh alkanes pdb

# would print the name of the .pdb file in alkanes/ that has the most lines.

# Feel free to test your script on another directory e.g.

# bash longest.sh writing txt

nano longest.sh # creates a new file called longest.sh

#!/usr/bin/env bash

dir="$1"
ext="$2"

longest_file=$(
  for f in "$dir"*."$ext"
  do
    count=$(wc -l < "$f")
    echo "$count $f"
  done | sort -nr | head -n1 | awk '{print $2}'
)

echo "$longest_file"


chmod +x longest.sh # makes the file executable

bash longest.sh alkanes/ pdb > longest.txt # runs the script


#========================================================FINDING THINGS=======================================================

#----------------------------------------------------------Using grep---------------------------------------------------------

# Go to the folder exercise-data/writing/:

# cd ~/tutorial/exercise-data/writing/

# Which command would result in the following output:

# and the presence of absence:
grep -w "of" haiku.txt # -w tells grep to match whole words only

#------------------------------------------------------Tracking a species-----------------------------------------------------

# Go to the folder exercise-data/:

# cd ~/tutorial/exercise-data/

# Leah has several hundred data files saved in one directory, each of which is formatted like this:

# 2012-11-05,deer,5
# 2012-11-05,rabbit,22
# 2012-11-05,raccoon,7
# 2012-11-06,rabbit,19
# 2012-11-06,deer,2
# 2012-11-06,fox,4
# 2012-11-07,rabbit,16
# 2012-11-07,bear,1

# She wants to write a shell script that takes a species as the first command-line argument and a directory as the second 
# argument. The script should return one file called <species>.txt containing a list of dates and the number of that species 
# seen on each date. For example using the data shown above, rabbit.txt would contain:

# 2012-11-05,22
# 2012-11-06,19
# 2012-11-07,16

# Below, each line contains an individual command, or pipe. Arrange their sequence in one command in order to achieve Leah’s goal:

# cut -d : -f 2
# >
# |
# grep -w $1 -r $2
# |
# $1.txt
# cut -d , -f 1,3

nano count-species.sh # creates a new file called count-species.sh

#!/usr/bin/env bash

grep -w "$1" -r "$2" \
  | cut -d , -f 1,3 \
  > "$1.txt"

chmod +x count-species.sh # makes the file executable

bash count-species.sh bear animal-counts/ # runs the script

#---------------------------------------------------------Little women--------------------------------------------------------

# Go to the folder exercise-data/writing/:

# cd ~/tutorial/exercise-data/writing/

# You and your friend, having just finished reading Little Women by Louisa May Alcott, are in an argument. Of the four sisters
# in the book, Jo, Meg, Beth, and Amy, your friend thinks that Jo was the most mentioned. You, however, are certain it was Amy.
# Luckily, you have a file LittleWomen.txt containing the full text of the novel (exercise-data/writing/LittleWomen.txt). 
# Using a for loop, how would you tabulate the number of times each of the four sisters is mentioned?

# The file stats.txt should match the following format:

# Jo:
# 111
# Meg:
# 222
# Beth:
# 333
# Amy:
# 444

nano sisters.sh # creates a new file called sisters.sh

#!/usr/bin/env bash

for sister in Jo Meg Beth Amy
do
  count=$(grep -o -i "$sister" LittleWomen.txt | wc -l)
  echo "$sister:"
  echo "$count"
done > stats.txt

chmod +x sisters.sh # makes the file executable

bash sisters.sh # runs the script

#---------------------------------------------------Matching and subtracting--------------------------------------------------

# Go to the folder exercise-data/:

# cd ~/tutorial/exercise-data/

# The -v option to grep inverts pattern matching, so that only lines which do not match the pattern are printed. Given that, 
# which of the following commands will find all .dat files in creatures except unicorn.dat? Once you have thought about your 
# answer, you can test the commands in the exercise-data/ directory.

find creatures -name "*.dat" | grep -v unicorn
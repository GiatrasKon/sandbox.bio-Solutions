#=========================================================THE BASICS==========================================================

#--------------------------------------------------Navigating the terminal----------------------------------------------------

# echo command: returns the string that is passed to it
echo "Hello World"

# pwd command: prints the current working directory
pwd

# ls command: lists the contents of the current directory
ls
# ls -l command: lists the contents in long format (permissions, owner, size, etc.)
ls -l

#-------------------------------------------------------Preview files---------------------------------------------------------

# head command: prints the first few lines of a file (default is 10)
head orders.tsv
# To view a custom number of lines, use the -n flag
head -n 3 orders.tsv

# tail command: prints the last few lines of a file (default is 10)
tail orders.tsv
# To view a custom number of lines, use the -n flag
tail -n 3 orders.tsv

#-------------------------------------------------------Filter files----------------------------------------------------------

# grep command: searches for a pattern in a file
grep "Burrito" orders.tsv
# By default, grep is case-sensitive. To make it case-insensitive, use the -i flag
grep -i "burrito" orders.tsv
# To find lines that do not contain a pattern, use the -v flag
grep -v "Burrito" orders.tsv


#========================================================PIPELINES============================================================

#----------------------------------------------------------Pipes--------------------------------------------------------------

# Piping is a way to chain commands together. The output of one command is passed as input to the next command.
# Example: find all orders that aren't burritos, and only display the last 3
grep -v "Burrito" orders.tsv | tail -n 3

# wc -l command: prints the number of lines in a file, withou displaying them
# Example: compare the number of Chicken vs. Steak burrito orders
grep "Chicken Burrito" orders.tsv | wc -l
grep "Steak Burrito" orders.tsv | wc -l

#-----------------------------------------------------Output to a file--------------------------------------------------------

# > operator: redirects the output of a command to a file
# Example: save all burrito orders to a file
grep "Burrito" orders.tsv > burritos.tsv
# When using grep to extract lines from a FASTA file, make sure to contain the > character in quotes!
grep ">" ref.fa
# If you don't, the terminal will interpret it as an output redirection operator and you'll lose your data!

# In this case, we have a backup file that we can use to regenerate to FASTA file with the cp (copy) command
cp ref.fa.bak ref.fa

# A better way to avoid this issue altogether is to always prepend cat to your command-line pipelines
# cat command: returns the contents of a file, can be used to concatenate files
cat ref.fa | grep ">"

#--------------------------------------------------Environment variables------------------------------------------------------

# For example, to define a variable abc with contents 123, and def with hello
abc=123
def=hello # no spaces surrounding the equal sign, otherwise the terminal treats the variable name as a command

# Use the $ delimiter to access the value of a variable
echo $abc

# unset command: removes a variable
unset abc

# env command: lists all environment variables
env
#!/bin/bash

RED="\033[0;31m"
GREEN="\033[0;32m"
YELLOW="\033[0;33m"
BLUE="\033[0;34m"
MAGENTA="\033[0;35m"
CYAN="\033[0;36m"
WHITE="\033[0;37m"
NC="\033[0m"

pname="PUSH SWAP - CHECKER"
puser="VZURERA-"

start=$(date +%s%N)

std=0
for arg in "$@"
do
    if [ "$arg" = "--std" ]; then std=1; fi
done

if [ "$std" = 0 ]; then clear; make bonus; fi
printf "\n$YELLOW\t$pname\t\t$MAGENTA $puser\n$NC"
printf "$YELLOW───────────────────────────────────────────────────────────────$CYAN\n\n"

if [ "$std" = 0 ]; then 
	norma=$(norminette .)
	if [[ $norma == *"Error"* ]]; then
		printf " Norminette: $RED\tKO$NC\n"
	else
		printf " Norminette: $GREEN\tOK$NC\n"
	fi
fi

printf "$NC\n"
printf " Error test:\t"
result=$(./checker 2>&1)
if [ "$result" = "" ]; then printf "${GREEN}OK "; else printf "${RED}KO "; fi
result=$(./checker "" 2>&1)
if [ "$result" = "Error" ]; then printf "${GREEN}OK "; else printf "${RED}KO "; fi
numbers=(42 42)
result=$(./checker "${numbers[@]}" 2>&1)
if [ "$result" = "Error" ]; then printf "${GREEN}OK "; else printf "${RED}KO "; fi
numbers=(0 1 2 3 2147483648)
result=$(./checker "${numbers[@]}" 2>&1)
if [ "$result" = "Error" ]; then printf "${GREEN}OK "; else printf "${RED}KO "; fi
numbers=(-2147483649 0 1 2 3)
result=$(./checker "${numbers[@]}" 2>&1)
if [ "$result" = "Error" ]; then printf "${GREEN}OK "; else printf "${RED}KO "; fi
numbers=(0 1 2 d 3)
result=$(./checker "${numbers[@]}" 2>&1)
if [ "$result" = "Error" ]; then printf "${GREEN}OK "; else printf "${RED}KO "; fi
numbers=(5 0 1 2 3)
result=$(echo "42" | ./checker "${numbers[@]}" 2>&1)
if [ "$result" = "Error" ]; then printf "${GREEN}OK "; else printf "${RED}KO "; fi
printf "$NC\n"

printf " Input test:\t"
numbers=(0 9 1 8 2 7 3 6 4 5)
result=$(echo -e "sa\npb\nrrr" | ./checker "${numbers[@]}")
if [ "$result" = "KO" ]; then printf "${GREEN}OK "; else printf "${RED}KO "; fi
numbers=(-10 25 30 7 4 0)
result=$(echo -e "pb\npa\nra\nsa\nrra\nra" | ./checker "${numbers[@]}")
if [ "$result" = "KO" ]; then printf "${GREEN}OK "; else printf "${RED}KO "; fi
numbers=(0 1 2)
result=$(printf "" | ./checker "${numbers[@]}")
if [ "$result" = "OK" ]; then printf "${GREEN}OK "; else printf "${RED}KO "; fi
numbers=(0 9 1 8 2)
result=$(echo -e "pb\nra\npb\nra\nsa\nra\npa\npa" | ./checker "${numbers[@]}")
if [ "$result" = "OK" ]; then printf "${GREEN}OK "; else printf "${RED}KO "; fi
numbers=(-10 54 3 21 32 7)
result=$(echo -e "pb\npb\nra\nrb\npb\nra\nsa\nrra\npa\nrb\nra\nra\npa\nra\npa" | ./checker "${numbers[@]}")
if [ "$result" = "OK" ]; then printf "${GREEN}OK "; else printf "${RED}KO "; fi
printf "$NC\n"

printf "$CYAN\n"
memoryinfo=$(echo -e "pb\npb\nra\nrb\npb\nra\nsa\nrra\npa\nrb\nra\nra\npa\nra\npa" | valgrind --leak-check=full ./checker "-10 54 3 21 32 7" 2>&1 | awk '/HEAP SUMMARY/,/ERROR SUMMARY/' | sed 's/^==[0-9]*==//')
if [[ $memoryinfo == *"All heap blocks were freed -- no leaks are possible"* ]]; then
	printf "\t\t\t$GREEN NO MEMORY LEAKS\n"
else
	printf "$CYAN$memoryinfo\n"
	printf "\n\t\t\t$RED MEMORY LEAKS\n"
fi
printf "$YELLOW───────────────────────────────────────────────────────────────$NC\n"
end=$(date +%s%N)
printf "${CYAN}The test took $(awk -v d=$((end-start)) 'BEGIN {printf "%.2f", d / 1000000000}') seconds\n\n$NC"
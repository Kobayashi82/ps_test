#!/bin/bash

RED="\033[0;31m"
GREEN="\033[0;32m"
YELLOW="\033[0;33m"
BLUE="\033[0;34m"
MAGENTA="\033[0;35m"
CYAN="\033[0;36m"
WHITE="\033[0;37m"
NC="\033[0m"

pname="PUSH SWAP"
puser="VZURERA-"

start=$(date +%s%N)
clear
if [ -f "./checker.c" ]; then make bonus; else make; fi
printf "\n$YELLOW\t$pname\t\t\t$MAGENTA $puser\n$NC"
printf "$YELLOW───────────────────────────────────────────────────────────────$CYAN\n\n"

norma=$(norminette .)
if [[ $norma == *"Error"* ]]; then
	printf " Norminette: $RED\tKO$NC\n"
else
    printf " Norminette: $GREEN\tOK$NC\n"
fi

if [ ! -f "./checker_linux" ]; then
	printf "\n$RED checker_linux not found\n"
	if [ -f "./checker" ]; then
    	./ps_bonus_test.sh --std
	fi
	exit 1
fi

printf "$NC\n"
printf " Error test:\t"
result=$(./push_swap "" 2>&1)
if [ "$result" = "Error" ]; then printf "${GREEN}OK "; else printf "${RED}KO "; fi
numbers=(42 42)
result=$(./push_swap "${numbers[@]}" 2>&1)
if [ "$result" = "Error" ]; then printf "${GREEN}OK "; else printf "${RED}KO "; fi
numbers=(0 1 2 3 2147483648)
result=$(./push_swap "${numbers[@]}" 2>&1)
if [ "$result" = "Error" ]; then printf "${GREEN}OK "; else printf "${RED}KO "; fi
numbers=(-2147483649 0 1 2 3)
result=$(./push_swap "${numbers[@]}" 2>&1)
if [ "$result" = "Error" ]; then printf "${GREEN}OK "; else printf "${RED}KO "; fi
numbers=(0 1 2 d 3)
result=$(./push_swap "${numbers[@]}" 2>&1)
if [ "$result" = "Error" ]; then printf "${GREEN}OK "; else printf "${RED}KO "; fi
printf "$NC\n"

printf " Input test:\t"
numbers=42
result=$(./push_swap $numbers | ./checker_linux $numbers)
if [ "$result" = "OK" ]; then printf "${GREEN}OK "; else printf "${RED}KO "; fi
numbers=(2 3)
result=$(./push_swap $numbers | ./checker_linux $numbers)
if [ "$result" = "OK" ]; then printf "${GREEN}OK "; else printf "${RED}KO "; fi
numbers=(0 1 2 3)
result=$(./push_swap $numbers | ./checker_linux $numbers)
if [ "$result" = "OK" ]; then printf "${GREEN}OK "; else printf "${RED}KO "; fi
numbers=("0 2 1" 3 "4 5 6" 7 "8")
result=$(./push_swap "${numbers[@]}" | ./checker_linux "${numbers[@]}")
if [ "$result" = "OK" ]; then printf "${GREEN}OK "; else printf "${RED}KO "; fi
numbers=(-2147483648 2147483647)
result=$(./push_swap "${numbers[@]}" | ./checker_linux $numbers)
if [ "$result" = "OK" ]; then printf "${GREEN}OK "; else printf "${RED}KO "; fi
printf "$NC\n"

printf "$NC\n"
for i in {1..3}
do
	printf "  3 numbers:"
	numbers=$(seq -1000 1000 | shuf -n 3)
	result=$(./push_swap $numbers | tee temp | ./checker_linux $numbers); lines=$(wc -l <temp); rm temp
	if [ "$result" = "OK" ]; then printf "$GREEN\tSUCCESS $MAGENTA($YELLOW$lines$MAGENTA)$NC\n"; else printf "$RED\tFAILURE $MAGENTA($YELLOW$lines$MAGENTA)$NC\n"; fi
done

printf "\n"
points=2
for i in {1..3}
do
	printf "  5 numbers:"
	numbers=$(seq -1000 1000 | shuf -n 5)
	result=$(./push_swap $numbers | tee temp | ./checker_linux $numbers); lines=$(wc -l <temp); rm temp

	if [ "$result" = "OK" -a "$lines" -lt 13 ]; then
		printf "$GREEN\tSUCCESS $MAGENTA($YELLOW$lines$MAGENTA)$NC"
		if [ "$lines" -lt 9 ] && [ "$points" -ge 1 ]; then points=1;
		else points=0; fi
		if [ "$i" -ne 3 ] || [ "$points" -eq 0 ]; then printf "\n"; fi
	else printf "$RED\tFAILURE $MAGENTA($YELLOW$lines$MAGENTA)$NC\n"; points=0; fi
done
if [ "$points" -gt 0 ]; then
	printf "\t$YELLOW PERFECT\n"
fi

printf "$NC\n"
for i in {1..3}
do
	printf "  10 numbers:"
	numbers=$(seq -1000 1000 | shuf -n 10)
	result=$(./push_swap $numbers | tee temp | ./checker_linux $numbers); lines=$(wc -l <temp); rm temp
	if [ "$result" = "OK" ]; then printf "$GREEN\tSUCCESS $MAGENTA($YELLOW$lines$MAGENTA)$NC\n"; else printf "$RED\tFAILURE $MAGENTA($YELLOW$lines$MAGENTA)$NC\n"; fi
done

printf "\n"
for i in {1..3}
do
	printf "  50 numbers:"
	numbers=$(seq -1000 1000 | shuf -n 50)
	result=$(./push_swap $numbers | tee temp | ./checker_linux $numbers); lines=$(wc -l <temp); rm temp
	if [ "$result" = "OK" ]; then printf "$GREEN\tSUCCESS $MAGENTA($YELLOW$lines$MAGENTA)$NC\n"; else printf "$RED\tFAILURE $MAGENTA($YELLOW$lines$MAGENTA)$NC\n"; fi
done

printf "\n"
points=6
for i in {1..3}
do
	printf " 100 numbers:"
	numbers=$(seq -1000 1000 | shuf -n 100)
	result=$(./push_swap $numbers | tee temp | ./checker_linux $numbers); lines=$(wc -l <temp); rm temp
	
	if [ "$result" = "OK" -a "$lines" -lt 1500 ]; then
		printf "$GREEN\tSUCCESS $MAGENTA($YELLOW$lines$MAGENTA)$NC"
		if [ "$lines" -lt 700 ] && [ "$points" -ge 5 ]; then points=5;
		elif [ "$lines" -lt 900 ] && [ "$points" -ge 4 ]; then points=4;
		elif [ "$lines" -lt 1100 ] && [ "$points" -ge 3 ]; then points=3;
		elif [ "$lines" -lt 1300 ] && [ "$points" -ge 2 ]; then	points=2;
		elif [ "$lines" -lt 1500 ] && [ "$points" -ge 1 ]; then	points=1;
		else points=0; fi
		if [ "$i" -ne 3 ] || [ "$points" -eq 0 ]; then printf "\n"; fi
	else printf "$RED\tFAILURE $MAGENTA($YELLOW$lines$MAGENTA)$NC\n"; points=0; fi
done
if [ "$points" -gt 0 ]; then
	printf "\t$YELLOW $points point"
	if [ "$points" -ne 1 ]; then printf "s\n"; else printf "\n"; fi
else printf "\n"; fi

printf "$NC\n"
for i in {1..3}
do
	printf " 250 numbers:"
	numbers=$(seq -1000 1000 | shuf -n 250)
	result=$(./push_swap $numbers | tee temp | ./checker_linux $numbers); lines=$(wc -l <temp); rm temp
	if [ "$result" = "OK" ]; then printf "$GREEN\tSUCCESS $MAGENTA($YELLOW$lines$MAGENTA)$NC\n"; else printf "$RED\tFAILURE $MAGENTA($YELLOW$lines$MAGENTA)$NC\n"; fi
done

printf "\n"
points=6
for i in {1..3}
do
	printf " 500 numbers:"
	numbers=$(seq -1000 1000 | shuf -n 500)
	result=$(./push_swap $numbers | tee temp | ./checker_linux $numbers); lines=$(wc -l <temp); rm temp
	
	if [ "$result" = "OK" -a "$lines" -lt 11500 ]; then
		printf "$GREEN\tSUCCESS $MAGENTA($YELLOW$lines$MAGENTA)$NC"
		if [ "$lines" -lt 5500 ] && [ "$points" -ge 5 ]; then points=5;
		elif [ "$lines" -lt 7000 ] && [ "$points" -ge 4 ]; then points=4;
		elif [ "$lines" -lt 8500 ] && [ "$points" -ge 3 ]; then points=3;
		elif [ "$lines" -lt 10000 ] && [ "$points" -ge 2 ]; then	points=2;
		elif [ "$lines" -lt 11500 ] && [ "$points" -ge 1 ]; then	points=1;
		else points=0; fi
		if [ "$i" -ne 3 ] || [ "$points" -eq 0 ]; then printf "\n"; fi
	else printf "$RED\tFAILURE $MAGENTA($YELLOW$lines$MAGENTA)$NC\n"; points=0; fi
done
if [ "$points" -gt 0 ]; then
	printf "\t$YELLOW $points point"
	if [ "$points" -ne 1 ]; then printf "s\n"; else printf "\n"; fi
else printf "\n"; fi

printf "$NC\n"
printf " 1000 numbers:"
numbers=$(seq -1000 1000 | shuf -n 1000)
result=$(./push_swap $numbers | tee temp | ./checker_linux $numbers); lines=$(wc -l <temp); rm temp
if [ "$result" = "OK" ]; then printf "$GREEN\tSUCCESS $MAGENTA($YELLOW$lines$MAGENTA)$NC\n"; else printf "$RED\tFAILURE $MAGENTA($YELLOW$lines$MAGENTA)$NC\n"; fi

printf "$CYAN\n"
numbers=$(seq 1 200 | shuf -n 100)
memoryinfo=$(valgrind -s ./push_swap $numbers 2>&1 | awk '/HEAP SUMMARY/,/ERROR SUMMARY/' | sed 's/^==[0-9]*==//')

if [[ $memoryinfo == *"All heap blocks were freed -- no leaks are possible"* ]]; then
    printf "\t\t\t$GREEN NO MEMORY LEAKS\n"
else
    printf "$CYAN$memoryinfo\n"
	printf "\n\t\t\t$RED MEMORY LEAKS\n"
fi
printf "$YELLOW───────────────────────────────────────────────────────────────$NC\n"
end=$(date +%s%N)
printf "${CYAN}The test took $(awk -v d=$((end-start)) 'BEGIN {printf "%.2f", d / 1000000000}') seconds\n\n$NC"

if [ -f "./checker" ]; then
    ./ps_bonus_test.sh --std
fi
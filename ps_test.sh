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

clear
checker=./checker_Mac

if [ ! -f $checker ]; then
	if [ -f "./checker_linux" ]; then checker=./checker_linux;
		printf "\n$YELLOW\t$pname\t\t\t$MAGENTA $puser\n$NC"
	else
		if [ -f "./checker" ]; then
			printf "\n$RED checker not found, using bonus checker\n"
    		checker=./checker
			printf "\n$YELLOW\t$pname - (Bonus Checker)\t$MAGENTA $puser\n$NC"
		else
			printf "\n$RED checker not found\n\n"
			exit
		fi
	fi
else
	printf "\n$YELLOW\t$pname\t\t\t$MAGENTA $puser\n$NC"
fi

printf "${YELLOW}───────────────────────────────────────────────────────────────$CYAN\n\n"

norma=$(norminette .)
if [[ $norma == *"Error"* ]]; then
	printf " Norminette: $RED\tKO$NC\n"
else
    printf " Norminette: $GREEN\tOK$NC\n"
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
numbers=(0 1-2 3)
result=$(./push_swap "${numbers[@]}" 2>&1)
if [ "$result" = "Error" ]; then printf "${GREEN}OK "; else printf "${RED}KO "; fi
numbers=(0 1+2 3)
result=$(./push_swap "${numbers[@]}" 2>&1)
if [ "$result" = "Error" ]; then printf "${GREEN}OK "; else printf "${RED}KO "; fi
printf "$NC\n"

printf " Input test:\t"
numbers=42
result=$(./push_swap $numbers | $checker $numbers)
if [ "$result" = "OK" ]; then printf "${GREEN}OK "; else printf "${RED}KO "; fi
numbers=(2 3)
result=$(./push_swap $numbers | $checker $numbers)
if [ "$result" = "OK" ]; then printf "${GREEN}OK "; else printf "${RED}KO "; fi
numbers=(0 1 2 3)
result=$(./push_swap $numbers | $checker $numbers)
if [ "$result" = "OK" ]; then printf "${GREEN}OK "; else printf "${RED}KO "; fi
numbers=("0 2 1" 3 "4 5 6" 7 "8")
result=$(./push_swap "${numbers[@]}" | $checker "${numbers[@]}")
if [ "$result" = "OK" ]; then printf "${GREEN}OK "; else printf "${RED}KO "; fi
numbers=(-2147483648 2147483647)
result=$(./push_swap "${numbers[@]}" | $checker $numbers)
if [ "$result" = "OK" ]; then printf "${GREEN}OK "; else printf "${RED}KO "; fi
printf "$NC\n"

printf "$NC\n"
for i in {1..3}
do
	printf "  3 numbers:"
	numbers=$(jot 3 -1000 1000 | awk -v seed=$RANDOM 'BEGIN{srand(seed);}{print rand() "\t" $0}' | sort -n | cut -f2- | tr '\n' ' ')
	result=$(./push_swap $numbers | tee temp | $checker $numbers); lines=$(wc -l <temp | tr -d ' '); rm temp
	if [ "$result" = "OK" ]; then printf "$GREEN\tSUCCESS $MAGENTA($YELLOW$lines$MAGENTA)$NC\n"; else printf "$RED\tFAILURE $MAGENTA($YELLOW$lines$MAGENTA)$NC\n"; fi
done

printf "\n"
points=2
for i in {1..3}
do
	printf "  5 numbers:"
	numbers=$(jot 5 -1000 1000 | awk -v seed=$RANDOM 'BEGIN{srand(seed);}{print rand() "\t" $0}' | sort -n | cut -f2- | tr '\n' ' ')
	result=$(./push_swap $numbers | tee temp | $checker $numbers); lines=$(wc -l <temp | tr -d ' '); rm temp
	# if [ "$lines" -gt 5 ]; then printf "\t$numbers - "; fi
	# printf "\t$numbers - "
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
	numbers=$(jot 10 -1000 1000 | awk -v seed=$RANDOM 'BEGIN{srand(seed);}{print rand() "\t" $0}' | sort -n | cut -f2- | tr '\n' ' ')
	result=$(./push_swap $numbers | tee temp | $checker $numbers); lines=$(wc -l <temp | tr -d ' '); rm temp
	if [ "$result" = "OK" ]; then printf "$GREEN\tSUCCESS $MAGENTA($YELLOW$lines$MAGENTA)$NC\n"; else printf "$RED\tFAILURE $MAGENTA($YELLOW$lines$MAGENTA)$NC\n"; fi
done

printf "\n"
for i in {1..3}
do
	printf "  50 numbers:"
	numbers=$(jot 50 -1000 1000 | awk -v seed=$RANDOM 'BEGIN{srand(seed);}{print rand() "\t" $0}' | sort -n | cut -f2- | tr '\n' ' ')
	result=$(./push_swap $numbers | tee temp | $checker $numbers); lines=$(wc -l <temp | tr -d ' '); rm temp
	if [ "$result" = "OK" ]; then printf "$GREEN\tSUCCESS $MAGENTA($YELLOW$lines$MAGENTA)$NC\n"; else printf "$RED\tFAILURE $MAGENTA($YELLOW$lines$MAGENTA)$NC\n"; fi
done

printf "\n"
points=6
for i in {1..3}
do
	printf " 100 numbers:"
	numbers=$(jot 100 -1000 1000 | awk -v seed=$RANDOM 'BEGIN{srand(seed);}{print rand() "\t" $0}' | sort -n | cut -f2- | tr '\n' ' ')
	result=$(./push_swap $numbers | tee temp | $checker $numbers); lines=$(wc -l <temp | tr -d ' '); rm temp
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
	numbers=$(jot 250 -1000 1000 | awk -v seed=$RANDOM 'BEGIN{srand(seed);}{print rand() "\t" $0}' | sort -n | cut -f2- | tr '\n' ' ')
	result=$(./push_swap $numbers | tee temp | $checker $numbers); lines=$(wc -l <temp | tr -d ' '); rm temp
	if [ "$result" = "OK" ]; then printf "$GREEN\tSUCCESS ${MAGENTA}(${YELLOW}${lines}${MAGENTA})$NC\n"; else printf "$RED\tFAILURE ${MAGENTA}(${YELLOW}${lines}${MAGENTA})$NC\n"; fi
done

printf "\n"
points=6
for i in {1..3}
do
	printf " 500 numbers:"
	numbers=$(jot 500 -1000 1000 | awk -v seed=$RANDOM 'BEGIN{srand(seed);}{print rand() "\t" $0}' | sort -n | cut -f2- | tr '\n' ' ')
	result=$(./push_swap $numbers | tee temp | $checker $numbers); lines=$(wc -l <temp | tr -d ' '); rm temp
	
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
numbers=$(jot 1000 -1000 1000 | awk -v seed=$RANDOM 'BEGIN{srand(seed);}{print rand() "\t" $0}' | sort -n | cut -f2- | tr '\n' ' ')
result=$(./push_swap $numbers | tee temp | $checker $numbers); lines=$(wc -l <temp | tr -d ' '); rm temp
if [ "$result" = "OK" ]; then printf "$GREEN\tSUCCESS $MAGENTA($YELLOW$lines$MAGENTA)$NC\n"; else printf "$RED\tFAILURE $MAGENTA($YELLOW$lines$MAGENTA)$NC\n"; fi

if [ -f ~/.brew/bin/valgrind ]; then
	printf "$NC\n"
	numbers=$(jot 100 -1000 1000 | awk 'BEGIN{srand();} {print rand() "\t" $0}' | sort -n | cut -f2- | tr '\n' ' ')
	memoryinfo=$(valgrind --show-error-list=no --leak-check=full ./push_swap $numbers 2>&1 | awk '/HEAP SUMMARY/,/ERROR SUMMARY/' | sed 's/^==[0-9]*==//')

	if [[ $memoryinfo == *"ERROR SUMMARY: 0 errors"* ]]; then
    	printf "\t\t\t$GREEN NO MEMORY LEAKS\n"
	else
	#    printf "$CYAN$memoryinfo\n"
    	printf "\n\t\t\t$RED MEMORY LEAKS\n"
	fi
fi

printf "${YELLOW}───────────────────────────────────────────────────────────────$NC\n\n"
if [ -f "./checker" ]; then	./ps_btest.sh --std; fi

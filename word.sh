#!/bin/bash

total_guesses=6
guesses=()
goal=""

function highlight_characters_matching_goal() {
    local guess="$1"

    for ((i = 0; i < ${#guess}; i++)); do
        local guess_character="${guess:$i:1}"
        local goal_character="${goal:$i:1}"

        if [[ $guess_character = $goal_character ]]; then
            echo -ne "\e[42;30m$guess_character\e[0m"
        elif [[ $goal == *"$guess_character"* ]]; then
            echo -ne "\e[43;30m$guess_character\e[0m"
        else
            echo -n $guess_character
        fi
    done

    # Print trailing newline
    echo
}

function print_all_guesses() {
    echo

    for ((i = 0; i < $total_guesses; i++)); do
        local guess=${guesses[$i]}

       if [[ -z "$guess" ]]; then
           echo "____"
       else
           echo -e "$guess"
       fi 
    done

    echo
}

function main_loop() {
    local word_file="./five-letter-words.txt"

    goal=$(shuf -n 1 $word_file)

    while true; do
        read -p "Guess a five-letter word: " input

        if ! [[ "$input" =~ ^[a-zA-Z]{5}$ ]]; then
            echo -e "\e[31mGuess must be five characters from the English alphabet\e[0m"
            continue
        fi

        local guess=${input^^}

        if ! grep -q "^$guess$" $word_file; then
            echo -e "\e[31mGuess not found in word list\e[0m"
            continue;
        fi

        local highlighted_guess=$(highlight_characters_matching_goal $guess)

        guesses+=($highlighted_guess)

        print_all_guesses

        if [[ $guess = $goal ]]; then
            echo "Solved in ${#guesses[@]} guesses"
            exit 0
        elif [[ ${#guesses[@]} -eq $total_guesses ]]; then
            echo "Sorry, you failed to find the word, which was '$goal'"
            exit 1
        fi
    done
}

main_loop

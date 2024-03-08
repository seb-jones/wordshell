#!/bin/bash

total_guesses=6
guesses=()
goal=""

function blank_line() {
    printf "\n"
}

function print_line() {
    printf "$1\n"
}

function highlight_characters_matching_goal() {
    local guess="$1"

    for ((i = 0; i < ${#guess}; i++)); do
        local guess_character="${guess:$i:1}"
        local goal_character="${goal:$i:1}"

        if [[ $guess_character = $goal_character ]]; then
            printf "\e[42;30m$guess_character\e[0m"
        elif [[ $goal == *"$guess_character"* ]]; then
            printf "\e[43;30m$guess_character\e[0m"
        else
            printf "$guess_character"
        fi
    done

    blank_line
}

function print_all_guesses() {
    blank_line

    for ((i = 0; i < $total_guesses; i++)); do
        local guess=${guesses[$i]}

       if [[ -z "$guess" ]]; then
           print_line "_____"
       else
           print_line "$guess"
       fi 
    done

    blank_line
}

function main_loop() {
    local word_file="./five-letter-words.txt"

    goal=$(shuf -n 1 $word_file)

    while true; do
        read -r -p "Guess a five-letter word: " input

        if ! [[ "$input" =~ ^[a-zA-Z]{5}$ ]]; then
            print_line "\e[31mGuess must be five characters from the English alphabet\e[0m"
            continue
        fi

        local guess=$(printf "$input" | tr '[:lower:]' '[:upper:]')

        if ! grep -q "^$guess$" $word_file; then
            print_line "\e[31mGuess not found in word list\e[0m"
            continue;
        fi

        local highlighted_guess=$(highlight_characters_matching_goal $guess)

        guesses+=($highlighted_guess)

        print_all_guesses

        if [[ $guess = $goal ]]; then
            print_line "Solved in ${#guesses[@]} guesses"
            exit 0
        elif [[ ${#guesses[@]} -eq $total_guesses ]]; then
            print_line "Sorry, you failed to find the word, which was '$goal'"
            exit 1
        fi
    done
}

main_loop

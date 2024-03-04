wget -O - https://raw.githubusercontent.com/dolph/dictionary/master/popular.txt \
    | awk 'length == 5 { print toupper($0) }' \
    > five-letter-words.txt

#!/bin/bash

cleanup_filename() {
    echo "$1" | \
        sed -E 's/[0-9]{9,13}//g' | \
        sed -E 's/[a-f0-9]{8,40}//g' | \
        sed -E "s/ *-- *Anna's Archive//g" | \
        sed -E "s/ *-- *Anna’s Archive//g" | \
        sed -E 's/( *-- *){2,}/ -- /g' | \
        sed -E 's/ +- +/ -- /g' | \
        sed -E 's/[-_ ]+$//g' | \
        sed -E 's/, -- \./\./g' | \
        sed -E 's/ -- \./\./g' | \
        sed -E 's/ --\./\./g'
}

# Expand tilde in the input path
dir="${1/#\~/$HOME}"

if [ -z "$dir" ]; then
    echo "Directory path is required"
    exit 1
fi

if [ ! -d "$dir" ]; then
    echo "Directory does not exist: $dir"
    exit 1
fi

# Preview changes - compatible with both bash and zsh
while IFS= read -r file; do
    filename=$(basename "$file")
    new_filename=$(cleanup_filename "$filename")

    if [ "$filename" != "$new_filename" ]; then
        echo "Old: $filename"
        echo "New: $new_filename"
        echo "---"
    fi
done < <(find "$dir" -type f)

echo "Review the changes above."
read -p "Do you want to proceed with renaming? (y/N) " confirm
if [ "$confirm" = "y" ] || [ "$confirm" = "Y" ]; then
    while IFS= read -r file; do
        filename=$(basename "$file")
        filedir=$(dirname "$file")
        new_filename=$(cleanup_filename "$filename")

        if [ "$filename" != "$new_filename" ]; then
            mv "$file" "$filedir/$new_filename"
            echo "Renamed: $new_filename"
        fi
    done < <(find "$dir" -type f)
fi

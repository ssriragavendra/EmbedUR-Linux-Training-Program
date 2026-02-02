# !/bin/bash

#Task-1

echo "Task-1 Command line arguements"
echo ""

if [[ $# -lt 3 ]]; then
echo "USAGE: $0 <source_directory> <backup_directory> <file_extension>"
exit 1
fi

source_dir="$1"
backup_dir="$2"
file_ext="$3"

echo "The added arguements:"
echo "Source directory : $source_dir"
echo "Backup directory : $backup_dir"
echo "File extension : $file_ext"
echo ""

#Task-2

echo "Finding the files using globbing"
echo ""

if [[ ! -d "$source_dir" ]]; then
echo "ERROR: Source directory '$source_dir' does not exist"
exit 1
fi

if [[ ! -d "$backup_dir" ]]; then
echo "Creating a backup directory: $backup_dir"
mkdir -p "$backup_dir"
if [[ $? -ne 0 ]]; then
echo "ERROR: Failed to create backup directory '$backup_dir'. Exiting."
exit 1
fi
fi


echo "Files found in source directory wth extension $file_ext"

for file in "$source_dir"/*"$file_ext"; do
if [[ -f "$file" ]]; then
echo " $(basename "$file")"
fi
done


#Task-3

echo "The export variable"

f_count=0
for i in "$source_dir"/*"$file_ext"; do
if [[ -f "$i" ]]; then
((f_count++))
fi
done

export BACKUP_COUNT=$f_count

echo "Total number of $file_ext files to backup: $BACKUP_COUNT"

#Task - 4

echo "Creating Associative Array"

declare -a file_array

for i in "$source_dir"/*"$file_ext"; do 
    if [[ -f "$i" ]]; then
        file_array+=("$(basename "$i")")  
    fi
done

echo "Files listed with index:"
for i in "${!file_array[@]}"; do
echo " [$i] ${file_array[$i]}"
done



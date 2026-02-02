# backup_manager.sh – Description

This shell script is created as part of the Module 3 Assessment to demonstrate file handling and backup preparation using Bash scripting concepts.

# Command-line Arguments and Quoting:

The script accepts three command-line arguments: source directory, backup directory, and file extension. 
It checks whether the required arguments are provided and stores them using proper quoting to handle paths safely.

if [[ $# -lt 3 ]]; then
echo "USAGE: $0 <source_directory> <backup_directory> <file_extension>"
exit 1
fi

source_dir="$1"
backup_dir="$2"
file_ext="$3"


# Globbing

Globbing is used to find all files in the source directory that match the given file extension and display their names.

for file in "$source_dir"/*"$file_ext"; do
if [[ -f "$file" ]]; then
echo " $(basename "$file")"
fi
done


# Export Statement

The script counts the total number of matching files and exports the count as an environment variable named BACKUP_COUNT.

f_count=0
for i in "$source_dir"/*"$file_ext"; do
if [[ -f "$i" ]]; then
((f_count++))
fi
done

export BACKUP_COUNT=$f_count


# Array Operations

An indexed array is used to store the names of the files matching the specified extension. The script prints the array index along with each filename.

declare -a file_array

for i in "$source_dir"/*"$file_ext"; do 
    if [[ -f "$i" ]]; then
        file_array+=("$(basename "$i")")  
    fi
done

for i in "${!file_array[@]}"; do
echo " [$i] ${file_array[$i]}"
done

# Conditional Execution

The script checks whether the source directory exists and creates the backup directory if it does not already exist. 
Error handling is included to prevent execution failures.

if [[ ! -d "$source_dir" ]]; then
echo "ERROR: Source directory '$source_dir' does not exist"
exit 1
fi

if [[ ! -d "$backup_dir" ]]; then
mkdir -p "$backup_dir"
if [[ $? -ne 0 ]]; then
echo "ERROR: Failed to create backup directory '$backup_dir'. Exiting."
exit 1
fi
fi

# Output
The script displays the total number of files identified for backup, providing clear feedback to the user.

echo "Total number of $file_ext files to backup: $BACKUP_COUNT"

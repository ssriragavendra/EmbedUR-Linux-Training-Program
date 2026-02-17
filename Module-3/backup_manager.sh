#!/bin/bash

# Task 1: Command line arguments and Quoting
if [[ $# -lt 3 ]]; then
    echo "USAGE: $0 <source_directory> <backup_directory> <file_extension>"
    exit 1
fi

source_dir="$1"
backup_dir="$2"
file_ext="$3"

echo "Source directory : $source_dir"
echo "Backup directory : $backup_dir"
echo "File extension    : $file_ext"
echo ""

# Task 2 & 5: Validation and Conditional Execution
if [[ ! -d "$source_dir" ]]; then
    echo "ERROR: Source directory '$source_dir' does not exist."
    exit 1
fi

if [[ ! -d "$backup_dir" ]]; then
    echo "Creating backup directory: $backup_dir"
    mkdir -p "$backup_dir" || { echo "ERROR: Failed to create backup directory. Exiting."; exit 1; }
fi

# Task 3: Export Statement
shopt -s nullglob 
files_to_backup=("$source_dir"/*"$file_ext")
export BACKUP_COUNT=${#files_to_backup[@]}

# Requirement 5: Exit if no files match
if [[ $BACKUP_COUNT -eq 0 ]]; then
    echo "No files matching '$file_ext' found in $source_dir. Exiting."
    exit 0
fi

echo "Total number of files to backup: $BACKUP_COUNT"
echo "------------------------------------------"

# Task 4 & 5: Array Operations and Backup Logic
declare -a file_array
total_size_bytes=0

for i in "${files_to_backup[@]}"; do
    file_name=$(basename "$i")
    dest_path="$backup_dir/$file_name"
    
    # Requirement 4: Get file size
    file_size=$(stat -c%s "$i")
    file_array+=("$file_name ($file_size bytes)")
    
    # Requirement 5: Compare timestamps
    if [[ ! -f "$dest_path" || "$i" -nt "$dest_path" ]]; then
        cp -p "$i" "$dest_path" # -p preserves timestamps for future comparisons
        ((total_size_bytes += file_size))
        echo "Backed up: $file_name"
    else
        echo "Skipped: $file_name (Backup is already up to date)"
    fi
done

# Task 6: Output Report
report_file="$backup_dir/backup_report.log"
{
    echo "Backup Summary Report"
    echo "Date: $(date)"
    echo "----------------------------"
    echo "Total files processed: $BACKUP_COUNT"
    echo "Total size of files backed up: $total_size_bytes bytes"
    echo "Path to backup directory: $backup_dir"
} > "$report_file"

echo "------------------------------------------"
echo "Report generated at: $report_file"

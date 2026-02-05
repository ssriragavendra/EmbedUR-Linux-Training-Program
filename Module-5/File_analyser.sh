# !/bin/bash

LOG_ERROR="errors.log"

log_error(){
   local info="$1"
   echo "ERROR: $info" >> "$LOG_ERROR"
   echo "ERROR: $info" >&2
}

show_help() {
cat << EOF
Usage: $0 [-d directory] [-f file] [-k keyword]
  -d : Recursive search in directory
  -f : Search in a specific file
  -k : The keyword to find
EOF
}

# recursive_serach

recursive_search(){
   local target_dir="$1"
   local keyword="$2"

   for item in "$target_dir"/*; do
      if [[ -d "$item" ]]; then
         recursive_search "$item" "$keyword"
      elif [[ -f "$item" ]]; then
         if grep -q "$keyword" "$item"; then
            echo "Found in: $item"
         fi
      fi
   done
}

if [[ $1 == "--help" ]]; then
   show_help
   exit 1
fi

if [[ $# -eq 0 ]]; then
   echo "No arguements has been provided. Use --help command to get help"
   exit 1
fi

while getopts ":d:f:k:" args; do
   case $args in
      d) search_dir="$OPTARG" ;;
      k) keyword="$OPTARG" ;;
      f) target_file="$OPTARG" ;;
      *) log_error "Invalid option: -$OPTARG"; exit 1 ;;
    esac
done


if [[ -z "$keyword" ]]; then
   log_error "Keyword cannot be empty"
   exit 1
fi

if [[ -n "$target_file" ]]; then
   if [[ ! -f "$target_file" ]]; then
      log_error "File '$target_file' does not exist."
      exit 1
   fi
   	
   file_content=$(cat "$target_file")
   if grep -q "$keyword" <<< "$file_content"; then
      echo "Keyword '$keyword' found in $target_file"
   else
      echo "Keyword not found."
   fi

elif [[ -n "$search_dir" ]]; then
   if [[ ! -d "$search_dir" ]]; then
      log_error "Directory '$search_dir' doesn't exist."
      exit 1
   fi

   echo "Searching recursively for '$keyword' in '$search_dir' "
   recursive_search "$search_dir" "$keyword"
fi

if [[ $? -eq 0 ]]; then
   echo "Completed the analysis for the file $0"
else
   echo "Couldn't do the analysis"
fi


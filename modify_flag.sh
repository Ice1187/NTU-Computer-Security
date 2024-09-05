#!/bin/bash

# Function to generate random printable ASCII characters
generate_random_ascii() {
  tr -dc '[:print:]' < /dev/urandom | head -c 12
}

# Iterate over each file found by the find command
find . -name flag | while read -r filepath; do
  # Read the original content of the file
  orig_content=$(cat "$filepath")
  
  # Generate 6 random printable ASCII characters
  random_ascii=$(generate_random_ascii)
  
  # Concatenate the original content and random ASCII characters
  combined_content="${orig_content}${random_ascii}"
  
  # Generate the MD5 hash of the combined content
  sha_hash=$(echo -n "$combined_content" | sha1sum | awk '{print $1}')
  
  # Extract the first 'n' characters of the MD5 hash, where 'n' is the length of the original content
  orig_length=${#orig_content}
  new_content_hash=${sha_hash:0:$orig_length}
  
  # Create the new content in the FLAG{...} format
  truncated_content="${new_content_hash:0:$orig_length-6}"
  new_content="FLAG{${truncated_content}}"
  
  # Update the file with the new content
  echo "$orig_content ($orig_length) -> $new_content (${#new_content})"
  echo "$new_content"  > "$filepath"
done


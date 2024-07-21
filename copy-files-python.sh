# Create the copy directory if it doesn't exist
mkdir -p copy

# Function to copy file and add .txt extension
copy_file() {
    local src="$1"
    local filename=$(basename "$src")
    local dest="copy/${filename}.txt"
    # If the file already exists in the destination, append a number to make it unique
    counter=1
    while [ -e "$dest" ]; do
        dest="copy/${filename}_${counter}.txt"
        ((counter++))
    done
    # Copy the file
    cp "$src" "$dest"
    echo "Copied: $src to $dest"
}
export -f copy_file

# Define files and directories to ignore
IGNORE_FILES=".DS_Store|\.env|\.pyc"
IGNORE_DIRS="venv|\.venv|__pycache__|\.git"
export IGNORE_FILES IGNORE_DIRS

# Copy specific files from the root directory
find . -maxdepth 1 -type f \( -name ".gitignore" -o -name "requirements.txt" -o -name "setup.py" -o -name "README.md" \) -not -regex ".*\(${IGNORE_FILES}\)" -exec bash -c 'copy_file "$0"' {} \;

# Copy Python files from the project directories
find . -type f \( -name "*.py" -o -name "*.ipynb" -o -name "*.json" -o -name "*.md" \) -not -path "*/venv/*" -not -path "*/.venv/*" -not -path "*/__pycache__/*" -not -path "*/.git/*" -not -regex ".*\(${IGNORE_FILES}\)" -exec bash -c 'copy_file "$0"' {} \;

# Confirmation message for copied files
echo "Files have been copied to the 'copy' directory with .txt extension added."

# Generate project structure and save to MY_PROJECT_STRUCTURE.txt
tree -a -I "${IGNORE_DIRS}|${IGNORE_FILES}|copy" --dirsfirst >copy/PYTHON_PROJECT_STRUCTURE.txt
echo "Project structure has been saved to copy/PYTHON_PROJECT_STRUCTURE.txt"

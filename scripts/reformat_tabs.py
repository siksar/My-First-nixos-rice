import os

def reformat_file(filepath):
    try:
        with open(filepath, 'r') as f:
            lines = f.readlines()
        
        new_lines = []
        for line in lines:
            stripped = line.lstrip(' ')
            if not stripped: # Empty line
                new_lines.append(line)
                continue
                
            leading_spaces = len(line) - len(stripped)
            # Assuming standard 2-space indentation in Nix
            # Convert 2 spaces -> 1 Tab (8-char width hard tab)
            tabs_count = leading_spaces // 2
            
            # Construct new line with tabs
            new_line = ('\t' * tabs_count) + stripped
            new_lines.append(new_line)
            
        with open(filepath, 'w') as f:
            f.writelines(new_lines)
        print(f"Reformatted: {filepath}")
        
    except Exception as e:
        print(f"Error processing {filepath}: {e}")

def main():
    target_dir = '/etc/nixos'
    extensions = ['.nix']
    
    for root, dirs, files in os.walk(target_dir):
        if '.git' in dirs:
            dirs.remove('.git') # Skip .git directory
            
        for file in files:
            if any(file.endswith(ext) for ext in extensions):
                filepath = os.path.join(root, file)
                reformat_file(filepath)

if __name__ == "__main__":
    main()

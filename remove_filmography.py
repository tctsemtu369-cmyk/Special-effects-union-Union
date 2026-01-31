import os

# List of files to process
files = [
    r"c:\Users\USER\OneDrive\Desktop\tctsemtu site\prakash.html",
    r"c:\Users\USER\OneDrive\Desktop\tctsemtu site\konda.html",
    r"c:\Users\USER\OneDrive\Desktop\tctsemtu site\srinivas.html",
    r"c:\Users\USER\OneDrive\Desktop\tctsemtu site\aravindh.html",
    r"c:\Users\USER\OneDrive\Desktop\tctsemtu site\sanjeev.html",
    r"c:\Users\USER\OneDrive\Desktop\tctsemtu site\suresh_babu.html",
    r"c:\Users\USER\OneDrive\Desktop\tctsemtu site\murtuza_kamal.html",
    r"c:\Users\USER\OneDrive\Desktop\tctsemtu site\veerandranath.html",
    r"c:\Users\USER\OneDrive\Desktop\tctsemtu site\b_balakrishna.html",
    r"c:\Users\USER\OneDrive\Desktop\tctsemtu site\j_suresh.html",
    r"c:\Users\USER\OneDrive\Desktop\tctsemtu site\paramesh.html",
    r"c:\Users\USER\OneDrive\Desktop\tctsemtu site\rajendra_prasad.html",
    r"c:\Users\USER\OneDrive\Desktop\tctsemtu site\srinivasa_rao.html",
    r"c:\Users\USER\OneDrive\Desktop\tctsemtu site\naveen_kumar.html",
    r"c:\Users\USER\OneDrive\Desktop\tctsemtu site\sai_babu.html",
    r"c:\Users\USER\OneDrive\Desktop\tctsemtu site\pavan.html",
    r"c:\Users\USER\OneDrive\Desktop\tctsemtu site\santhosh.html",
    r"c:\Users\USER\OneDrive\Desktop\tctsemtu site\suresh_kumar.html",
    r"c:\Users\USER\OneDrive\Desktop\tctsemtu site\chandra_mohan.html"
]

for file_path in files:
    if not os.path.exists(file_path):
        print(f"File not found: {file_path}")
        continue

    try:
        with open(file_path, 'r', encoding='utf-8') as f:
            lines = f.readlines()

        new_lines = []
        i = 0
        while i < len(lines):
            # Check if this line starts a Filmography row
            # We look ahead to see if "Filmography" is in the next few lines within a tr block
            
            # Simple heuristic: if we see "Filmography", we find the enclosing tr
            if "Filmography" in lines[i]:
                # This line has "Filmography". 
                # We need to backtrack to find the start of the TR and forward to find the end.
                
                # Backtrack to find <tr>
                start_index = i
                while start_index >= 0 and "<tr>" not in lines[start_index]:
                    start_index -= 1
                
                # Forward track to find </tr>
                end_index = i
                while end_index < len(lines) and "</tr>" not in lines[end_index]:
                    end_index += 1
                
                # If we found valid start and end indices
                if start_index >= 0 and end_index < len(lines):
                    # We skip copying these lines to new_lines
                    # But we need to handle the case where we've already added the Lines before 'i' corresponding to this block
                    # Actually, a better single-pass approach:
                    pass
                else:
                     print(f"Could not find tr bounds in {file_path} around line {i}")

            i += 1
            
        # Let's try a different approach:
        # iterate and copy. If we detect a TR that contains Filmography, we drop it.
        # But we don't know if a TR contains Filmography until we've read it.
        
        # So read the whole file string, find the chunk.
        with open(file_path, 'r', encoding='utf-8') as f:
            content = f.read()

        # We will split by <tr> and check each block
        # This is risky if trs are nested (tables usually aren't here)
        
        # New approach:
        # Load lines.
        # Identify ranges to delete.
        ranges_to_delete = []
        
        for idx, line in enumerate(lines):
            if "Filmography" in line:
                # Find start
                s = idx
                while s >= 0 and "<tr>" not in lines[s]:
                    s -= 1
                
                # Find end
                e = idx
                while e < len(lines) and "</tr>" not in lines[e]:
                    e += 1
                
                if s >= 0 and e < len(lines):
                    ranges_to_delete.append((s, e))
        
        # Now construct new content skipping those ranges
        if not ranges_to_delete:
            print(f"No Filmography found in {file_path}")
            continue
            
        final_lines = []
        skip = False
        current_range_idx = 0
        
        for idx, line in enumerate(lines):
            in_delete_range = False
            for start, end in ranges_to_delete:
                if start <= idx <= end:
                    in_delete_range = True
                    break
            
            if not in_delete_range:
                final_lines.append(line)
        
        with open(file_path, 'w', encoding='utf-8') as f:
            f.writelines(final_lines)
            
        print(f"Processed {file_path}")

    except Exception as e:
        print(f"Error processing {file_path}: {e}")

import os
import re

directory = r"c:\Users\USER\OneDrive\Desktop\tctsemtu site"
new_skills_html = """<ul style="margin: 0; padding-left: 20px;">
                                                    <li>Mechanical Effects</li>
                                                    <li>Fire Effects</li>
                                                    <li>Special Effects</li>
                                                </ul>"""

def update_file(filepath):
    with open(filepath, 'r', encoding='utf-8') as f:
        content = f.read()

    # Check if it's a technician file (Has T-XXX ID in Union Card No)
    # flexible regex for Union Card No row
    if not re.search(r'Union Card No.*?T-\d{3}', content, re.DOTALL):
        return False

    # Regex to find the Professional Skills cell and the ul inside it
    # We look for "Professional Skills" then the next <td> containing a <ul>
    pattern = r'(Professional Skills.*?<td[^>]*>.*?)(<ul\s+style="margin:\s*0;\s*padding-left:\s*20px;">.*?</ul>)'
    
    match = re.search(pattern, content, re.DOTALL)
    if match:
        # We found the Professional Skills section and the existing list
        # Check if it's already updated to avoid needless writes (optional, but good)
        if new_skills_html.replace(" ", "") in match.group(2).replace(" ", ""):
             print(f"Skipping {os.path.basename(filepath)} (already up to date)")
             return False
        
        # Replace only the list part
        new_content = content.replace(match.group(2), new_skills_html)
        
        with open(filepath, 'w', encoding='utf-8') as f:
            f.write(new_content)
        print(f"Updated {os.path.basename(filepath)}")
        return True
    else:
        print(f"pattern not found in {os.path.basename(filepath)}")
        return False

count = 0
for filename in os.listdir(directory):
    if filename.endswith(".html") and filename != "technicians.html" and filename != "masters.html":
        filepath = os.path.join(directory, filename)
        if update_file(filepath):
            count += 1

print(f"Total files updated: {count}")

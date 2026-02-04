$directory = "c:\Users\USER\OneDrive\Desktop\tctsemtu site"
$newSkillsHtml = '<ul style="margin: 0; padding-left: 20px;">
                                                    <li>Mechanical Effects</li>
                                                    <li>Fire Effects</li>
                                                    <li>Special Effects</li>
                                                </ul>'

$files = Get-ChildItem -Path $directory -Filter "*.html"

foreach ($file in $files) {
    if ($file.Name -eq "technicians.html" -or $file.Name -eq "masters.html") { continue }

    $content = Get-Content -Path $file.FullName -Raw -Encoding UTF8

    # Check if it's a Technician profile (Has T-XXX)
    if ($content -match "Union Card No[\s\S]*?T-\d{3}") {
        
        # Regex to find the Professional Skills list
        # We look for the ul inside the Professional Skills section
        # NOTE: PowerShell regex is similar to .NET
        $pattern = '(?s)(Professional Skills.*?<td[^>]*>.*?)(<ul\s+style="margin:\s*0;\s*padding-left:\s*20px;">.*?</ul>)'
        
        if ($content -match $pattern) {
            # $matches[0] is full match, $matches[1] is prefix, $matches[2] is the UL
            # But direct replacement is easier if we just match the UL part in context or simply find-replace if unique enough
            
            # Let's try to replace the specific UL block if it follows Professional Skills
            # Using -replace operator with callback is tricky in older PS, so we use dotnet objects or just simple split/join if pattern is robust
            
            # Robust approach: match the specific block
            $newContent = $content -replace '(?s)(Professional Skills[\s\S]*?<td[^>]*>[\s\S]*?)(<ul\s+style="margin:\s*0;\s*padding-left:\s*20px;">[\s\S]*?</ul>)', ('${1}' + $newSkillsHtml)
             
            if ($newContent -ne $content) {
                $newContent | Set-Content -Path $file.FullName -Encoding UTF8
                Write-Host "Updated $($file.Name)"
            }
            else {
                Write-Host "Skipping $($file.Name) (no change needed)"
            }
        }
        else {
            Write-Host "Pattern not found in $($file.Name)"
        }
    }
}

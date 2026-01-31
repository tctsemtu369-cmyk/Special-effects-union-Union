$files = @(
    "c:\Users\USER\OneDrive\Desktop\tctsemtu site\konda.html",
    "c:\Users\USER\OneDrive\Desktop\tctsemtu site\srinivas.html",
    "c:\Users\USER\OneDrive\Desktop\tctsemtu site\aravindh.html",
    "c:\Users\USER\OneDrive\Desktop\tctsemtu site\sanjeev.html",
    "c:\Users\USER\OneDrive\Desktop\tctsemtu site\suresh_babu.html",
    "c:\Users\USER\OneDrive\Desktop\tctsemtu site\murtuza_kamal.html",
    "c:\Users\USER\OneDrive\Desktop\tctsemtu site\veerandranath.html",
    "c:\Users\USER\OneDrive\Desktop\tctsemtu site\b_balakrishna.html",
    "c:\Users\USER\OneDrive\Desktop\tctsemtu site\j_suresh.html",
    "c:\Users\USER\OneDrive\Desktop\tctsemtu site\paramesh.html",
    "c:\Users\USER\OneDrive\Desktop\tctsemtu site\rajendra_prasad.html",
    "c:\Users\USER\OneDrive\Desktop\tctsemtu site\srinivasa_rao.html",
    "c:\Users\USER\OneDrive\Desktop\tctsemtu site\naveen_kumar.html",
    "c:\Users\USER\OneDrive\Desktop\tctsemtu site\sai_babu.html",
    "c:\Users\USER\OneDrive\Desktop\tctsemtu site\pavan.html",
    "c:\Users\USER\OneDrive\Desktop\tctsemtu site\santhosh.html",
    "c:\Users\USER\OneDrive\Desktop\tctsemtu site\suresh_kumar.html",
    "c:\Users\USER\OneDrive\Desktop\tctsemtu site\chandra_mohan.html"
)

$newSkills = @"
                                                <ul style="margin: 0; padding-left: 20px;">
                                                    <li>Pyrotechnics & Fire Effects</li>
                                                    <li>Atmospheric Effects (Fog, Wind)</li>
                                                    <li>Mechanical Rigs & Engineering</li>
                                                    <li>Safety Protocols</li>
                                                </ul>
"@

foreach ($file in $files) {
    if (Test-Path $file) {
        try {
            $content = Get-Content -Path $file -Raw -Encoding UTF8
            
            # Pattern: locate "Professional Skills", then the next <td> containing the list
            # We want to replace the content of that <td>...</td> 
            # or specifically the <ul>...</ul> inside it
            
            # Regex Explanation:
            # Professional Skills\s*</td>       -> Matches label cell end
            # \s*<td[^>]*>:\s*</td>             -> Matches separator cell (: cell)
            # \s*<td[^>]*>\s*                   -> Matches start of content cell
            # (<ul.*?</ul>)                     -> Matches the unordered list (Target Group 1)
            
            # However, simpler might be to just find the row with "Professional Skills" and replace the whole UL block inside it.
            
            $pattern = '(?s)(Professional Skills\s*</td>\s*<td[^>]*>:\s*</td>\s*<td[^>]*>\s*)<ul.*?>.*?</ul>'
            
            if ($content -match $pattern) {
                # We want to keep the prefix (Group 1) and replace the rest with $newSkills
                
                # PowerShell -replace operator uses regex substitution.
                # $1 refers to capture group 1.
                
                $newContent = $content -replace $pattern, ('${1}' + $newSkills)
                
                Set-Content -Path $file -Value $newContent -Encoding UTF8
                Write-Host "Updated $file"
            }
            else {
                Write-Host "Pattern not found in $file"
            }
        }
        catch {
            Write-Host "Error processing $file : $_"
        }
    }
    else {
        Write-Host "File not found: $file"
    }
}

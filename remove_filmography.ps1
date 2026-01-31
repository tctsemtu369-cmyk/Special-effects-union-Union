$files = @(
    "c:\Users\USER\OneDrive\Desktop\tctsemtu site\prakash.html",
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

foreach ($file in $files) {
    if (Test-Path $file) {
        try {
            $content = Get-Content -Path $file -Raw -Encoding UTF8
            
            # Using regex to find and remove the Filmography TR block
            # (?s) enables dot-matches-newline
            # We look for <tr....Filmography....</tr> inclusive
            $pattern = '(?s)\s*<tr>\s*<td[^>]*>\s*Filmography.*?</tr>'
            
            if ($content -match $pattern) {
                $newContent = $content -replace $pattern, ''
                Set-Content -Path $file -Value $newContent -Encoding UTF8
                Write-Host "Processed $file"
            } else {
                Write-Host "Filmography not found in $file"
            }
        } catch {
            Write-Host "Error processing $file : $_"
        }
    } else {
        Write-Host "File not found: $file"
    }
}

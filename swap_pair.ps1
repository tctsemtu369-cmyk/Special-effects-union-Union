param (
    [string]$id1,
    [string]$id2
)

$baseDir = "c:\Users\USER\OneDrive\Desktop\tctsemtu site"
$techFile = Join-Path $baseDir "technicians.html"

function Get-TechContent($content, $id) {
    # Regex lookahead for the two closing divs of tech-card and tech-item
    $pattern = "(?s)(<div class=`"tech-id`">$id</div>)([\s\S]*?)(?=\s*</div>\s*</div>)"
    if ($content -match $pattern) {
        return $matches[0], $matches[1], $matches[2]
    }
    return $null
}

if (-not $id1 -or -not $id2) {
    Write-Host "Usage: .\swap_pair.ps1 -id1 T-XXX -id2 T-YYY"
    exit
}

$htmlContent = Get-Content $techFile -Raw -Encoding UTF8

$match1 = Get-TechContent $htmlContent $id1
$match2 = Get-TechContent $htmlContent $id2

if ($match1 -and $match2) {
    $content1 = $match1[2]
    $content2 = $match2[2]
    
    # Replace Content of ID1 with Content2
    $p1 = "(?s)(<div class=`"tech-id`">$id1</div>)([\s\S]*?)(?=\s*</div>\s*</div>)"
    $htmlContent = $htmlContent -replace $p1, ('${1}' + $content2)
    
    # Replace Content of ID2 with Content1
    $p2 = "(?s)(<div class=`"tech-id`">$id2</div>)([\s\S]*?)(?=\s*</div>\s*</div>)"
    $htmlContent = $htmlContent -replace $p2, ('${1}' + $content1)
    
    $htmlContent | Set-Content $techFile -Encoding UTF8
    Write-Host "Swapped $id1 and $id2 in technicians.html"
    
    # Update Profile Page for what is now at ID1 (previously ID2's content, so Content2)
    # E.g. T-002 (ID1) now holds Venkateshwarlu (Content2). Update his page to say T-002.
    if ($content2 -match 'href="([^"]+)"') {
        $file = $matches[1]
        $fullPath = Join-Path $baseDir $file
        if (Test-Path $fullPath) {
            $txt = Get-Content $fullPath -Raw -Encoding UTF8
            # We replace ID2 with ID1 in this file
            if ($txt -match "Union Card No[\s\S]*?$id2") {
                $txt = $txt -replace $id2, $id1
                $txt | Set-Content $fullPath -Encoding UTF8
                Write-Host "Updated $file : $id2 -> $id1"
            }
        }
    }
    
    # Update Profile Page for what is now at ID2 (previously ID1's content, Content1)
    # E.g. T-102 (ID2) now holds Placeholder (Content1). No file usually, but check.
    if ($content1 -match 'href="([^"]+)"') {
        $file = $matches[1]
        $fullPath = Join-Path $baseDir $file
        if (Test-Path $fullPath) {
            $txt = Get-Content $fullPath -Raw -Encoding UTF8
            if ($txt -match "Union Card No[\s\S]*?$id1") {
                $txt = $txt -replace $id1, $id2
                $txt | Set-Content $fullPath -Encoding UTF8
                Write-Host "Updated $file : $id1 -> $id2"
            }
        }
    }
    
}
else {
    Write-Host "Could not find blocks for $id1 or $id2"
}

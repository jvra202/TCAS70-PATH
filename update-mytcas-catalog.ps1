$ErrorActionPreference = 'Stop'
$root = Split-Path -Parent $MyInvocation.MyCommand.Path
$catalogDir = Join-Path $root 'data'
New-Item -ItemType Directory -Path $catalogDir -Force | Out-Null
$baseUrl = 'https://my-tcas.s3.ap-southeast-1.amazonaws.com/mytcas'
$courses = Invoke-RestMethod -Uri "$baseUrl/courses.json" -TimeoutSec 30
$universities = Invoke-RestMethod -Uri "$baseUrl/universities.json" -TimeoutSec 30
$catalog = @(foreach ($university in $universities) {
    $rows = @($courses | Where-Object {
        $_.university_id -eq $university.university_id -and $_.faculty_name_th
    })
    $faculties = @(foreach ($faculty in ($rows | Group-Object faculty_name_th | Sort-Object Name)) {
        [pscustomobject]@{
            name = $faculty.Name
            branches = @($faculty.Group.field_name_th | Where-Object { $_ -and $_.Trim() } | Sort-Object -Unique)
        }
    })
    [pscustomobject]@{
        id = $university.university_id
        name = $university.university_name
        en = $university.university_name_en
        faculties = $faculties
    }
})
$updatedAt = ($courses | ForEach-Object { [datetime]$_.updated_at } | Sort-Object | Select-Object -Last 1).ToString('yyyy-MM-dd')
$payload = [pscustomobject]@{ updatedAt = $updatedAt; universities = $catalog } | ConvertTo-Json -Depth 8 -Compress
$output = Join-Path $catalogDir 'tcas70-catalog.js'
$header = "// MyTCAS public catalog snapshot. Last source update: $updatedAt. Run update-mytcas-catalog.ps1 to refresh.`n"
[IO.File]::WriteAllText($output, $header + 'window.TCAS70_CATALOG = ' + $payload + ';', [Text.UTF8Encoding]::new($false))
Write-Output "Updated $output with $($catalog.Count) universities from MyTCAS (source updated $updatedAt)."
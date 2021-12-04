$Path = Read-Host 'Folder Path  Details'
Set-Location $Path 
Get-ChildItem -Filter “*01*” -Recurse | Rename-Item -NewName {$_.name -replace ‘01’,’07’ }
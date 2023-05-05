$SharePath = "\\interlock0001\recovery\fastcopy\HR Management"

$FolderPath = Get-ChildItem -Directory -Path $SharePath -Recurse

$Output = @()

ForEach ($Folder in $FolderPath)

{

$Acl = Get-Acl -Path $Folder.FullName

$Ar = New-Object System.Security.AccessControl.FileSystemAccessRule ("MNSUK\IT SRV Prod Admin","FullControl","Allow")

$Acl.SetAccessRule($Ar)

Set-Acl -Path $Folder.FullName $Acl

}

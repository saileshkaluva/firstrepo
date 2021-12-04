$FlashArray = Read-Host 'FlashArray IP/Name'
$EndPoint = New-PfaArray -EndPoint $FlashArray -Credentials (Get-Credential) -IgnoreCertificateError
$filepath = Read-Host 'Provide the Path of csv File'
$volcreate = Import-csv $filepath
$Unit = Read-Host "Enter Capacity Unit for Creation of Volumes"
while("G","H","HG","T" -notcontains $Unit )
{
 $Unit = Read-Host "Not a Valid Unit G,K,M,T Only"
}
$Volumes = @()
foreach ($autovol in $volcreate)
{
	$VolName = $autovol.VolName
	$VolSize = $autovol.VolSize
	New-PfaVolume -Array $EndPoint -VolumeName "$VolName" -Unit $Unit -Size $VolSize
	$Volumes += "$VolName"
}
$Volumes -join ","
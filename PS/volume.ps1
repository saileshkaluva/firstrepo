$FlashArray = Read-Host 'FlashArray IP/Name'
$EndPoint = New-PfaArray -EndPoint $FlashArray -Credentials (Get-Credential) -IgnoreCertificateError
$filepath = Read-Host 'Provide the Path of csv File'
$volcreate = Import-csv $filepath
Do { $Unit = Read-Host "Enter Capacity Unit for Creation of Volumes" } While ($Unit -notmatch "K|M|G|T|P")

$Volumes = @()
foreach ($autovol in $volcreate)
{
	$VolName = $autovol.VolName
	$VolSize = $autovol.VolSize
	New-PfaVolume -Array $EndPoint -VolumeName "$VolName" -Unit $Unit -Size $VolSize
	$Volumes += "$VolName"
}
$Volumes -join ","

Do { $AssignPaths = Read-Host "Assign to Path to Volumes (Y/N)" } While ($AssignPaths -notmatch "Y|N")
if ($AssignPaths.ToUpper() -eq 'Y') 
{
		Do { $AssignHost = Read-Host "Assign to Volumes to Hosts or HostGroup (H/HG)" } While ($AssignHost -notmatch "H|HG")
		if ($AssignHost.ToUpper() -eq 'HG')
		{
			$HostGroup = Read-Host 'Provide HostGroup Name'
			$Vols = $Volumes.split(",");
			foreach($MapVol in $Vols)
			{
				New-PfaHostGroupVolumeConnection -Array $EndPoint -VolumeName $MapVol -HostGroupName $HostGroup
			}
		}		
		else
		{
			$Hostss = Read-Host 'Provide Host Name'
			$Vols = $Volumes.split(",");
			foreach($MapVol in $Vols)
			{
				New-PfaHostVolumeConnection -Array $EndPoint -VolumeName $MapVol -HostName $Hostss
			}

		}
	}
	
else 
{
    Write-Warning 'Volumes not Assigned to any Host.'
} 

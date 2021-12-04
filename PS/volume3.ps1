[int]$selection = 0
while ($selection-lt 1 -or $selection-gt 5)
{
	Write-Host "1. Connect to FlashArray 1"
	write-host "2. Connect to FlashArray 2"
	Write-Host "3. do stuff"
	write-host "4. Clear Screen"
	write-host "5. Exit"

	[int]$selection= read-host "Choose one FlashArray"
	switch ($selection) 
	{
		1{$FlashArray = '10.23.10.20'}
		2{$FlashArray = '10.23.10.30'}
		3{dostuff}
		4{cls}
		5{exit}
	}
}
[int]$selection2 = 0
while ($selection2-lt 1 -or $selection2-gt 5)
{
	Write-Host "1. Create Volumes from CSV"
	write-host "2. Create Volumes of Same Size"
	Write-Host "3. do stuff"
	write-host "4. Clear Screen"
	write-host "5. Exit"

	[int]$selection2= read-host "choose one option"
	switch ($selection2) 
	{
		1
		{
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
		}
		2
		{
			$EndPoint = New-PfaArray -EndPoint $FlashArray -Credentials (Get-Credential) -IgnoreCertificateError
			$CustomerPrefix = Read-Host 'Customer Prefix'
			Do { $Unit = Read-Host "Enter Capacity Unit for Creation of Volumes" } While ($Unit -notmatch "K|M|G|T|P")
			Do { $VolumeSize = Read-Host "Volume Size in ($Unit)" } While ($VolumeSize -notmatch "^[1-9]+$")
			Do { $NumberOfVolumes = Read-Host "Number of Volumes to Create" } While ($NumberOfVolumes -notmatch "^[1-9]+$")

			$Volumes = @()
			for($i = 1; $i -le $NumberOfVolumes; $i++)
			{
				New-PfaVolume -Array $EndPoint -VolumeName "$CustomerPrefix-Vol$i" -Unit $Unit -Size $VolumeSize
				$Volumes += "$CustomerPrefix-Vol$i"
			}
			$Volumes -join ","

			$AssigntoCustomerPGroup = Read-Host "Assign to $CustomerPrefix-PGroup (Y/N)"
			if ($AssigntoCustomerPGroup.ToUpper() -eq 'Y') 
			{
				New-PfaProtectionGroup -Array $EndPoint -Name "$CustomerPrefix-PGroup" -Volumes $Volumes
			}
			else 
			{	
				Write-Warning 'No Protection Group created.'
			} 
		}
		3
		{
			Echo 3
		}
		4
		{
			cls
		}
		5
		{
			exit
		}
	}
}


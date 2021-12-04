$Unit = Read-Host "Enter Capacity Unit for Creation of Volumes"
while("G","H","HG","T" -notcontains $Unit )
{
 $Unit = Read-Host "Not a Valid Unit G,K,M,T Only"
}
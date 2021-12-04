$path = "D:\PS\fakepeople.xlsx"

$people = new-object System.Collections.ArrayList

foreach ($person in (Import-Excel -Path $path))

{

$people.add($person) | out-null #I don't want to see the output

}

$outtt=$people.company | select -Unique 

foreach ($autovol in $outtt)
{
    echo "Hi This $autovol"
}
$people[2].Name
$people[96].company
$testcsv = Import-csv D:\TeST.csv
  
 
  
 foreach($test in $testcsv)
  
   {
  
   $field1 = $test.COMPUTER
  
   $field2 = $test.LOCAL
  
   $field3 = $test.DOMAIN
  
   Echo "$field1, $field2, $field3"
  
   }
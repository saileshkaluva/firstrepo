
        [int]$selection = 0
        while ($selection-lt 1 -or $selection-gt 5)
		{
            Write-Host "1. Search"
            write-host "2. Change"
            Write-Host "3. do stuff"
            write-host "4. Clear Screen"
            write-host "5. Exit"

            [int]$selection= read-host "choose one option"
            switch ($selection) {
                1{Echo find}
                2{change}
                3{dostuff}
                4{cls}
                5{exit}
            }
}
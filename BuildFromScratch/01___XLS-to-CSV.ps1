#
# Modified from example script posted by Rich Matheisen, on Oct. 20, 2021:
# https://learn.microsoft.com/en-us/answers/questions/597931/convert-xlsx-to-csv-using-powershell
#
$Excel = New-Object -ComObject Excel.Application
Function ExcelToCsv ($File) {
    $wb = $Excel.Workbooks.Open($File, $null, $true)

    $x = $File | Select-Object Directory, BaseName
    $n = [System.IO.Path]::Combine($x.Directory, (($x.BaseName, 'csv') -join "."))

    $i = 0
    foreach ($ws in $wb.Worksheets) {
        while (Test-Path $n) {#File Existence Check
            $i++
            $n = [System.IO.Path]::Combine($x.Directory, (("$($x.BaseName)_$($i)", 'csv') -join "."))
        }
        $ws.SaveAs($n, 6)
    }
    $wb.close($false)
}

Get-ChildItem orig_excel_from_FBI\orig_excel_from_FBI\*.xls |
    ForEach-Object{
        ExcelToCsv -File $_
    }
$Excel.Quit()
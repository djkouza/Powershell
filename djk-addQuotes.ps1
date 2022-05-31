############################
#   Script to add quotes and comma to list of items
#   Author: DJKouza
#   Contact:  https://twitter.com/djkouza
#   Version: 1.0.0
#   Set-ExecutionPolicy -ExecutionPolicy Unrestricted
############################
$inputFile = "c:\yourdirectory\yourfile.txt"
$inputFile = "C:\temp\_Crypto\___script\test.txt"
$outputFile = "c:\yourdirectory\yourfileOut.txt"
$outputFile = "C:\temp\_Crypto\___script\testout.txt"
$fileData = get-content -Path $inputFile
$dataOut=@()
$lineCount = $fileData.Count
$line=1
foreach ($thisLine in $fileData)
    {
    if($line -lt $lineCount)
        {
        $newLine = '"'+$thisLine+'",'
        }
    else
        {
        $newLine = '"'+$thisLine+'"'
        }
    $dataOut += $newLine
    $line++
    }
$dataOut | Out-File -FilePath $outputFile
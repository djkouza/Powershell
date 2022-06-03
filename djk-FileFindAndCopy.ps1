############################
#   Script to 
#   Author: DJKouza
#   Contact:  https://twitter.com/djkouza
#   Version: 1.0.0
#   Set-ExecutionPolicy -ExecutionPolicy Unrestricted
############################

$srcDir = Read-Host "Input directory root to search for files: "
$destDir = $srcDir+"\output\"
if (Test-Path -Path $destDir) 
    {
    #"Path exists!"
    } 
else 
    {
    New-Item -Path $destDir -ItemType Directory
    }

$inputList = Read-Host "Input location of the list of files to search for: "
$fileList = Get-Content $inputList


foreach($item in $fileList)
    {
    $nameToFind = [string]$item+".png"
    $fileFound = Get-ChildItem $srcDir -Recurse | Where-Object { !($_.PSIsContainer) -and $_.Name.Equals($nameToFind)}
    $fileDirecroty = $fileFound.DirectoryName
    $fileFullPath = $fileDirecroty+"\"+$nameToFind
    Copy-Item $fileFullPath -Container -Recurs -Destination $destDir
    }

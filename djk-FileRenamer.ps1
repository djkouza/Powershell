############################
#   File Rename Script
#   Author: DJKouza
#   Contact:  https://twitter.com/djkouza
#   Version: 1.0.0
#   
############################

$srcDir = Read-Host "Input directory that holds images to rename: "

$fileList = Get-ChildItem $srcDir
$imageCount = $fileList.Count
$currImage = 1
Write-Host "Preparing to process files"
$destDir = "$srcDir\renamed\"

if (Test-Path -Path $destDir) {
    "Path exists!"
} else {
    New-Item -Path $destDir -ItemType Directory
}

foreach($file in $fileList)
    {
    $mode = $file.mode
    if($mode -eq "d-----")
        {
        #Write-Host "directory.. continue"
        #don't copy directories just move one
        continue
        }
    $currFileName = $file.Name
    $dotLocation = $currFileName.IndexOf(".")
    $fileExtension = $currFileName.SubString($dotLocation)
    $newFileName = [string]$currImage + $fileExtension
    #Write-Host "new name $newFileName"
    Copy-Item $srcDir\$currFileName -Destination $destDir\$newFileName
    $currImage++
    }

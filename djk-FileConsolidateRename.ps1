############################
#   Script to find _metadata.json files and rename/move to a central folder
#   Author: DJKouza
#   Contact:  https://twitter.com/djkouza
#   Version: 1.0.0
#   Set-ExecutionPolicy -ExecutionPolicy Unrestricted
############################

$srcDir = Read-Host "Input directory root to search for files: "
$destDir = Read-Host "Input DESTINATION directory for copied files: "
$NameToFind = Read-Host "Input folder name to search for: "
$fileList = Get-ChildItem $srcDir -Recurse | Where-Object { !($_.PSIsContainer) -and $_.Name.Equals($NameToFind)}


$fileCount = $fileList.Count
$currCounter = 1
Write-Host "Preparing to process items"

if (Test-Path -Path $destDir) {
    #"Path exists!"
} else {
    New-Item -Path $destDir -ItemType Directory
}

foreach($item in $fileList)
    {
    Write-Progress -activity "Processing . ." -status "Item: $currCounter of $($fileCount)" -percentComplete (($currCounter / $fileCount)  * 100)
    $currFile = $item.FullName
    $newFile = $NameToFind + [string]$currCounter
    Copy-Item $currFile -Container -Recurse -Destination $destDir\$newFile
    $currCounter++
    }
############################
#   Script to find json folders and rename/move to a central folder
#   Author: DJKouza
#   Contact:  https://twitter.com/djkouza
#   Version: 1.0.0
#   Set-ExecutionPolicy -ExecutionPolicy Unrestricted
############################

$srcDir = Read-Host "Input directory root to search for JSON Folders: "
$destDir = Read-Host "Input DESTINATION directory for copied folders: "
$NameToFind = Read-Host "Input folder name to search for: "
$dirList = Get-ChildItem $srcDir -Recurse | Where-Object { $_.PSIsContainer -and $_.Name.Equals($NameToFind)}


$dirCount = $dirList.Count
$currCounter = 1
Write-Host "Preparing to process items"

if (Test-Path -Path $destDir) {
    #"Path exists!"
} else {
    New-Item -Path $destDir -ItemType Directory
}

foreach($item in $dirList)
    {
    
    $currFolder = $item.FullName
    $newFolder = $NameToFind + [string]$currCounter
    Copy-Item $currFolder -Container -Recurse -Destination $destDir\$newFolder
    $currCounter++
    }
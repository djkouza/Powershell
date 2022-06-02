############################
#   JSON Attribute Incrementer (Ded Teddiez Specific Config)
#   Author: DJKouza
#   Contact:  https://twitter.com/djkouza
#   Version: 1.0.0
#   Set-ExecutionPolicy -ExecutionPolicy Unrestricted
############################
$srcDir = Read-Host "Input directory of orig _metadata.json "
$attribToUpdate = "name"
$fileIn="_metadata.json"
$fileOut=$srcDir+"\"+"_metadataFixed.json"
$fullPath = $srcDir + "\" + $fileIn
$JsonData = Get-Content -Raw -Path $fullPath |ConvertFrom-Json
$attributes = $jsondata[0].attributes
$attributesCount = $attributes.count
####  PLEASE UPDATE THE COLLECTION SIZE 
####  Note: if the collection size does not accurately match the count 
$collectionSize=6
####  PLEASE UPDATE THE COLLECTION SIZE
if($collectionSize -ne $attributesCount)
    {
    Write-Host "Detected JSON Attributes: $AttributesCount, Collection Size entered: $CollectionSize"
    Write-Host "Shiz be broke.. are you sure that your source JSON has the correct number of entries to match your Collection size?"
    exit 0
    }
$maxCount = $collectionSize +1
$idsToUse=@()
##Generate the Array with every possible ID
for( $i = 1;$i -lt $maxCount; $i++)
    {
$idsToUse += [int]$i
    }
###Ranomize the ID's
$rndIds = $idsToUse | Get-Random -Count $maxCount
$count=0
foreach($attribute in $attributes)
    {
    $rndNumber = $rndIds[$count]
    $NewName = "Ded Teddiez Remix "+$rndNumber
    $attribute.name = $NewName
    $thisImage = $attribute.image
    $newImage = $thisImage+[string]$rndNumber+".png"
    $attribute.image = $newImage
    $count++
    }

$JsonData | ConvertTo-Json | Out-File $fileOut

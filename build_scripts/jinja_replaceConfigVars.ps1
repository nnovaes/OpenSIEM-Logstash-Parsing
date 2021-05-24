cd ../config/processors
$file_list = gci | Select-Object -Property Name
foreach ($file in $file_list)
{
    $newvar = '"'+($file.Name -replace ".conf","")+'"'
    (Get-Content $file.Name) -replace "VAR_PIPELINE_NAME",$newvar | Set-Content -Path $file.Name
}
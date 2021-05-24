
Write-Host "collecting settings" (gci ./settings.json)
$json = Get-Content -Path ./settings.json | ConvertFrom-Json

$topics = $json | gm | Where-Object {$_.MemberType -match "NoteProperty"} | Select-Object -Property Name | Sort-Object -Descending -Property Name



Write-Host "finished import, end up with " $topics.count "topics"
$myJson = $null
$myJson += "[ `n"

foreach ($topic in $topics)
{
    $defs = $json.($topic.Name)
    $myJson += $defs | ConvertTo-Json
    if ($topics.IndexOf($topic) -lt $topics.Count-1)
    {
        $myJson += ", `n"
    }
    else
    {
    $myJson += "`n"
    }
}

$myJson += "`n ]"

$myJson | Set-Content -Path ./temp_prejq.json


$prejq = $myJson | ConvertFrom-Json

$pipelines =  New-Object Collections.Generic.List[String]

$prejqPipelines = New-Object Collections.Generic.List[PSObject]

for ($i=0; $i -lt $prejq.Length; $i++)
{
    if ($pipelines.Contains($prejq[$i].config))
    {
    Write-Host "skipping" $prejq[$i].config "<=" $prejq[$i].log_source
    }
    else {
    $prejqPipelines.Add($prejq[$i])
    $pipelines.Add($prejq[$i].config)
    Write-Host "adding" $prejq[$i].config "<=" $prejq[$i].log_source
    }
}



$prejqPipelines | ConvertTo-Json | Set-Content -Path ./temp_prejq_pipelines.json
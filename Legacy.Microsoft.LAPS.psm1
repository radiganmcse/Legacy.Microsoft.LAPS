# Get the path to the function files
$functionpath = $PSScriptRoot + "\function\"

# Get a list of all the funcion file names
$functionlist = Get-ChildItem -Path $functionpath -Name

# Loop all the files and dot source them into memeory
foreach ($function in $functionlist)
{
    . ($functionpath + $function)
}
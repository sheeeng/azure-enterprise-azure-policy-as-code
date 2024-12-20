New-Item .\Module\EnterprisePolicyAsCode\internal\functions -ItemType Directory -Force
New-Item .\Module\EnterprisePolicyAsCode\functions -ItemType Directory -Force

Get-ChildItem -Path .\Scripts\Helpers\*.ps1 -Recurse -File -Exclude Add-HelperScripts.ps1 | Copy-Item -Destination .\Module\EnterprisePolicyAsCode\internal\functions

# Deploy Functions

$functionNames = (Get-ChildItem .\Scripts\Deploy\* -File -Include *.ps1).BaseName

$functionNames | Foreach-Object {
    "function $_ {" | Set-Content ".\Module\EnterprisePolicyAsCode\functions\$_.ps1" -Force
    Get-Content .\Scripts\Deploy\$_.ps1 | Where-Object { $_ -notmatch "^\." -and $_ -notmatch "^#Requires" } | Add-Content ".\Module\EnterprisePolicyAsCode\functions\$_.ps1" -Force
    "}" | Add-Content ".\Module\EnterprisePolicyAsCode\functions\$_.ps1" -Force
}

# Operations

$functionNames = (Get-ChildItem .\Scripts\Operations\* -File -Include *.ps1).BaseName

$functionNames | Foreach-Object {
    "function $_ {" | Set-Content ".\Module\EnterprisePolicyAsCode\functions\$_.ps1" -Force
    Get-Content .\Scripts\Operations\$_.ps1 | Where-Object { $_ -notmatch "^\." -and $_ -notmatch "^#Requires" } | Add-Content ".\Module\EnterprisePolicyAsCode\functions\$_.ps1" -Force
    "}" | Add-Content ".\Module\EnterprisePolicyAsCode\functions\$_.ps1" -Force
}

# Cloud Adoption Framework

$functionNames = (Get-ChildItem .\Scripts\CloudAdoptionFramework\* -File -Include *.ps1).BaseName

$functionNames | Foreach-Object {
    "function $_ {" | Set-Content ".\Module\EnterprisePolicyAsCode\functions\$_.ps1" -Force
    Get-Content .\Scripts\CloudAdoptionFramework\$_.ps1 | Where-Object { $_ -notmatch "^\." -and $_ -notmatch "^#Requires" } | Add-Content ".\Module\EnterprisePolicyAsCode\functions\$_.ps1" -Force
    "}" | Add-Content ".\Module\EnterprisePolicyAsCode\functions\$_.ps1" -Force
}

# Hydration Kit

Get-ChildItem -Path .\Scripts\HydrationKit\*.ps1 -Recurse -File | Copy-Item -Destination .\Module\EnterprisePolicyAsCode\functions

# $functionNames = (Get-ChildItem .\Scripts\HydrationKit\* -File -Include *.ps1).BaseName

# $functionNames | Foreach-Object {
#     "function $_ {" | Set-Content ".\Module\EnterprisePolicyAsCode\functions\$_.ps1" -Force
#     Get-Content .\Scripts\HydrationKit\$_.ps1 | Where-Object { $_ -notmatch "^#Requires" } | Add-Content ".\Module\EnterprisePolicyAsCode\functions\$_.ps1" -Force
#     "}" | Add-Content ".\Module\EnterprisePolicyAsCode\functions\$_.ps1" -Force
# }



Copy-Item -Path .\Scripts\CloudAdoptionFramework\policyAssignments -Destination .\Module\EnterprisePolicyAsCode -Force -Recurse

(Get-Content -Path .\Module\EnterprisePolicyAsCode\EnterprisePolicyAsCode.psd1) -replace "FunctionsToExport = ''", "FunctionsToExport = @($((Get-ChildItem -Path .\Module\EnterprisePolicyAsCode\functions | Select-Object -ExpandProperty BaseName) | Join-String -Separator "," -DoubleQuote))" | Set-Content .\Module\EnterprisePolicyAsCode\EnterprisePolicyAsCode.psd1

$tag_name = $env:TAG_NAME -replace "v", ""

(Get-Content -Path .\Module\EnterprisePolicyAsCode\EnterprisePolicyAsCode.psd1) -replace "ModuleVersion     = ''", "ModuleVersion     = '$tag_name'" | Set-Content .\Module\EnterprisePolicyAsCode\EnterprisePolicyAsCode.psd1

[CmdletBinding()]

$profilesInfo = (netsh wlan show profiles | Select-String -Pattern 'All User Profile') -Split "`n"
$profilesList = [System.Collections.ArrayList]@()
$resultsList = [System.Collections.ArrayList]@()

foreach ($profile in $profilesInfo) {
    [void]$profilesList.Add($profile.split(':')[1].trim())
}

foreach ($profile in $profilesList) {
    try {
        $currentProfileInfo = (netsh wlan show profiles name="$profile" key=clear | Select-String -Pattern 'Key Content').ToString().split(':')[1].trim()
    }
    catch {
        $currentProfileInfo = 'blank password'
    }

    [void]$resultsList.Add(
        [PSCustomObject]@{
            Profile = $profile
            Password = $currentProfileInfo
        }
    )
}

$resultsList

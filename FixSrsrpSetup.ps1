#SRSRPINSTALLDIR=F:\SMS_SRSRP SRSRPLANGPACKFLAGS=1 CURRENTDIRECTORY=F:\SMS\bin\x64 CLIENTUILEVEL=3 MSICLIENTUSESEXTERNALUI=1 CLIENTPROCESSID=9792 

#Copy the content of the installation folder of the msi to the target folder of srsrpsetupexe and rename ist to SMS_SRSRPtemp 
$temp = "f:\SMS_SRSRPtemp"
#Enter the name of the folder that the msi installs to 
#In srsrpmsi.log search for "Modifying TARGETDIR property."
#Delete or rename the target folder of the msi 
$msiInstFolder = "g:\SMS_SRSRP"

$logFile = "d:\Logs\rename_log.log"

#------------------ Begin Functions ------------------------------------
function Log([string]$ContentLog) 
{
    Write-Host "$(Get-Date -Format "dd.MM.yyyy HH:mm:ss,ff") $($ContentLog)"
    Add-Content -Path $logFile -Value "$(Get-Date -Format "dd.MM.yyyy HH:mm:ss,ff") $($ContentLog)"
}

Log ("Script starting: " + $currentTime)
$i=0
while ($true) {
    $currentTime = Get-Date    
    $formattedTime = $currentTime.ToString("HH:mm:ss")

    if (Test-Path($msiInstFolder)) {
        try {
            Rename-Item -Path $temp -NewName "SMS_SRSRP" -ErrorAction Stop

            $logMessage = "Folder renamed at $($currentTime.ToString('yyyy-MM-dd HH:mm:ss'))"
            Log $logMessage
            
            break  # Break out of the loop once the folder is renamed
        }
        catch {
            $errorMessage = "Error renaming folder: $_"
            Log $errorMessage
        }
    }

    $i++
    if(($i%120) -eq 0){write-host "."}

    Start-Sleep -Seconds 1
}

Log "Script ending"
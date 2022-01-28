# Init Config
try {
    # WinSCP .NET
    try {
        Add-Type -Path "C:\Program Files (x86)\WinSCP\WinSCPnet.dll"
    }
    catch {
        Add-Type -Path "$($env:LOCALAPPDATA)\Programs\WinSCP\WinSCPnet.dll"
    }

    $hostName = Read-Host "IP Address or Hostname" 
    $username = Read-Host "Username"
    $password = Read-Host "Password"

    
    $sessionOptions = New-Object WinSCP.SessionOptions -Property @{  
        Protocol = [WinSCP.Protocol]::sftp
        HostName = $hostName
        UserName = $username
        Password = $password
        #sshHostKeyFingerprint = $hostKey
    }

    $sessionOptions.GiveUpSecurityAndAcceptAnySshHostKey = $true

    $session = New-Object WinSCP.Session

# File Path
$sourcePath = Read-Host "Enter Local Directory Path (eg. C:\Windows\)"
$remotePath = Read-Host "Enter Remote Directory Path (eg. /mnt/sftp/)"

# Connect to Remote
    try {
        # Log File
        $session.DebugLogPath = "$($env:LOCALAPPDATA)\winscp_sftp.log"

        # Open Session
        $session.Open($sessionOptions)

        $transferOptions = New-Object WinSCP.TransferOptions
        $transferOptions.TransferMode = [WinSCP.TransferMode]::Binary

        $session.PutFiles("$sourcePath", "$remotePath", $False, $transferOptions)
    } finally {
        $session.Dispose()
    }

} catch {
    Write-Host "Error: $($_.Exception.Message)"
    exit 10
}
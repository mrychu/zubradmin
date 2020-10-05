Add-Type -AssemblyName System.Windows.Forms

$Location = Get-Location

$MainWindow = New-Object system.Windows.Forms.Form
$MainWindow.text = "Żubradmin"
$MainWindow.Width = 640
$MainWindow.Height = 480
$MainWindow.FormBorderStyle = 'FixedDialog'


$SSHWindow = New-Object system.Windows.Forms.Form
$SSHWindow.text = "Żubradmin - SSH"

$ButtonTasker = New-Object System.Windows.Forms.Button
$ButtonTasker.Text = "Tasker"
$ButtonTasker.Location = New-Object System.Drawing.Point(30,30)
$ButtonTasker.Add_Click(
{
    $execute = "$PSScriptRoot\Zubradmin-Tasker.ps1"
    Write-Host $execute
    & ($execute)
})

$ButtonSSHExtern = New-Object System.Windows.Forms.Button
$ButtonSSHExtern.Text = "SSH"
$ButtonSSHExtern.Location = New-Object System.Drawing.Point(30,60)
$ButtonSSHExtern.Add_Click(
{
    #Invoke-Expression (start powershell ((Split-Path $MyInvocation.InvocationName) + "\Zubradmin-SSH.ps1"))
    $execute = "$PSScriptRoot\Zubradmin-SSH.ps1"
    Write-Host $execute
    & ($execute)
})


$ButtonSSHConnect = New-Object System.Windows.Forms.Button
$ButtonSSHConnect.Text = "Połącz"
$ButtonSSHConnect.Add_Click(
{
     & "C:\Program Files\PuTTY\putty.exe" "-ssh", "srvadmin@192.168.28.102", "-pw", "acbsCruiser5599"
})


$ButtonCloseApp = New-Object System.Windows.Forms.Button
$ButtonCloseApp.text = "Zakończ"
$ButtonCloseApp.Location = New-Object System.Drawing.Point(30,410)
$ButtonCloseApp.Add_Click(
{
    $MainWindow.Close()
})

$MainWindow.Controls.AddRange(@($ButtonCloseApp,$ButtonSSHExtern, $ButtonTasker))

# Display the form
[void]$MainWindow.ShowDialog()

Add-Type -AssemblyName System.Windows.Forms

$MainWindow = New-Object system.Windows.Forms.Form
$MainWindow.text = "Żubradmin"
$MainWindow.Width = 640
$MainWindow.Height = 480
$MainWindow.FormBorderStyle = 'FixedDialog'


$SSHWindow = New-Object system.Windows.Forms.Form
$SSHWindow.text = "Żubradmin - SSH"

$ButtonSSH = New-Object System.Windows.Forms.Button
$ButtonSSH.Text = "SSH"
$ButtonSSH.Location = New-Object System.Drawing.Point(30,30)
$ButtonSSH.Add_Click(
{
    $SSHWindow.Controls.AddRange(@($ButtonSSHConnect))
    [void]$SSHWindow.ShowDialog()
})

$ButtonSSHExtern = New-Object System.Windows.Forms.Button
$ButtonSSHExtern.Text = "SSH Extern"
$ButtonSSHExtern.Location = New-Object System.Drawing.Point(30,60)
$ButtonSSHExtern.Add_Click(
{
    #Invoke-Expression (start powershell ((Split-Path $MyInvocation.InvocationName) + "\Zubradmin-SSH.ps1"))
    & C:\Users\MRychlik\Desktop\Zubradmin-SSH.ps1
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


$MainWindow.Controls.AddRange(@($ButtonSSH,$ButtonCloseApp,$ButtonSSHExtern))

# Display the form
[void]$MainWindow.ShowDialog()

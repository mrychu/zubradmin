###Odczyt z pliku JSON###
$content = Get-Content ".\SSHClients.json" -Raw
$JsonParameters = ConvertFrom-Json -InputObject $content
###Elementy###
###Etykieta###
$LabelSSH = New-Object System.Windows.Forms.Label
$LabelSSH.Text = "Wybierz Hosta"
$LabelSSH.Location = New-Object System.Drawing.Point(20,20)
###Przycisk Połącz###
$ButtonSSHConnect = New-Object System.Windows.Forms.Button
$ButtonSSHConnect.Text = "Połącz"
$ButtonSSHConnect.Location = New-Object System.Drawing.Point(20,80)
$ButtonSSHConnect.Add_Click(
{
    $x = $DropListClient.SelectedItem
    $x

    $darts = $JsonParameters.Clients | where { $_.Name -eq $x } #Darts
    $login = "srvadmin@" + $darts.IP
     & "C:\Program Files\PuTTY\putty.exe" "-ssh", $login, "-pw", "acbsCruiser5599"
})
###Przycisk Edytuj###
$ButtonSSHEdit = New-Object System.Windows.Forms.Button
$ButtonSSHEdit.Text = "Edytuj"
$ButtonSSHEdit.Location = New-Object System.Drawing.Point(95,80)
$ButtonSSHEdit.Add_Click(
{
    $content.update | % {if($_.name -eq $DropListClient.SelectedItem){$_.IP=127.0.0.1}}
    $content | ConvertTo-Json -depth 32| set-content '.\SSHClients2.json'
})
###Przycisk Usuń###
$ButtonSSHDel = New-Object System.Windows.Forms.Button
$ButtonSSHDel.Text = "Usuń"
$ButtonSSHDel.Location = New-Object System.Drawing.Point(170,80)
$ButtonSSHDel.Add_Click(
{
    $content = Get-Content "$PSScriptRoot\SSHClients.json" -Raw
    $JsonParameters = ConvertFrom-Json -InputObject $content
    $toRemoveName = $DropListClient.SelectedItem
    $length_contacts = $JsonParameters.Clients.Length
    Write-Host $length_contacts
    $newjsona = @"
    {
        Clients: []
    }
"@
    $newjson = ConvertFrom-Json -InputObject $newjsona
    for ($i = 0; $i -lt $length_contacts; $i++)
    {
        if ($JsonParameters.Clients[$i].Name -ne $toRemoveName)
        {
            $host_name = $JsonParameters.Clients[$i].Name
            $host_address = $JsonParameters.Clients[$i].IP
            #$newjson = $newjson+$JsonParameters.Clients[$i]

            $newjson.Clients += [pscustomobject] @{Name = $host_name; IP = $host_address}
        }
    }
    Write-Host = $newjson.Clients
    $newjson | ConvertTo-Json -Depth 100 | Out-File "SSHClients.json"
    @($JsonParameters.Clients.Name) | ForEach-Object {[void] $DropListClient.Items.Remove($_)}
    $content = Get-Content "$PSScriptRoot\SSHClients.json" -Raw
    $JsonParameters = ConvertFrom-Json -InputObject $content
    @($JsonParameters.Clients.Name) | ForEach-Object {[void] $DropListClient.Items.Add($_)}
    ##$json_host.Clients += [pscustomobject] @{Name = $host_name; IP = $host_address}
    
})

###Przycisk Dodaj###
$ButtonSSHAdd = New-Object System.Windows.Forms.Button
$ButtonSSHAdd.Text = "Dodaj"
$ButtonSSHAdd.Location = New-Object System.Drawing.Point(20,110)
$ButtonSSHAdd.Add_Click(
{
    & .\Zubradmin-SSHAddHost.ps1
    ###Dodawanie do listy rozwijanej###
    @($JsonParameters.Clients.Name) | ForEach-Object {[void] $DropListClient.Items.Remove($_)}
    $content = Get-Content "$PSScriptRoot\SSHClients.json" -Raw
    $JsonParameters = ConvertFrom-Json -InputObject $content
    @($JsonParameters.Clients.Name) | ForEach-Object {[void] $DropListClient.Items.Add($_)}
    $DropListClient.location = New-Object System.Drawing.Point(20,50)
})

###Przycisk Wstecz###
$ButtonSSHBack = New-Object System.Windows.Forms.Button
$ButtonSSHBack.Text = "Wstecz"
$ButtonSSHBack.Location = New-Object System.Drawing.Point(20,215)
$ButtonSSHBack.Add_Click(
{
    $SSHWindow.Close()
})
###Rozwijana lista###
$DropListClient                     = New-Object system.Windows.Forms.ComboBox
$DropListClient.text                = ""
$DropListClient.width               = 225
$DropListClient.autosize            = $true





###Dodawanie do listy rozwijanej###
@($JsonParameters.Clients.Name) | ForEach-Object {[void] $DropListClient.Items.Add($_)}
$DropListClient.location = New-Object System.Drawing.Point(20,50)




$SSHWindow = New-Object system.Windows.Forms.Form
$SSHWindow.text = "Żubradmin - SSH"
$SSHWindow.Width = 270
$SSHWindow.Height = 290
$SSHWindow.FormBorderStyle = 'FixedDialog'

$SSHWindow.Controls.AddRange(@($ButtonSSHConnect,$DropListClient,$LabelSSH,$ButtonSSHEdit,$ButtonSSHDel,$ButtonSSHAdd,$ButtonSSHBack))
#[void]$SSHWindow.ShowDialog()
$result = $SSHWindow.ShowDialog()
#$result = $form.ShowDialog()





$content_host = Get-Content ".\SSHClients.json" -Raw
$json_host = ConvertFrom-Json -InputObject $content_host

$SSHWindowAddHost = New-Object system.Windows.Forms.Form
$SSHWindowAddHost.text = "Żubradmin - Dodaj Adres"
$SSHWindowAddHost.Width = 200
$SSHWindowAddHost.Height = 200
$SSHWindowAddHost.FormBorderStyle = 'FixedDialog'

$LabelName = New-Object System.Windows.Forms.Label
$LabelName.Location = New-Object System.Drawing.Point(20,20)
$LabelName.Text = "Podaj Nazwę"

$TextBoxName = New-Object System.Windows.Forms.TextBox
$TextBoxName.Location = New-Object System.Drawing.Point(20,35)

$LabelAddress = New-Object System.Windows.Forms.Label
$LabelAddress.Location = New-Object System.Drawing.Point(20,60)
$LabelAddress.Text = "Podaj adres"

$TextBoxAddress = New-Object System.Windows.Forms.TextBox
$TextBoxAddress.Location = New-Object System.Drawing.Point(20,75)

$ButtonAddHost = New-Object System.Windows.Forms.Button
$ButtonAddHost.Location = New-Object System.Drawing.Point(20,140)
$ButtonAddHost.Text = "Dodaj"
$ButtonAddHost.Add_Click(
{
    $host_name = $TextBoxName.Text
    $host_address = $TextBoxAddress.Text
    $json_host.Clients += [pscustomobject] @{Name = $host_name; IP = $host_address}
    Write-Host $json_host.Clients
    $json_host | ConvertTo-Json -Depth 100 | Out-File "SSHClients.json"
    $SSHWindowAddHost.Close()

})

$ButtonCancel = New-Object System.Windows.Forms.Button
$ButtonCancel.Location = New-Object System.Drawing.Point(100,140)
$ButtonCancel.Text = "Anuluj"
$ButtonCancel.Add_Click(
{
    $SSHWindowAddHost.Close()
})


$SSHWindowAddHost.Controls.AddRange(@($TextBoxName, $TextBoxAddress, $ButtonAddHost, $ButtonCancel, $LabelName, $LabelAddress))
$result = $SSHWindowAddHost.ShowDialog()



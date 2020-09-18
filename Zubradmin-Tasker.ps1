Add-Type -AssemblyName System.Windows.Forms

$Location = Get-Location

###Odczyt z pliku JSON###
$Tasks_file_content = Get-Content ".\Data\Tasks.json" -Raw
$Tasks_JSON = ConvertFrom-Json -InputObject $Tasks_file_content
$Tasks_amount = $Tasks_JSON.Tasks.Length


$WindowTasker = New-Object system.Windows.Forms.Form
$WindowTasker.text = "Żubradmin - Tasker"
$WindowTasker.Width = 640
$WindowTasker.Height = 480
$WindowTasker.FormBorderStyle = 'FixedDialog'




$ButtonAddTask = New-Object System.Windows.Forms.Button
$ButtonAddTask.text = "Dodaj zadanie"

$LabelMain = New-Object System.Windows.Forms.Label
$LabelMain.text = "Zadania"
$LabelMain.Location = New-Object System.Drawing.Point(30,30)

#Add flow layout panel
$FlowLayoutPanel = New-Object System.Windows.Forms.FlowLayoutPanel
$FlowLayoutPanel.FlowDirection=[System.Windows.Forms.FlowDirection]::LeftToRight
$FlowLayoutPanel.Dock=[System.Windows.Forms.DockStyle]::Right
$FlowLayoutPanel.Dock=[System.Windows.Forms.DockStyle]::Bottom
$FlowLayoutPanel.Width=600
$FlowLayoutPanel.Height=400
$FlowLayoutPanel.BorderStyle=[System.Windows.Forms.BorderStyle]::None
$WindowTasker.Controls.Add($FlowLayoutPanel)
$LocationX = 30
$LocationY = 30
$LocationAll = [string]$LocationX + "," + [string]$LocationY
for ($repeat = 0; $repeat -lt $Tasks_amount; $repeat++) {

   <#
   $Obj = New-Object System.Windows.Forms.Button
   $Obj.Width = 80
   $Obj.Height = 30
   $Obj.Text="Button$repeat" 
   $Obj.Add_Click($Button_Click)
   #>
   



   $Task = New-Label $LocationAll '627,30' 
   $ID = New-Label '0,0' '30,29' $Tasks_JSON.Tasks[$repeat].ID
   $Reporter = New-Label '30,0' '100,30' $Tasks_JSON.Tasks[$repeat].Reporter
   $Title = New-Label '130,0' '250,30' $Tasks_JSON.Tasks[$repeat].Title
   $Status = New-Label '380,0' '130,30' $Tasks_JSON.Tasks[$repeat].Status
   $ButtonOpenTask = New-Button '510,0' 'Podgląd'
   $Task.Controls.AddRange(@($ID,$Reporter,$Title,$Status,$ButtonOpenTask))
   $FlowLayoutPanel.Controls.Add($Task)
   $LocationY + $LocationY + 30
}

#$LabelTask = New-Object System.Windows.Forms.Label

function New-Label {
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$true)]
        [string]$Location,
        [Parameter(Mandatory=$true)]
        [string]$Size,
        [Parameter(Mandatory=$false)]
        [string]$Text = ''
    )

    $label = New-Object Windows.Forms.Label
    $label.Location = $Location
    $label.Size     = $Size
    $label.Text     = $Text
    $label.BorderStyle = [System.Windows.Forms.BorderStyle]::FixedSingle

    return $label
}

function New-Button {
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$true)]
        [string]$Location,
        [Parameter(Mandatory=$true)]
        [string]$Text = ''
    )

    $button = New-Object Windows.Forms.Button
    $button.Location = $Location
    $button.Text     = $Text

    return $button
}






$WindowTasker.Controls.AddRange(@($ButtonAddTask, $LabelMain))
# Display the form


$WindowTasker.ShowDialog()
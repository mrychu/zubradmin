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

#Wiersz tytułowy
$Task = New-Label-Header $LocationAll '627,30'
$ID = New-Label-Header '0,0' '30,29' "ID"
$Reporter = New-Label-Header '30,0' '100,30' "Zgłaszający"
$Title = New-Label-Header '130,0' '250,30' "Tytuł"
$Status = New-Label-Header '380,0' '130,30' "Status"
$LabelButton = New-Label-Header '510,0' '117,30'
$Task.Controls.AddRange(@($ID,$Reporter,$Title,$Status,$LabelButton))
$FlowLayoutPanel.Controls.Add($Task)

for ($repeat = 0; $repeat -lt $Tasks_amount; $repeat++) {
    $Task = New-Label $LocationAll '627,30' 
    $ID = New-Label '0,0' '30,29' $Tasks_JSON.Tasks[$repeat].ID
    $Reporter = New-Label '30,0' '100,30' $Tasks_JSON.Tasks[$repeat].Reporter
    $Title = New-Label '130,0' '250,30' $Tasks_JSON.Tasks[$repeat].Title
    $Status = New-Label '380,0' '130,30' $Tasks_JSON.Tasks[$repeat].Status
    $ButtonOpenTask = New-Button '510,0' 'Podgląd' $Tasks_JSON.Tasks[$repeat].ID $Tasks_JSON.Tasks[$repeat].Title
    
    $LocationY + $LocationY + 30
    $Tasks_JSON.Tasks[$repeat].ID
    $Task.Controls.AddRange(@($ID,$Reporter,$Title,$Status,$ButtonOpenTask))
    $FlowLayoutPanel.Controls.Add($Task)
}

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
    $label.BackColor = [System.Drawing.Color]::LightYellow

    return $label
}

function New-Label-Header {
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
    $label.BackColor = [System.Drawing.Color]::LightGreen

    return $label
}

$Button_Click = 
{
    param($sender,$eventarg)

    [System.Windows.Forms.Button] $currentbutton=$sender
    $FlowLayoutPanel = New-Object System.Windows.Forms.FlowLayoutPanel
    $FlowLayoutPanel.FlowDirection=[System.Windows.Forms.FlowDirection]::LeftToRight
    $FlowLayoutPanel.Dock=[System.Windows.Forms.DockStyle]::Right
    $FlowLayoutPanel.Dock=[System.Windows.Forms.DockStyle]::Bottom
    $FlowLayoutPanel.Width=600
    $FlowLayoutPanel.Height=400
    $FlowLayoutPanel.BorderStyle=[System.Windows.Forms.BorderStyle]::None
    $WindowTask.Controls.Add($FlowLayoutPanel)
    $WindowTask = New-Object system.Windows.Forms.Form
    $WindowTask.text = "Zubradmin - Zadanie " + $currentbutton.name
    $WindowTask.Width = 640
    $WindowTask.Height = 480
    $WindowTask.FormBorderStyle = 'FixedDialog'
    $filename = ".\Data\Task" + $currentbutton.name + ".json"
    $Task_file_content = Get-Content $filename -Raw
    $Task_JSON = ConvertFrom-Json -InputObject $Task_file_content
    #[System.Windows.Forms.MessageBox]::Show("You have click on : " +  $currentbutton.Name, "Zubradmin - Zadanie " + $currentbutton.name)
    $ID = New-Label-Header '0,0' '30,29' $Task_JSON.ID
    Write-Host $Task_JSON
    $WindowTask.ShowDialog()
}

function New-Button {
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$true)]
        [string]$Location,
        [Parameter(Mandatory=$true)]
        [string]$Text = '',
        [Parameter(Mandatory=$true)]
        [string]$ID,
        [Parameter(Mandatory=$true)]
        [string]$Title
    )
    $button = New-Object Windows.Forms.Button
    $button.Location = $Location
    $button.Text     = $Text
    $button.Name     = $ID 
    $button.Tag      = $Title
    $button.Add_Click($Button_Click)


    return $button
}






$WindowTasker.Controls.AddRange(@($ButtonAddTask, $LabelMain))
# Display the form


$WindowTasker.ShowDialog()
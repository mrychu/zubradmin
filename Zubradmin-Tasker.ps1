Add-Type -AssemblyName System.Windows.Forms

$Location = Get-Location
$Location
$PSScriptRoot
###Odczyt z pliku JSON###
$Tasks_file_content = Get-Content "$PSScriptRoot\Data\Tasks.json" -Raw
$Tasks_JSON = ConvertFrom-Json -InputObject $Tasks_file_content
$Tasks_amount = $Tasks_JSON.Tasks.Length

$Config_file_content = Get-Content "$PSScriptRoot\Data\Config.json" -Raw
$Config_JSON = ConvertFrom-Json -InputObject $Config_file_content


$WindowTasker = New-Object system.Windows.Forms.Form
$WindowTasker.text = "Żubradmin - Tasker"
$WindowTasker.Width = 820
$WindowTasker.Height = 700
$WindowTasker.FormBorderStyle = 'FixedDialog'



###Górna Belka
$ButtonAddTask = New-Object System.Windows.Forms.Button
$ButtonAddTask.text = "Dodaj zadanie"
$ButtonAddTask.Width = 100
$ButtonAddTask.location = New-Object System.Drawing.Point(20,50)
$ButtonAddTask.Add_Click({
    $DropListClient = New-Object system.Windows.Forms.ComboBox
    $DropListClient.text = ""
    $DropListClient.width = 225
    $DropListClient.autosize = $true
    
    @($Config_JSON.Reporters.Name) | ForEach-Object {[void] $DropListClient.Items.Add($_)}
    $DropListClient.location = New-Object System.Drawing.Point(20,50)
    $WindowAddTask = New-Object system.Windows.Forms.Form
    $WindowAddTask.text = "Żubradmin - Dodaj Zadanie"
    $WindowAddTask.Controls.Add($DropListClient)
    $WindowAddTask.ShowDialog()
})

$DropListReporter = New-Object system.Windows.Forms.ComboBox
$DropListReporter.text                = ""
$DropListReporter.width               = 100
$DropListReporter.autosize            = $true
$DropListReporter.location = New-Object System.Drawing.Point(130,50)

$DropListStatus = New-Object system.Windows.Forms.ComboBox
$DropListStatus.text                = ""
$DropListStatus.width               = 100
$DropListStatus.autosize            = $true
$DropListStatus.location = New-Object System.Drawing.Point(240,50)


$ButtonCalenderReport = New-Object System.Windows.Forms.Button
$ButtonCalenderReport.text = "Data zgłoszenia"
$ButtonCalenderReport.Width = 100
$ButtonCalenderReport.location = New-Object System.Drawing.Point(370,20)
$ButtonCalenderReport.Add_Click({
$TextDateReport.text = Pick-Date
})
$Calender = New-Object System.Windows.Forms.MonthCalendar
$Calender.autosize            = $true
$Calender.location = New-Object System.Drawing.Point(370,20)

$ButtonCalenderResolve = New-Object System.Windows.Forms.Button
$ButtonCalenderResolve.text = "Data rozwiązania"
$ButtonCalenderResolve.Width = 100
$ButtonCalenderResolve.location = New-Object System.Drawing.Point(500,20)
$ButtonCalenderResolve.Add_Click({
$TextDateResolve.text = Pick-Date
})

$TextDateResolve = New-Object System.Windows.Forms.TextBox
$TextDateResolve.Width = 100
$TextDateResolve.location = New-Object System.Drawing.Point(500,50)

$TextDateReport = New-Object System.Windows.Forms.TextBox
$TextDateReport.Width = 100
$TextDateReport.location = New-Object System.Drawing.Point(370,50)

$LabelReporter = New-Object System.Windows.Forms.Label
$LabelReporter.text = "Zgłaszający"
$LabelReporter.Location = New-Object System.Drawing.Point(130,30)

$LabelStatus = New-Object System.Windows.Forms.Label
$LabelStatus.text = "Status"
$LabelStatus.Location = New-Object System.Drawing.Point(240,30)

$ButtonFilter = New-Object System.Windows.Forms.Button
$ButtonFilter.text = "Filtruj"
$ButtonFilter.Width = 100
$ButtonFilter.location = New-Object System.Drawing.Point(650,50)
$ButtonFilter.Add_Click({
Show-Task
})

function Pick-Date {
    Add-Type -AssemblyName System.Windows.Forms
    Add-Type -AssemblyName System.Drawing

    $form = New-Object Windows.Forms.Form

    $form.Text = 'Select a Date'
    $form.Size = New-Object Drawing.Size @(250,300  )
    $form.StartPosition = 'CenterScreen'

    $calendar = New-Object System.Windows.Forms.MonthCalendar
    $calendar.ShowTodayCircle = $false
    $calendar.MaxSelectionCount = 1
    $form.Controls.Add($calendar)

    $OKButton = New-Object System.Windows.Forms.Button
    $OKButton.Location = New-Object System.Drawing.Point(80,200)
    $OKButton.Size = New-Object System.Drawing.Size(75,23)
    $OKButton.Text = 'OK'
    $OKButton.DialogResult = [System.Windows.Forms.DialogResult]::OK
    $form.AcceptButton = $OKButton
    $form.Controls.Add($OKButton)


    $form.Topmost = $true

    $result = $form.ShowDialog()

    if ($result -eq [System.Windows.Forms.DialogResult]::OK)
    {
        $date = $calendar.SelectionStart
        #$DeliveryDate = $($date.ToShortDateString())
        $PickedDate = $Date.ToString("yyyy-MM-dd")
        
    }
    return $PickedDate
}

function Show-Task{
    #Add flow layout panel
    $FlowLayoutPanel = New-Object System.Windows.Forms.FlowLayoutPanel
    $FlowLayoutPanel.FlowDirection=[System.Windows.Forms.FlowDirection]::LeftToRight
    $FlowLayoutPanel.Dock=[System.Windows.Forms.DockStyle]::Right
    $FlowLayoutPanel.Dock=[System.Windows.Forms.DockStyle]::Bottom
    $FlowLayoutPanel.location = New-Object System.Drawing.Point(60,50)
    $FlowLayoutPanel.Width=800
    $FlowLayoutPanel.Height=575
    $FlowLayoutPanel.BorderStyle=[System.Windows.Forms.BorderStyle]::None
    $FlowLayoutPanel.WrapContents = $true
    $FlowLayoutPanel.AutoScroll = $true
    $WindowTasker.Controls.Add($FlowLayoutPanel)
    $LocationX = 30
    $LocationY = 30
    $LocationAll = [string]$LocationX + "," + [string]$LocationY

    #Wiersz tytułowy
    $Task = New-Label-Header $LocationAll '787,30'
    $ID = New-Label-Header '0,0' '30,29' "ID"
    $Reporter = New-Label-Header '30,0' '100,30' "Zgłaszający"
    $Title = New-Label-Header '130,0' '250,30' "Tytuł"
    $Status = New-Label-Header '380,0' '100,30' "Status"
    $ReportsData = New-Label-Header '480,0' '100,30' "Data zgłoszenia"
    $ResolveData = New-Label-Header '580,0' '100,30' "Data rozwiązania"
    $LabelButton = New-Label-Header '680,0' '105,30'
    $Task.Controls.AddRange(@($ID,$Reporter,$Title,$Status,$ReportsData,$ResolveData,$LabelButton))
    $FlowLayoutPanel.Controls.Add($Task)

    for ($repeat = 0; $repeat -lt $Tasks_amount; $repeat++) {
        $Task = New-Label $LocationAll '787,30' 
        $ID = New-Label '0,0' '30,29' $Tasks_JSON.Tasks[$repeat].ID
        $Reporter = New-Label '30,0' '100,30' $Tasks_JSON.Tasks[$repeat].Reporter
        $Title = New-Label '130,0' '250,30' $Tasks_JSON.Tasks[$repeat].Title
        $Status = New-Label '380,0' '100,30' $Tasks_JSON.Tasks[$repeat].Status
        $ReportsData = New-Label '480,0' '100,30' $Tasks_JSON.Tasks[$repeat].ReportsData
        $ResolveData = New-Label '580,0' '100,30' $Tasks_JSON.Tasks[$repeat].ResolveData
        $ButtonOpenTask = New-Button '680,0' 'Podgląd' $Tasks_JSON.Tasks[$repeat].ID $Tasks_JSON.Tasks[$repeat].Title $Tasks_JSON.Tasks[$repeat].Description
    
        $LocationY + $LocationY + 30
        $Tasks_JSON.Tasks[$repeat].ID
        $Task.Controls.AddRange(@($ID,$Reporter,$Title,$Status,$ReportsData,$ResolveData,$ButtonOpenTask))
        $FlowLayoutPanel.Controls.Add($Task)
    }
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
    Write-Host $currentbutton.desc
    [System.Windows.Forms.Button] $currentbutton=$sender
    $FlowLayoutPanel = New-Object System.Windows.Forms.FlowLayoutPanel
    $FlowLayoutPanel.FlowDirection=[System.Windows.Forms.FlowDirection]::LeftToRight
    $FlowLayoutPanel.Dock=[System.Windows.Forms.DockStyle]::Right
    $FlowLayoutPanel.Dock=[System.Windows.Forms.DockStyle]::Top
    $FlowLayoutPanel.Width=600
    $FlowLayoutPanel.Height=400
    $FlowLayoutPanel.BorderStyle=[System.Windows.Forms.BorderStyle]::None

    
    
    $WindowTask = New-Object system.Windows.Forms.Form
    $WindowTask.Controls.Add($FlowLayoutPanel)
    $WindowTask.text = "Zubradmin - Zadanie " + $currentbutton.name
    $WindowTask.Width = 640
    $WindowTask.Height = 480
    $WindowTask.FormBorderStyle = 'FixedDialog'
    $Overview = New-Label-Header '0,0' '600,400'
    $Title = New-Label '0,0' '600,30' $currentbutton.Title
    $ID = New-Label '0,30' '120,30' $currentbutton.ID
    $Reporter = New-Label '120,30' '120,30' $Tasks_JSON.Tasks[$repeat].Reporter
    $Status = New-Label '240,30' '120,30' $currentbutton.desc
    $ReportsData = New-Label '360,30' '120,30' $currentbutton.desc
    $ResolveData = New-Label '480,30' '120,30' $currentbutton.desc
    $Description = New-Label '0,60' '600,90' $currentbutton.desc
    $Overview.Controls.AddRange(@($ID,$Reporter,$Title,$Status,$ReportsData,$ResolveData,$ButtonOpenTask,$Description))
    $FlowLayoutPanel.Controls.Add($Overview)
    Write-Host $currentbutton.desc
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
        [string]$Title,
        [Parameter(Mandatory=$true)]
        [string]$Desc
    )
    $button = New-Object Windows.Forms.Button
    $button.Location = $Location
    $button.Text     = $Text
    #$button.Name     = $ID 
    #$button.Tag      = $Title
    Add-Member -InputObject $button -MemberType NoteProperty -Name "Desc" -Value $Desc
    Add-Member -InputObject $button -MemberType NoteProperty -Name "ID" -Value $ID
    Add-Member -InputObject $button -MemberType NoteProperty -Name "Title" -Value $Title
    #$button.Desc     = $Description
    $button.Add_Click($Button_Click)


    return $button
}




#Show-Task

$WindowTasker.Controls.AddRange(@($ButtonAddTask, $DropListReporter, $DropListStatus, $ButtonCalenderReport,$LabelReporter,$LabelStatus,$TextDateReport,$ButtonFilter,$ButtonCalenderResolve,$TextDateResolve))
# Display the form


$WindowTasker.ShowDialog()
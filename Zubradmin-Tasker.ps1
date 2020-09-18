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
$FlowLayoutPanel.Dock=[System.Windows.Forms.DockStyle]::Fill
$FlowLayoutPanel.Width=600
$FlowLayoutPanel.BorderStyle=[System.Windows.Forms.BorderStyle]::FixedSingle
$WindowTasker.Controls.Add($FlowLayoutPanel)
$LocationX = 30
$LocationY = 30
$LocationAll = [string]$LocationX + "," + [string]$LocationY
for ($repeat = 0; $repeat -le $Tasks_amount; $repeat++) {

   <#
   $Obj = New-Object System.Windows.Forms.Button
   $Obj.Width = 80
   $Obj.Height = 30
   $Obj.Text="Button$repeat" 
   $Obj.Add_Click($Button_Click)
   #>
   



   $Obj = New-Label $LocationAll '600,30' $Tasks_JSON.Tasks[$repeat].Description
   $FlowLayoutPanel.Controls.Add($Obj)
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

    $o = New-Object Windows.Forms.Label
    $o.Location = $Location
    $o.Size     = $Size
    $o.Text     = $Text

    return $o
}






$WindowTasker.Controls.AddRange(@($ButtonAddTask, $LabelMain))
$WindowTasker.Controls.Add((New-Label '367,10' '85,20' $Tasks_JSON.Tasks[1].Description))
#$WindowTasker.Controls.Add((New-Label $LocationAll '85,20' $Tasks_JSON.Tasks[2].Description))
# Display the form


$WindowTasker.ShowDialog()
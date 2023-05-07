Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

$EVENT_NAME = "MaratonSubbeticoMozarabe2023"
$_RECORDS = @()

$_RACES = @(
	'10 - Absoluta'
	,'20 - Menores'
)

$raceData = [PSCustomObject]@{
			Id = 10
			StartAt = "07/05/2023 00:00:00.000"
}


$delimitador = ";"

############################################################
# Form
$form = New-Object System.Windows.Forms.Form
$form.Text = 'TR2 Timing'
$form.Size = New-Object System.Drawing.Size(800,800)
$form.StartPosition = 'CenterScreen'
############################################################



$outputWindow = New-Object System.Windows.Forms.TextBox 
$outputWindow.Multiline = $True;
$outputWindow.Location = New-Object System.Drawing.Size(300,10) 
$outputWindow.Size = New-Object System.Drawing.Size(300,200)
$outputWindow.Scrollbars = 3
$outputWindow.AcceptsReturn = $True

############################################################
# Event Id
$eventLabel = New-Object System.Windows.Forms.Label
$eventLabel.Location = New-Object System.Drawing.Point(10,20)
$eventLabel.Size = New-Object System.Drawing.Size(280,20)
$eventLabel.Text = 'Event Name:'

$eventTextbox = New-Object System.Windows.Forms.Textbox
$eventTextbox.Location = New-Object System.Drawing.Point(10,40)
$eventTextbox.Size = New-Object System.Drawing.Size(260,20)
$eventTextbox.Text = $EVENT_NAME
############################################################


############################################################
# Race Id
$racelabel = New-Object System.Windows.Forms.Label
$racelabel.Location = New-Object System.Drawing.Point(10,60)
$racelabel.Size = New-Object System.Drawing.Size(280,20)
$racelabel.Text = 'Race Id:'

$raceIdTextbox = New-Object System.Windows.Forms.Textbox
$raceIdTextbox.Location = New-Object System.Drawing.Point(10,80)
$raceIdTextbox.Size = New-Object System.Drawing.Size(260,20)
############################################################




############################################################
# Bib Number
$bibIdLabel = New-Object System.Windows.Forms.Label
$bibIdLabel.Location = New-Object System.Drawing.Point(10,100)
$bibIdLabel.Size = New-Object System.Drawing.Size(280,20)
$bibIdLabel.Text = 'Bib Id:'

$bibIdTextbox = New-Object System.Windows.Forms.Textbox
$bibIdTextbox.Location = New-Object System.Drawing.Point(10,120)
$bibIdTextbox.Size = New-Object System.Drawing.Size(260,20)
############################################################


############################################################
# Combo
$combo = New-Object System.Windows.Forms.ComboBox
$combo.Width = 100
$combo.AutoSize = $true
$combo.Location = New-Object System.Drawing.Point(10,140)
$combo.Size = New-Object System.Drawing.Size(260,20)
############################################################

############################################################
# Buttons
$actionButton = New-Object System.Windows.Forms.Button
$actionButton.Location = New-Object System.Drawing.Point(10,180)
$actionButton.Size = New-Object System.Drawing.Size(75,23)
$actionButton.Text = 'OK'


$refreshButton = New-Object System.Windows.Forms.Button
$refreshButton.Location = New-Object System.Drawing.Point(100,180)
$refreshButton.Size = New-Object System.Drawing.Size(75,23)
$refreshButton.Text = 'Refresh'
############################################################


############################################################
## TimingRecord
function ShowRecords {
	Write-Output "h"
	$fileName = $eventTextbox.Text + ".txt"
	$outputWindow.Text = ""
	$_RECORDS = @()
	Get-Content $fileName | ForEach-Object {
		$outputWindow.Text += $_ + [System.Environment]::Newline
		
		Write-Output $_
		
		$split = $_.Split(";")
		$r = $_.split[0]
		$t = $_.split[1]
		$i = $_.split[2]

		$_RECORDS += [pscustomobject]@{ raceId = $r; time = $t; id = $i }
	}
	
	$_RECORDS | Format-Table
}

function TimingRecord {
	# Variables
	$raceId = $raceIdTextbox.Text
	$dateTime = Get-Date -Format "dd/MM/yyyy HH:mm:ss.fff"
	$bibId = $bibIdTextbox.Text
	

		
	
	# Record line
	$record = $raceId + $delimitador + $dateTime + $delimitador + $bibId
	

	$tt = [DateTime]$dateTime
	$ti = [DateTime]$raceData.StartAt
	#$t = ($tt - $ti).Hours.ToString() + ":" + ($tt - $ti).Minutes.ToString()  + ":" + ($tt - $ti).Seconds.ToString()  + "." + ($tt - $ti).Milliseconds.ToString() 
	
	$th = [int](( $tt - $ti).Hours ) | % tostring 00
	$tm = [int](( $tt - $ti).Minutes ) | % tostring 00
	$ts = [int](( $tt - $ti).Seconds ) | % tostring 00
	$tn = [int](( $tt - $ti).Milliseconds ) | % tostring 00
	
			$myObject = [PSCustomObject]@{
				Bib = $bibId
				StartTime = $raceData.StartAt
				FinishTime = $dateTime
				TotalTime = $th + ":" + $tm + ":" + $ts + "." + $tn
				Name = ""
				Surname = ""
				Club = ""
				Category = ""
				}
	
	$inscritos = Get-Content -Raw i.json | ConvertFrom-Json
	$inscritos | where { $_.Dorsal -eq $bibId } | ForEach-Object { 
	
		$myObject.Name = $_.Nombre
		$myObject.Surname = $_.Apellidos
		$myObject.Club = $_.Club
		$myObject.Category = $_.Categoria
	

	}	
	
		$r = $myObject | ConvertTo-Json
	
		#$record = $record + $delimitador + $_.Nombre + $delimitador + $_.Apellidos + $delimitador + $_.Club + $delimitador + $_.Categoria + $delimitador
	
	
	# Add to file
	$fileName = $eventTextbox.Text + ".txt"
	Add-Content $fileName $r
	
	$r = ""
	
	# Clean
	$bibIdTextbox.Text = ""
	
	ShowRecords
}




############################################################
## Logic
$bibIdTextbox.Add_KeyDown({
    if ($_.KeyCode -eq "Enter") {
		TimingRecord
    }
})

$actionButton.Add_Click({
	TimingRecord
})

$refreshButton.Add_Click({
	ShowRecords
})
############################################################


############################################################
## Add controls
$form.Controls.Add($actionButton)
$form.Controls.Add($eventLabel)
$form.Controls.Add($eventTextbox)
$form.Controls.Add($racelabel)
$form.Controls.Add($raceIdTextbox)
$form.Controls.Add($bibIdLabel)
$form.Controls.Add($bibIdTextbox)
$form.Controls.Add($outputWindow)
$form.Controls.Add($refreshButton)
$form.Controls.Add($combo)
$form.Add_Shown({$bibIdTextbox.Select()})
$form.Topmost = $true
############################################################

$timer = New-Object System.Windows.Forms.Timer
$timer.Interval = 1000
$timer.Add_Tick({$racelabel.Text = $dateTime})
$timer.Enabled = $True


$_RACES | Foreach-Object { $combo.Items.Add($_)}

$dateTime = Get-Date -Format "dd/MM/yyyy HH:mm:ss.fff"


$result = $form.ShowDialog()


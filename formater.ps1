Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# Create form
$form = New-Object System.Windows.Forms.Form
$form.Text = "Mini USB Formatter"
$form.Size = New-Object System.Drawing.Size(400,350)
$form.StartPosition = "CenterScreen"

# ListBox for drives
$list = New-Object System.Windows.Forms.ListBox
$list.Dock = "Top"
$list.Height = 200

# Populate removable / non-system drives
Get-Volume | Where-Object {$_.DriveLetter -and $_.DriveLetter -ne "C"} |
ForEach-Object {
    $sizeGB = [Math]::Round($_.Size/1GB,2)
    $list.Items.Add("$($_.DriveLetter):  -  $sizeGB GB  -  $($_.FileSystem)")
}

$form.Controls.Add($list)

# ComboBox for filesystem selection
$label = New-Object System.Windows.Forms.Label
$label.Text = "Select Filesystem:"
$label.Dock = "Top"
$form.Controls.Add($label)

$combo = New-Object System.Windows.Forms.ComboBox
$combo.Items.AddRange(@("FAT32","NTFS","exFAT"))
$combo.SelectedIndex = 0
$combo.Dock = "Top"
$form.Controls.Add($combo)

# Format button
$button = New-Object System.Windows.Forms.Button
$button.Text = "Format Drive"
$button.Dock = "Bottom"

$button.Add_Click({
    if (-not $list.SelectedItem) {
        [System.Windows.Forms.MessageBox]::Show("Please select a drive first!")
        return
    }

    $selected = $list.SelectedItem.Split(":")[0]
    $fs = $combo.SelectedItem

    # Double confirmation
    $confirm1 = [System.Windows.Forms.MessageBox]::Show("Are you sure you want to format drive $selected?","Confirm", "YesNo","Warning")
    if ($confirm1 -ne [System.Windows.Forms.DialogResult]::Yes) { return }
    $confirm2 = [System.Windows.Forms.MessageBox]::Show("THIS WILL ERASE ALL DATA ON DRIVE $selected! Do you want to continue?","Confirm Again", "YesNo","Warning")
    if ($confirm2 -ne [System.Windows.Forms.DialogResult]::Yes) { return }

    # Format
    try {
        Format-Volume -DriveLetter $selected -FileSystem $fs -Confirm:$false -Force
        [System.Windows.Forms.MessageBox]::Show("Drive $selected formatted as $fs successfully!","Success")
    } catch {
        [System.Windows.Forms.MessageBox]::Show("Formatting failed: $_","Error")
    }

    # Refresh drive list
    $list.Items.Clear()
    Get-Volume | Where-Object {$_.DriveLetter -and $_.DriveLetter -ne "C"} |
    ForEach-Object {
        $sizeGB = [Math]::Round($_.Size/1GB,2)
        $list.Items.Add("$($_.DriveLetter):  -  $sizeGB GB  -  $($_.FileSystem)")
    }
})

$form.Controls.Add($button)

# Show form
$form.ShowDialog()

Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

$form = New-Object System.Windows.Forms.Form
$form.Text = "ProAi - Smart Assistant"
$form.Size = New-Object System.Drawing.Size(520, 400)
$form.StartPosition = "CenterScreen"
$form.BackColor = [System.Drawing.Color]::FromArgb(30,30,30)

$label = New-Object System.Windows.Forms.Label
$label.Text = "Enter your question or command:"
$label.ForeColor = [System.Drawing.Color]::White
$label.Location = New-Object System.Drawing.Point(10, 15)
$label.AutoSize = $true
$form.Controls.Add($label)

$textBox = New-Object System.Windows.Forms.TextBox
$textBox.Location = New-Object System.Drawing.Point(10, 40)
$textBox.Size = New-Object System.Drawing.Size(480, 25)
$form.Controls.Add($textBox)

$outputBox = New-Object System.Windows.Forms.TextBox
$outputBox.Location = New-Object System.Drawing.Point(10, 75)
$outputBox.Size = New-Object System.Drawing.Size(480, 260)
$outputBox.Multiline = $true
$outputBox.ScrollBars = 'Vertical'
$outputBox.ReadOnly = $true
$outputBox.BackColor = [System.Drawing.Color]::FromArgb(20,20,20)
$outputBox.ForeColor = [System.Drawing.Color]::White
$form.Controls.Add($outputBox)

$askButton = New-Object System.Windows.Forms.Button
$askButton.Text = "Ask"
$askButton.Location = New-Object System.Drawing.Point(130, 345)
$askButton.Size = New-Object System.Drawing.Size(100, 35)
$form.Controls.Add($askButton)

$closeButton = New-Object System.Windows.Forms.Button
$closeButton.Text = "Close"
$closeButton.Location = New-Object System.Drawing.Point(280, 345)
$closeButton.Size = New-Object System.Drawing.Size(100, 35)
$form.Controls.Add($closeButton)

$askButton.Add_Click({
    $input = $textBox.Text.Trim()
    if ([string]::IsNullOrWhiteSpace($input)) {
        [System.Windows.Forms.MessageBox]::Show("Please enter a question or command.", "ProAi Warning", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Warning)
        return
    }
    try {
        $output = Invoke-Expression $input *>&1 | Out-String
        $outputBox.Text = $output.Trim()
    }
    catch {
        $outputBox.Text = "Error: " + $_.Exception.Message
    }
})

$closeButton.Add_Click({
    $result = [System.Windows.Forms.MessageBox]::Show("Are you sure you want to exit?", "Confirm Exit", [System.Windows.Forms.MessageBoxButtons]::YesNo, [System.Windows.Forms.MessageBoxIcon]::Information)
    if ($result -eq [System.Windows.Forms.DialogResult]::Yes) {
        $form.Close()
    }
})

[void]$form.ShowDialog()

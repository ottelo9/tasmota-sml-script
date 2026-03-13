Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# --- Hauptfenster ---
$form = New-Object System.Windows.Forms.Form
$form.Text = "ottelo.jimdo.de - Shelly/EcoTracker Tester (UDP / HTTP Client)"
$form.Size = New-Object System.Drawing.Size(780, 870)
$form.StartPosition = "CenterScreen"
$form.FormBorderStyle = "FixedSingle"
$form.MaximizeBox = $false
$form.Font = New-Object System.Drawing.Font("Segoe UI", 9)
$form.BackColor = [System.Drawing.Color]::FromArgb(30, 30, 30)
$form.ForeColor = [System.Drawing.Color]::White

# --- Farben ---
$bgDark     = [System.Drawing.Color]::FromArgb(30, 30, 30)
$bgField    = [System.Drawing.Color]::FromArgb(45, 45, 45)
$bgButton   = [System.Drawing.Color]::FromArgb(60, 60, 60)
$accent     = [System.Drawing.Color]::FromArgb(0, 150, 136)
$accentRed  = [System.Drawing.Color]::FromArgb(200, 60, 60)
$accentHTTP = [System.Drawing.Color]::FromArgb(60, 120, 200)
$fgWhite    = [System.Drawing.Color]::White
$fgGray     = [System.Drawing.Color]::FromArgb(180, 180, 180)

function New-StyledLabel($text, $x, $y, $w, $h) {
    $lbl = New-Object System.Windows.Forms.Label
    $lbl.Text = $text; $lbl.Location = New-Object System.Drawing.Point($x, $y)
    $lbl.Size = New-Object System.Drawing.Size($w, $h)
    $lbl.ForeColor = $fgGray
    return $lbl
}

function New-StyledButton($text, $x, $y, $w, $h, $color) {
    $btn = New-Object System.Windows.Forms.Button
    $btn.Text = $text; $btn.Location = New-Object System.Drawing.Point($x, $y)
    $btn.Size = New-Object System.Drawing.Size($w, $h)
    $btn.FlatStyle = "Flat"; $btn.FlatAppearance.BorderSize = 0
    $btn.BackColor = $color; $btn.ForeColor = $fgWhite
    $btn.Cursor = "Hand"
    return $btn
}

# ===================== Protokoll-Umschalter =====================
$lblProto = New-StyledLabel "Protokoll:" 15 15 75 22
$form.Controls.Add($lblProto)

$radioUDP = New-Object System.Windows.Forms.RadioButton
$radioUDP.Text = "UDP"; $radioUDP.Checked = $true
$radioUDP.Location = New-Object System.Drawing.Point(95, 13)
$radioUDP.Size = New-Object System.Drawing.Size(60, 24)
$radioUDP.ForeColor = $fgWhite; $radioUDP.FlatStyle = "Flat"
$form.Controls.Add($radioUDP)

$radioHTTP = New-Object System.Windows.Forms.RadioButton
$radioHTTP.Text = "HTTP GET"
$radioHTTP.Location = New-Object System.Drawing.Point(160, 13)
$radioHTTP.Size = New-Object System.Drawing.Size(100, 24)
$radioHTTP.ForeColor = $fgWhite; $radioHTTP.FlatStyle = "Flat"
$form.Controls.Add($radioHTTP)

$lblModeIndicator = New-Object System.Windows.Forms.Label
$lblModeIndicator.Location = New-Object System.Drawing.Point(270, 15)
$lblModeIndicator.Size = New-Object System.Drawing.Size(140, 22)
$lblModeIndicator.Text = "[ UDP-Modus ]"
$lblModeIndicator.ForeColor = $accent
$lblModeIndicator.Font = New-Object System.Drawing.Font("Segoe UI", 9, [System.Drawing.FontStyle]::Bold)
$form.Controls.Add($lblModeIndicator)

# ===================== Verbindungsbereich =====================
$lblHost = New-StyledLabel "Ziel-Host / IP:" 15 48 110 22
$form.Controls.Add($lblHost)

$txtHost = New-Object System.Windows.Forms.TextBox
$txtHost.Location = New-Object System.Drawing.Point(130, 45)
$txtHost.Size = New-Object System.Drawing.Size(300, 26)
$txtHost.BackColor = $bgField; $txtHost.ForeColor = $fgWhite
$txtHost.BorderStyle = "FixedSingle"; $txtHost.Text = "192.168.178.31"
$form.Controls.Add($txtHost)

$lblPort = New-StyledLabel "Port:" 445 48 40 22
$form.Controls.Add($lblPort)

$txtPort = New-Object System.Windows.Forms.TextBox
$txtPort.Location = New-Object System.Drawing.Point(490, 45)
$txtPort.Size = New-Object System.Drawing.Size(80, 26)
$txtPort.BackColor = $bgField; $txtPort.ForeColor = $fgWhite
$txtPort.BorderStyle = "FixedSingle"; $txtPort.Text = "1010"
$form.Controls.Add($txtPort)

# ===================== Anfrage-Bereich =====================
$lblCmd = New-StyledLabel "UDP-Anfrage:" 15 85 110 22
$form.Controls.Add($lblCmd)

$txtCommand = New-Object System.Windows.Forms.TextBox
$txtCommand.Location = New-Object System.Drawing.Point(130, 82)
$txtCommand.Size = New-Object System.Drawing.Size(440, 26)
$txtCommand.BackColor = $bgField; $txtCommand.ForeColor = $fgWhite
$txtCommand.BorderStyle = "FixedSingle"
$form.Controls.Add($txtCommand)

$btnSend = New-StyledButton "Senden" 585 80 155 30 $accent
$btnSend.Font = New-Object System.Drawing.Font("Segoe UI", 9, [System.Drawing.FontStyle]::Bold)
$form.Controls.Add($btnSend)

# ===================== Vorgabe-Buttons =====================
$lblPresets = New-StyledLabel "Vorgaben:" 15 120 80 22
$form.Controls.Add($lblPresets)

$btnPreset1 = New-StyledButton "Shelly.GetStatus" 130 117 200 28 $bgButton
$form.Controls.Add($btnPreset1)

$btnPreset2 = New-StyledButton "EM.GetStatus" 340 117 200 28 $bgButton
$form.Controls.Add($btnPreset2)

$btnPresetHTTP = New-StyledButton "json/v1" 130 117 200 28 $bgButton
$btnPresetHTTP.Visible = $false
$form.Controls.Add($btnPresetHTTP)

# ===================== Intervall-Bereich =====================
$lblInterval = New-StyledLabel "Intervall (Sek.):" 15 158 110 22
$form.Controls.Add($lblInterval)

$txtInterval = New-Object System.Windows.Forms.TextBox
$txtInterval.Location = New-Object System.Drawing.Point(130, 155)
$txtInterval.Size = New-Object System.Drawing.Size(60, 26)
$txtInterval.BackColor = $bgField; $txtInterval.ForeColor = $fgWhite
$txtInterval.BorderStyle = "FixedSingle"; $txtInterval.Text = "5"
$txtInterval.TextAlign = "Center"
$form.Controls.Add($txtInterval)

$btnStartInterval = New-StyledButton "Intervall starten" 200 153 150 28 $accent
$form.Controls.Add($btnStartInterval)

$btnStopInterval = New-StyledButton "Intervall stoppen" 360 153 150 28 $accentRed
$btnStopInterval.Enabled = $false
$form.Controls.Add($btnStopInterval)

$lblIntervalStatus = New-Object System.Windows.Forms.Label
$lblIntervalStatus.Location = New-Object System.Drawing.Point(520, 158)
$lblIntervalStatus.Size = New-Object System.Drawing.Size(220, 22)
$lblIntervalStatus.ForeColor = $fgGray; $lblIntervalStatus.Text = ""
$form.Controls.Add($lblIntervalStatus)

# ===================== Trennlinie =====================
$separator = New-Object System.Windows.Forms.Label
$separator.Location = New-Object System.Drawing.Point(15, 190)
$separator.Size = New-Object System.Drawing.Size(735, 1)
$separator.BackColor = [System.Drawing.Color]::FromArgb(70, 70, 70)
$form.Controls.Add($separator)

# ===================== Antwort-Log =====================
$lblLog = New-StyledLabel "Antwort-Log:" 15 200 110 22
$form.Controls.Add($lblLog)

$btnClearLog = New-StyledButton "Log leeren" 640 197 100 26 $accentRed
$form.Controls.Add($btnClearLog)

$txtLog = New-Object System.Windows.Forms.RichTextBox
$txtLog.Location = New-Object System.Drawing.Point(15, 225)
$txtLog.Size = New-Object System.Drawing.Size(735, 240)
$txtLog.ScrollBars = "Vertical"
$txtLog.ReadOnly = $true; $txtLog.WordWrap = $true
$txtLog.BackColor = $bgField; $txtLog.ForeColor = [System.Drawing.Color]::FromArgb(100, 255, 180)
$txtLog.Font = New-Object System.Drawing.Font("Consolas", 9.5)
$form.Controls.Add($txtLog)

# ===================== JSON-Anzeige =====================
$lblJson = New-StyledLabel "JSON (formatiert):" 15 475 130 22
$form.Controls.Add($lblJson)

$btnClearJson = New-StyledButton "JSON leeren" 630 472 110 26 $accentRed
$form.Controls.Add($btnClearJson)

$txtJson = New-Object System.Windows.Forms.TextBox
$txtJson.Location = New-Object System.Drawing.Point(15, 500)
$txtJson.Size = New-Object System.Drawing.Size(735, 270)
$txtJson.Multiline = $true; $txtJson.ScrollBars = "Both"
$txtJson.ReadOnly = $true; $txtJson.WordWrap = $false
$txtJson.BackColor = $bgField; $txtJson.ForeColor = [System.Drawing.Color]::FromArgb(130, 180, 255)
$txtJson.Font = New-Object System.Drawing.Font("Consolas", 9.5)
$form.Controls.Add($txtJson)

# ===================== Statusbar =====================
$statusBar = New-Object System.Windows.Forms.StatusStrip
$statusBar.BackColor = $bgField
$statusLabel = New-Object System.Windows.Forms.ToolStripStatusLabel
$statusLabel.ForeColor = $fgGray; $statusLabel.Text = "Bereit."
$statusBar.Items.Add($statusLabel) | Out-Null
$form.Controls.Add($statusBar)

# ===================== Timer =====================
$timer = New-Object System.Windows.Forms.Timer
$timer.Enabled = $false

# ===================== Log-Farben & Hilfsfunktionen =====================
$colorGreen = [System.Drawing.Color]::FromArgb(100, 255, 180)
$colorRed   = [System.Drawing.Color]::FromArgb(255, 80, 80)
$colorBlue  = [System.Drawing.Color]::FromArgb(120, 180, 255)

function Write-Log([string]$text, [System.Drawing.Color]$color) {
    $txtLog.SelectionStart = 0
    $txtLog.SelectionLength = 0
    $txtLog.SelectionColor = $color
    $txtLog.SelectedText = $text
    $txtLog.SelectionStart = 0
    $txtLog.SelectionLength = 0
}

function Process-Response([string]$response, [string]$timestamp, [string]$label, [System.Drawing.Color]$successColor) {
    $logEntry = "[$timestamp]  $label`r`n$response`r`n" + ("-" * 80) + "`r`n"
    Write-Log $logEntry $successColor

    try {
        $jsonObj = $response | ConvertFrom-Json -ErrorAction Stop
        $formatted = $jsonObj | ConvertTo-Json -Depth 20
        $txtJson.Text = "# $timestamp`r`n# $label`r`n`r`n$formatted"
        $txtJson.SelectionStart = 0; $txtJson.ScrollToCaret()
    }
    catch {
        $txtJson.Text = "# $timestamp`r`n# Antwort ist kein gueltiges JSON.`r`n`r`n$response"
    }
}

# ===================== UDP Sende-Funktion =====================
function Send-UDPRequest {
    $host_target = $txtHost.Text.Trim()
    $port_target = 0
    $command = $txtCommand.Text.Trim()

    if ([string]::IsNullOrEmpty($host_target)) {
        $statusLabel.Text = "Fehler: Kein Ziel-Host angegeben."; return
    }
    if (-not [int]::TryParse($txtPort.Text.Trim(), [ref]$port_target) -or $port_target -lt 1 -or $port_target -gt 65535) {
        $statusLabel.Text = "Fehler: Ungueltiger Port (1-65535)."; return
    }
    if ([string]::IsNullOrEmpty($command)) {
        $statusLabel.Text = "Fehler: Keine Anfrage angegeben."; return
    }

    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss.fff"
    $statusLabel.Text = "UDP: Sende an ${host_target}:${port_target} ..."
    $form.Refresh()

    try {
        $udpClient = New-Object System.Net.Sockets.UdpClient
        $udpClient.Client.SendTimeout = 3000
        $udpClient.Client.ReceiveTimeout = 3000
        $udpClient.Client.ReceiveBufferSize = 65535

        $sendBytes = [System.Text.Encoding]::UTF8.GetBytes($command)
        $udpClient.Send($sendBytes, $sendBytes.Length, $host_target, $port_target) | Out-Null

        $remoteEP = New-Object System.Net.IPEndPoint([System.Net.IPAddress]::Any, 0)
        $allBytes = New-Object System.IO.MemoryStream
        $receiveBytes = $udpClient.Receive([ref]$remoteEP)
        $allBytes.Write($receiveBytes, 0, $receiveBytes.Length)

        $udpClient.Client.ReceiveTimeout = 500
        try {
            while ($true) {
                $moreBytes = $udpClient.Receive([ref]$remoteEP)
                $allBytes.Write($moreBytes, 0, $moreBytes.Length)
            }
        } catch { }

        $responseBytes = $allBytes.ToArray()
        $allBytes.Dispose()
        $response = [System.Text.Encoding]::UTF8.GetString($responseBytes)
        $udpClient.Close()

        Process-Response $response $timestamp "UDP <<  $command" $colorGreen
        $statusLabel.Text = "UDP: Antwort von $($remoteEP.Address):$($remoteEP.Port)  ($($responseBytes.Length) Bytes)"
    }
    catch [System.Net.Sockets.SocketException] {
        $logEntry = "[$timestamp]  UDP <<  $command`r`n[FEHLER] Timeout - keine Antwort erhalten.`r`n" + ("-" * 80) + "`r`n"
        Write-Log $logEntry $colorRed
        $statusLabel.Text = "UDP Timeout: Keine Antwort von ${host_target}:${port_target}"
    }
    catch {
        $logEntry = "[$timestamp]  UDP <<  $command`r`n[FEHLER] $($_.Exception.Message)`r`n" + ("-" * 80) + "`r`n"
        Write-Log $logEntry $colorRed
        $statusLabel.Text = "UDP Fehler: $($_.Exception.Message)"
    }
}

# ===================== HTTP GET Funktion =====================
function Send-HTTPRequest {
    $host_target = $txtHost.Text.Trim()
    $port_target = $txtPort.Text.Trim()
    $path = $txtCommand.Text.Trim()

    if ([string]::IsNullOrEmpty($host_target)) {
        $statusLabel.Text = "Fehler: Kein Ziel-Host angegeben."; return
    }
    if ([string]::IsNullOrEmpty($path)) {
        $statusLabel.Text = "Fehler: Kein URL-Pfad angegeben."; return
    }

    # Pfad normalisieren
    if (-not $path.StartsWith("/")) { $path = "/$path" }

    # URL zusammenbauen
    if ($port_target -eq "80" -or [string]::IsNullOrEmpty($port_target)) {
        $url = "http://${host_target}${path}"
    } else {
        $url = "http://${host_target}:${port_target}${path}"
    }

    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss.fff"
    $statusLabel.Text = "HTTP GET: $url ..."
    $form.Refresh()

    try {
        $webClient = New-Object System.Net.WebClient
        $webClient.Encoding = [System.Text.Encoding]::UTF8
        $response = $webClient.DownloadString($url)
        $webClient.Dispose()

        Process-Response $response $timestamp "HTTP GET  $url" $colorGreen
        $statusLabel.Text = "HTTP: Antwort erhalten von $url  ($($response.Length) Zeichen)"
    }
    catch [System.Net.WebException] {
        $errMsg = $_.Exception.Message
        $statusCode = ""
        if ($_.Exception.Response) {
            $statusCode = " [HTTP $([int]$_.Exception.Response.StatusCode)]"
        }
        $logEntry = "[$timestamp]  HTTP GET  $url`r`n[FEHLER]${statusCode} $errMsg`r`n" + ("-" * 80) + "`r`n"
        Write-Log $logEntry $colorRed
        $statusLabel.Text = "HTTP Fehler:${statusCode} $errMsg"
    }
    catch {
        $logEntry = "[$timestamp]  HTTP GET  $url`r`n[FEHLER] $($_.Exception.Message)`r`n" + ("-" * 80) + "`r`n"
        Write-Log $logEntry $colorRed
        $statusLabel.Text = "HTTP Fehler: $($_.Exception.Message)"
    }
}

# ===================== Dispatcher =====================
function Send-Request {
    if ($radioUDP.Checked) { Send-UDPRequest }
    else { Send-HTTPRequest }
}

# ===================== Modus-Umschaltung =====================
function Update-ModeUI {
    if ($radioUDP.Checked) {
        $lblModeIndicator.Text = "[ UDP-Modus ]"
        $lblModeIndicator.ForeColor = $accent
        $lblCmd.Text = "UDP-Anfrage:"
        $btnSend.BackColor = $accent
        $btnStartInterval.BackColor = $accent
        $txtPort.Text = "1010"
        $txtCommand.Text = ""
        $btnPreset1.Visible = $true
        $btnPreset2.Visible = $true
        $btnPresetHTTP.Visible = $false
        $form.Text = "UDP / HTTP Client  -  UDP"
    } else {
        $lblModeIndicator.Text = "[ HTTP-Modus ]"
        $lblModeIndicator.ForeColor = $accentHTTP
        $lblCmd.Text = "URL-Pfad:"
        $btnSend.BackColor = $accentHTTP
        $btnStartInterval.BackColor = $accentHTTP
        $txtPort.Text = "80"
        $txtCommand.Text = ""
        $btnPreset1.Visible = $false
        $btnPreset2.Visible = $false
        $btnPresetHTTP.Visible = $true
        $form.Text = "UDP / HTTP Client  -  HTTP GET"
    }
}

$radioUDP.Add_CheckedChanged({ Update-ModeUI })

# ===================== Event-Handler =====================

$btnSend.Add_Click({ Send-Request })

$txtCommand.Add_KeyDown({
    if ($_.KeyCode -eq "Return") { Send-Request; $_.SuppressKeyPress = $true }
})

# Vorgabe-Buttons
$btnPreset1.Add_Click({ $txtCommand.Text = 'Shelly.GetStatus' })
$btnPreset2.Add_Click({ $txtCommand.Text = 'EM.GetStatus' })
$btnPresetHTTP.Add_Click({ $txtCommand.Text = '/v1/json' })

$btnClearLog.Add_Click({ $txtLog.Text = ""; $statusLabel.Text = "Log geleert." })
$btnClearJson.Add_Click({ $txtJson.Text = "" })

# Intervall starten
$btnStartInterval.Add_Click({
    $intervalSec = 0
    if (-not [int]::TryParse($txtInterval.Text.Trim(), [ref]$intervalSec) -or $intervalSec -lt 1) {
        $statusLabel.Text = "Fehler: Intervall muss mindestens 1 Sekunde sein."
        return
    }
    $timer.Interval = $intervalSec * 1000
    $timer.Enabled = $true
    $btnStartInterval.Enabled = $false
    $btnStopInterval.Enabled = $true
    $txtInterval.Enabled = $false
    $radioUDP.Enabled = $false
    $radioHTTP.Enabled = $false
    $lblIntervalStatus.Text = "Aktiv: alle ${intervalSec}s"
    $lblIntervalStatus.ForeColor = [System.Drawing.Color]::FromArgb(100, 255, 180)
    $statusLabel.Text = "Intervall gestartet (${intervalSec}s)."
    Send-Request
})

# Intervall stoppen
$btnStopInterval.Add_Click({
    $timer.Enabled = $false
    $btnStartInterval.Enabled = $true
    $btnStopInterval.Enabled = $false
    $txtInterval.Enabled = $true
    $radioUDP.Enabled = $true
    $radioHTTP.Enabled = $true
    $lblIntervalStatus.Text = "Gestoppt"
    $lblIntervalStatus.ForeColor = $fgGray
    $statusLabel.Text = "Intervall gestoppt."
})

$timer.Add_Tick({ Send-Request })

$form.Add_FormClosing({
    $timer.Enabled = $false
    $timer.Dispose()
})

# ===================== Anzeige =====================
[void]$form.ShowDialog()

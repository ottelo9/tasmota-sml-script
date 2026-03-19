Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# --- Hauptfenster ---
$appVersion = "v2026-03-19 12:08"
$form = New-Object System.Windows.Forms.Form
$form.Text = "ottelo.jimdo.de - Shelly/EcoTracker Tester $appVersion  -  UDP"
$form.Size = New-Object System.Drawing.Size(780, 900)
$form.StartPosition = "CenterScreen"
$form.FormBorderStyle = "FixedSingle"
$form.MaximizeBox = $false
$form.Font = New-Object System.Drawing.Font("Segoe UI", 9)
$form.BackColor = [System.Drawing.Color]::FromArgb(30, 30, 30)
$form.ForeColor = [System.Drawing.Color]::White

# --- Farben ---
$bgDark      = [System.Drawing.Color]::FromArgb(30, 30, 30)
$bgField     = [System.Drawing.Color]::FromArgb(45, 45, 45)
$bgButton    = [System.Drawing.Color]::FromArgb(60, 60, 60)
$accent      = [System.Drawing.Color]::FromArgb(0, 150, 136)
$accentRed   = [System.Drawing.Color]::FromArgb(200, 60, 60)
$accentHTTP  = [System.Drawing.Color]::FromArgb(60, 120, 200)
$accentPing  = [System.Drawing.Color]::FromArgb(200, 160, 0)
$fgWhite     = [System.Drawing.Color]::White
$fgGray      = [System.Drawing.Color]::FromArgb(180, 180, 180)

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
$radioUDP.Size = New-Object System.Drawing.Size(55, 24)
$radioUDP.ForeColor = $fgWhite; $radioUDP.FlatStyle = "Flat"
$form.Controls.Add($radioUDP)

$radioHTTP = New-Object System.Windows.Forms.RadioButton
$radioHTTP.Text = "HTTP GET"
$radioHTTP.Location = New-Object System.Drawing.Point(155, 13)
$radioHTTP.Size = New-Object System.Drawing.Size(95, 24)
$radioHTTP.ForeColor = $fgWhite; $radioHTTP.FlatStyle = "Flat"
$form.Controls.Add($radioHTTP)

$radioPing = New-Object System.Windows.Forms.RadioButton
$radioPing.Text = "Ping"
$radioPing.Location = New-Object System.Drawing.Point(255, 13)
$radioPing.Size = New-Object System.Drawing.Size(60, 24)
$radioPing.ForeColor = $fgWhite; $radioPing.FlatStyle = "Flat"
$form.Controls.Add($radioPing)

$lblModeIndicator = New-Object System.Windows.Forms.Label
$lblModeIndicator.Location = New-Object System.Drawing.Point(330, 15)
$lblModeIndicator.Size = New-Object System.Drawing.Size(150, 22)
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

# ===================== Anfrage-Bereich (UDP/HTTP) =====================
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

# ===================== Vorgabe-Buttons (UDP) =====================
$lblPresets = New-StyledLabel "Vorgaben:" 15 120 80 22
$form.Controls.Add($lblPresets)

$btnPreset1 = New-StyledButton "Shelly.GetStatus" 130 117 200 28 $bgButton
$form.Controls.Add($btnPreset1)

$btnPreset2 = New-StyledButton "EM.GetStatus" 340 117 200 28 $bgButton
$form.Controls.Add($btnPreset2)

# Vorgabe-Buttons (HTTP)
$btnPresetHTTP = New-StyledButton "json/v1" 130 117 150 28 $bgButton
$btnPresetHTTP.Visible = $false
$form.Controls.Add($btnPresetHTTP)

$btnPresetHTTP2 = New-StyledButton "Shelly.GetStatus" 290 117 150 28 $bgButton
$btnPresetHTTP2.Visible = $false
$form.Controls.Add($btnPresetHTTP2)

$btnPresetHTTP3 = New-StyledButton "EM.GetStatus" 450 117 150 28 $bgButton
$btnPresetHTTP3.Visible = $false
$form.Controls.Add($btnPresetHTTP3)

# ===================== Intervall-Bereich (UDP/HTTP) =====================
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

# ===================== Ping-Bereich (nur im Ping-Modus sichtbar) =====================
$lblPingInterval = New-StyledLabel "Ping-Intervall (Sek.):" 15 85 140 22
$lblPingInterval.Visible = $false
$form.Controls.Add($lblPingInterval)

$txtPingInterval = New-Object System.Windows.Forms.TextBox
$txtPingInterval.Location = New-Object System.Drawing.Point(160, 82)
$txtPingInterval.Size = New-Object System.Drawing.Size(60, 26)
$txtPingInterval.BackColor = $bgField; $txtPingInterval.ForeColor = $fgWhite
$txtPingInterval.BorderStyle = "FixedSingle"; $txtPingInterval.Text = "1"
$txtPingInterval.TextAlign = "Center"; $txtPingInterval.Visible = $false
$form.Controls.Add($txtPingInterval)

$lblPingHint1 = New-StyledLabel "(0 = so schnell wie moeglich)" 225 85 200 22
$lblPingHint1.Visible = $false
$form.Controls.Add($lblPingHint1)

$lblPingDuration = New-StyledLabel "Dauer (Sek.):" 15 120 140 22
$lblPingDuration.Visible = $false
$form.Controls.Add($lblPingDuration)

$txtPingDuration = New-Object System.Windows.Forms.TextBox
$txtPingDuration.Location = New-Object System.Drawing.Point(160, 117)
$txtPingDuration.Size = New-Object System.Drawing.Size(60, 26)
$txtPingDuration.BackColor = $bgField; $txtPingDuration.ForeColor = $fgWhite
$txtPingDuration.BorderStyle = "FixedSingle"; $txtPingDuration.Text = "0"
$txtPingDuration.TextAlign = "Center"; $txtPingDuration.Visible = $false
$form.Controls.Add($txtPingDuration)

$lblPingHint2 = New-StyledLabel "(0 = unendlich)" 225 120 200 22
$lblPingHint2.Visible = $false
$form.Controls.Add($lblPingHint2)

# Ping-Optionen: Datei-Log und Nur-Fehler
$chkPingLogFile = New-Object System.Windows.Forms.CheckBox
$chkPingLogFile.Text = "In Datei loggen"
$chkPingLogFile.Location = New-Object System.Drawing.Point(450, 84)
$chkPingLogFile.Size = New-Object System.Drawing.Size(140, 22)
$chkPingLogFile.ForeColor = $fgWhite; $chkPingLogFile.FlatStyle = "Flat"
$chkPingLogFile.Visible = $false
$form.Controls.Add($chkPingLogFile)

$chkPingErrorsOnly = New-Object System.Windows.Forms.CheckBox
$chkPingErrorsOnly.Text = "Nur Fehler loggen"
$chkPingErrorsOnly.Location = New-Object System.Drawing.Point(450, 119)
$chkPingErrorsOnly.Size = New-Object System.Drawing.Size(160, 22)
$chkPingErrorsOnly.ForeColor = $fgWhite; $chkPingErrorsOnly.FlatStyle = "Flat"
$chkPingErrorsOnly.Visible = $false
$form.Controls.Add($chkPingErrorsOnly)

$lblPingLogPath = New-Object System.Windows.Forms.Label
$lblPingLogPath.Location = New-Object System.Drawing.Point(600, 84)
$lblPingLogPath.Size = New-Object System.Drawing.Size(140, 22)
$lblPingLogPath.ForeColor = [System.Drawing.Color]::FromArgb(100, 180, 255)
$lblPingLogPath.Text = ""; $lblPingLogPath.Visible = $false
$form.Controls.Add($lblPingLogPath)

$btnPingStart = New-StyledButton "Ping starten" 160 153 150 28 $accentPing
$btnPingStart.Visible = $false
$form.Controls.Add($btnPingStart)

$btnPingStop = New-StyledButton "Ping stoppen" 320 153 150 28 $accentRed
$btnPingStop.Visible = $false; $btnPingStop.Enabled = $false
$form.Controls.Add($btnPingStop)

$lblPingStatus = New-Object System.Windows.Forms.Label
$lblPingStatus.Location = New-Object System.Drawing.Point(480, 158)
$lblPingStatus.Size = New-Object System.Drawing.Size(260, 22)
$lblPingStatus.ForeColor = $fgGray; $lblPingStatus.Text = ""
$lblPingStatus.Visible = $false
$form.Controls.Add($lblPingStatus)

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

# ===================== Website-Link =====================
$linkLabel = New-Object System.Windows.Forms.LinkLabel
$linkLabel.Text = "https://ottelo.jimdofree.com/"
$linkLabel.Location = New-Object System.Drawing.Point(15, 778)
$linkLabel.Size = New-Object System.Drawing.Size(300, 20)
$linkLabel.LinkColor = [System.Drawing.Color]::FromArgb(100, 180, 255)
$linkLabel.ActiveLinkColor = [System.Drawing.Color]::FromArgb(150, 210, 255)
$linkLabel.VisitedLinkColor = [System.Drawing.Color]::FromArgb(100, 180, 255)
$linkLabel.BackColor = $bgDark
$linkLabel.Add_LinkClicked({ Start-Process "https://ottelo.jimdofree.com/" })
$form.Controls.Add($linkLabel)

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

$pingTimer = New-Object System.Windows.Forms.Timer
$pingTimer.Enabled = $false

# ===================== Ping-Statistik =====================
$script:pingSent     = 0
$script:pingReceived = 0
$script:pingLost     = 0
$script:pingMinMs    = [double]::MaxValue
$script:pingMaxMs    = 0
$script:pingTotalMs  = 0
$script:pingStartTime = $null
$script:pingDurationSec = 0
$script:pingLogFile  = $null

# ===================== Log-Farben & Hilfsfunktionen =====================
$colorGreen  = [System.Drawing.Color]::FromArgb(100, 255, 180)
$colorRed    = [System.Drawing.Color]::FromArgb(255, 80, 80)
$colorYellow = [System.Drawing.Color]::FromArgb(255, 220, 100)
$colorOrange = [System.Drawing.Color]::FromArgb(255, 165, 50)

function Write-Log([string]$text, [System.Drawing.Color]$color) {
    $txtLog.SelectionStart = 0
    $txtLog.SelectionLength = 0
    $txtLog.SelectionColor = $color
    $txtLog.SelectedText = $text
    $txtLog.SelectionStart = 0
    $txtLog.SelectionLength = 0
}

function Process-Response([string]$response, [string]$timestamp, [string]$label, [System.Drawing.Color]$successColor) {
    $isDuplicate = $false
    $firstJson = $null

    # Zuerst pruefen ob es gueltiges einzelnes JSON ist
    try {
        $jsonObj = $response | ConvertFrom-Json -ErrorAction Stop
        $firstJson = $jsonObj
    }
    catch {
        # Kein gueltiges JSON - pruefen ob mehrere JSON-Objekte aneinandergereiht sind
        # Suche nach }{ Pattern (Ende eines Objekts, Anfang des naechsten)
        $idx = $response.IndexOf("}{")
        if ($idx -gt 0) {
            $firstPart = $response.Substring(0, $idx + 1)
            try {
                $jsonObj = $firstPart | ConvertFrom-Json -ErrorAction Stop
                $firstJson = $jsonObj
                $isDuplicate = $true
            } catch { }
        }
    }

    if ($isDuplicate) {
        # Doppeltes Paket: Log in Orange mit Hinweis
        $logEntry = "[$timestamp]  $label`r`n[HINWEIS] Paket doppelt erhalten!`r`n$response`r`n" + ("-" * 80) + "`r`n"
        Write-Log $logEntry $colorOrange
    } else {
        $logEntry = "[$timestamp]  $label`r`n$response`r`n" + ("-" * 80) + "`r`n"
        Write-Log $logEntry $successColor
    }

    # JSON-Anzeige (immer nur das erste gueltige Objekt)
    if ($firstJson) {
        $formatted = $firstJson | ConvertTo-Json -Depth 20
        $dupHint = if ($isDuplicate) { "`r`n# HINWEIS: Paket doppelt erhalten - nur erstes JSON angezeigt" } else { "" }
        $txtJson.Text = "# $timestamp`r`n# $label${dupHint}`r`n`r`n$formatted"
        $txtJson.SelectionStart = 0; $txtJson.ScrollToCaret()
    } else {
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

    if (-not $path.StartsWith("/")) { $path = "/$path" }

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

# ===================== Ping Funktion =====================
function Send-SinglePing {
    $host_target = $txtHost.Text.Trim()
    if ([string]::IsNullOrEmpty($host_target)) { return }

    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss.fff"
    $script:pingSent++
    $errorsOnly = $chkPingErrorsOnly.Checked
    $isError = $false
    $logLine = ""

    try {
        $pinger = New-Object System.Net.NetworkInformation.Ping
        $reply = $pinger.Send($host_target, 2000)
        $pinger.Dispose()

        if ($reply.Status -eq [System.Net.NetworkInformation.IPStatus]::Success) {
            $ms = $reply.RoundtripTime
            $script:pingReceived++
            $script:pingTotalMs += $ms
            if ($ms -lt $script:pingMinMs) { $script:pingMinMs = $ms }
            if ($ms -gt $script:pingMaxMs) { $script:pingMaxMs = $ms }
            $avgMs = [math]::Round($script:pingTotalMs / $script:pingReceived, 1)
            $lossPercent = [math]::Round(($script:pingLost / $script:pingSent) * 100, 1)

            $logLine = "[$timestamp]  PING  $host_target  ->  Antwort von $($reply.Address): ${ms}ms  TTL=$($reply.Options.Ttl)"
            if (-not $errorsOnly) { Write-Log "$logLine`r`n" $colorGreen }
            $statusLabel.Text = "Ping #$($script:pingSent): ${ms}ms  |  Min=$($script:pingMinMs)  Avg=${avgMs}  Max=$($script:pingMaxMs)  Verlust=${lossPercent}%"
        } else {
            $isError = $true
            $script:pingLost++
            $lossPercent = [math]::Round(($script:pingLost / $script:pingSent) * 100, 1)
            $logLine = "[$timestamp]  PING  $host_target  ->  $($reply.Status)"
            Write-Log "$logLine`r`n" $colorRed
            $statusLabel.Text = "Ping #$($script:pingSent): $($reply.Status)  |  Verlust=${lossPercent}%"
        }
    }
    catch {
        $isError = $true
        $script:pingLost++
        $lossPercent = [math]::Round(($script:pingLost / $script:pingSent) * 100, 1)
        $logLine = "[$timestamp]  PING  $host_target  ->  [FEHLER] $($_.Exception.Message)"
        Write-Log "$logLine`r`n" $colorRed
        $statusLabel.Text = "Ping #$($script:pingSent): Fehler  |  Verlust=${lossPercent}%"
    }

    # In Datei loggen
    if ($script:pingLogFile -and $logLine) {
        if (-not $errorsOnly -or $isError) {
            Add-Content -Path $script:pingLogFile -Value $logLine -Encoding UTF8
        }
    }

    # Dauer pruefen
    if ($script:pingDurationSec -gt 0) {
        $elapsed = ((Get-Date) - $script:pingStartTime).TotalSeconds
        if ($elapsed -ge $script:pingDurationSec) {
            Stop-PingTest
        }
    }
}

function Stop-PingTest {
    $pingTimer.Enabled = $false
    $btnPingStart.Enabled = $true
    $btnPingStop.Enabled = $false
    $txtPingInterval.Enabled = $true
    $txtPingDuration.Enabled = $true
    $chkPingLogFile.Enabled = $true
    $chkPingErrorsOnly.Enabled = $true
    $radioUDP.Enabled = $true
    $radioHTTP.Enabled = $true

    # Zusammenfassung
    $host_target = $txtHost.Text.Trim()
    $lossPercent = if ($script:pingSent -gt 0) { [math]::Round(($script:pingLost / $script:pingSent) * 100, 1) } else { 0 }
    $avgMs = if ($script:pingReceived -gt 0) { [math]::Round($script:pingTotalMs / $script:pingReceived, 1) } else { 0 }
    $minMs = if ($script:pingMinMs -eq [double]::MaxValue) { 0 } else { $script:pingMinMs }
    $elapsed = [math]::Round(((Get-Date) - $script:pingStartTime).TotalSeconds, 1)

    $summary  = "`r`n" + ("=" * 80) + "`r`n"
    $summary += "  Ping-Statistik fuer ${host_target}:`r`n"
    $summary += "  Gesendet: $($script:pingSent)  |  Empfangen: $($script:pingReceived)  |  Verloren: $($script:pingLost) (${lossPercent}%)`r`n"
    $summary += "  RTT: Min=${minMs}ms  Avg=${avgMs}ms  Max=$($script:pingMaxMs)ms`r`n"
    $summary += "  Dauer: ${elapsed}s`r`n"
    $summary += ("=" * 80) + "`r`n"
    Write-Log $summary $colorYellow

    # Zusammenfassung in Datei
    if ($script:pingLogFile) {
        $fileSummary  = ""
        $fileSummary += ("=" * 80)
        $fileSummary += "`r`nPing-Statistik fuer ${host_target}:"
        $fileSummary += "`r`nGesendet: $($script:pingSent)  |  Empfangen: $($script:pingReceived)  |  Verloren: $($script:pingLost) (${lossPercent}%)"
        $fileSummary += "`r`nRTT: Min=${minMs}ms  Avg=${avgMs}ms  Max=$($script:pingMaxMs)ms"
        $fileSummary += "`r`nDauer: ${elapsed}s"
        $fileSummary += "`r`n" + ("=" * 80)
        Add-Content -Path $script:pingLogFile -Value $fileSummary -Encoding UTF8
        $statusLabel.Text = "Ping beendet. Log: $($script:pingLogFile)"
        $script:pingLogFile = $null
    } else {
        $statusLabel.Text = "Ping beendet: $($script:pingReceived)/$($script:pingSent) empfangen, ${lossPercent}% Verlust, Avg=${avgMs}ms"
    }

    $lblPingStatus.Text = "Beendet ($($script:pingSent) Pings)"
    $lblPingStatus.ForeColor = $fgGray
    $lblPingLogPath.Text = ""
}

# ===================== Dispatcher =====================
function Send-Request {
    if ($radioUDP.Checked) { Send-UDPRequest }
    elseif ($radioHTTP.Checked) { Send-HTTPRequest }
}

# ===================== Modus-Umschaltung =====================
# Sammlung aller modusabhaengigen Controls
$udpHttpControls = @($lblCmd, $txtCommand, $btnSend, $lblPresets,
    $btnPreset1, $btnPreset2, $btnPresetHTTP, $btnPresetHTTP2, $btnPresetHTTP3,
    $lblInterval, $txtInterval, $btnStartInterval, $btnStopInterval, $lblIntervalStatus)

$pingControls = @($lblPingInterval, $txtPingInterval, $lblPingHint1,
    $lblPingDuration, $txtPingDuration, $lblPingHint2,
    $chkPingLogFile, $chkPingErrorsOnly, $lblPingLogPath,
    $btnPingStart, $btnPingStop, $lblPingStatus)

function Update-ModeUI {
    if ($radioPing.Checked) {
        # Ping-Modus: UDP/HTTP Controls ausblenden
        foreach ($c in $udpHttpControls) { $c.Visible = $false }
        $lblPort.Visible = $false; $txtPort.Visible = $false
        foreach ($c in $pingControls) { $c.Visible = $true }

        $lblModeIndicator.Text = "[ Ping-Modus ]"
        $lblModeIndicator.ForeColor = $accentPing
        $form.Text = "ottelo.jimdo.de - Shelly/EcoTracker Tester $appVersion  -  Ping"
    }
    else {
        # UDP/HTTP: Ping-Controls ausblenden
        foreach ($c in $pingControls) { $c.Visible = $false }
        $lblPort.Visible = $true; $txtPort.Visible = $true

        # Basis-Controls einblenden
        $lblCmd.Visible = $true; $txtCommand.Visible = $true; $btnSend.Visible = $true
        $lblPresets.Visible = $true
        $lblInterval.Visible = $true; $txtInterval.Visible = $true
        $btnStartInterval.Visible = $true; $btnStopInterval.Visible = $true
        $lblIntervalStatus.Visible = $true

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
            $btnPresetHTTP2.Visible = $false
            $btnPresetHTTP3.Visible = $false
            $form.Text = "ottelo.jimdo.de - Shelly/EcoTracker Tester $appVersion  -  UDP"
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
            $btnPresetHTTP2.Visible = $true
            $btnPresetHTTP3.Visible = $true
            $form.Text = "ottelo.jimdo.de - Shelly/EcoTracker Tester $appVersion  -  HTTP GET"
        }
    }
}

$radioUDP.Add_CheckedChanged({ Update-ModeUI })
$radioHTTP.Add_CheckedChanged({ Update-ModeUI })
$radioPing.Add_CheckedChanged({ Update-ModeUI })

# ===================== Event-Handler =====================

$btnSend.Add_Click({ Send-Request })

$txtCommand.Add_KeyDown({
    if ($_.KeyCode -eq "Return") { Send-Request; $_.SuppressKeyPress = $true }
})

# Vorgabe-Buttons
$btnPreset1.Add_Click({ $txtCommand.Text = 'Shelly.GetStatus' })
$btnPreset2.Add_Click({ $txtCommand.Text = 'EM.GetStatus' })
$btnPresetHTTP.Add_Click({ $txtCommand.Text = '/v1/json' })
$btnPresetHTTP2.Add_Click({ $txtCommand.Text = '/rpc/Shelly.GetStatus' })
$btnPresetHTTP3.Add_Click({ $txtCommand.Text = '/rpc/EM.GetStatus' })

$btnClearLog.Add_Click({ $txtLog.Text = ""; $statusLabel.Text = "Log geleert." })
$btnClearJson.Add_Click({ $txtJson.Text = "" })

# Intervall starten (UDP/HTTP)
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
    $radioPing.Enabled = $false
    $lblIntervalStatus.Text = "Aktiv: alle ${intervalSec}s"
    $lblIntervalStatus.ForeColor = [System.Drawing.Color]::FromArgb(100, 255, 180)
    $statusLabel.Text = "Intervall gestartet (${intervalSec}s)."
    Send-Request
})

# Intervall stoppen (UDP/HTTP)
$btnStopInterval.Add_Click({
    $timer.Enabled = $false
    $btnStartInterval.Enabled = $true
    $btnStopInterval.Enabled = $false
    $txtInterval.Enabled = $true
    $radioUDP.Enabled = $true
    $radioHTTP.Enabled = $true
    $radioPing.Enabled = $true
    $lblIntervalStatus.Text = "Gestoppt"
    $lblIntervalStatus.ForeColor = $fgGray
    $statusLabel.Text = "Intervall gestoppt."
})

$timer.Add_Tick({ Send-Request })

# Ping starten
$btnPingStart.Add_Click({
    $host_target = $txtHost.Text.Trim()
    if ([string]::IsNullOrEmpty($host_target)) {
        $statusLabel.Text = "Fehler: Kein Ziel-Host angegeben."
        return
    }

    $pingIntervalSec = 0
    if (-not [int]::TryParse($txtPingInterval.Text.Trim(), [ref]$pingIntervalSec) -or $pingIntervalSec -lt 0) {
        $statusLabel.Text = "Fehler: Ping-Intervall muss >= 0 sein."
        return
    }

    $durationSec = 0
    if (-not [int]::TryParse($txtPingDuration.Text.Trim(), [ref]$durationSec) -or $durationSec -lt 0) {
        $statusLabel.Text = "Fehler: Dauer muss >= 0 sein."
        return
    }

    # Statistik zuruecksetzen
    $script:pingSent = 0; $script:pingReceived = 0; $script:pingLost = 0
    $script:pingMinMs = [double]::MaxValue; $script:pingMaxMs = 0; $script:pingTotalMs = 0
    $script:pingStartTime = Get-Date
    $script:pingDurationSec = $durationSec

    # Log-Datei erstellen
    if ($chkPingLogFile.Checked) {
        $dateStr = Get-Date -Format "yyyy-MM-dd_HH-mm-ss"
        $script:pingLogFile = [System.IO.Path]::Combine(
            [Environment]::GetFolderPath("Desktop"),
            "ping_${host_target}_${dateStr}.log")
        $header = "Ping-Log gestartet: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')  Ziel: $host_target"
        Set-Content -Path $script:pingLogFile -Value $header -Encoding UTF8
        $lblPingLogPath.Text = [System.IO.Path]::GetFileName($script:pingLogFile)
    } else {
        $script:pingLogFile = $null
        $lblPingLogPath.Text = ""
    }

    $btnPingStart.Enabled = $false
    $btnPingStop.Enabled = $true
    $txtPingInterval.Enabled = $false
    $txtPingDuration.Enabled = $false
    $chkPingLogFile.Enabled = $false
    $chkPingErrorsOnly.Enabled = $false
    $radioUDP.Enabled = $false
    $radioHTTP.Enabled = $false

    $durationText = if ($durationSec -eq 0) { "unendlich" } else { "${durationSec}s" }
    $intervalText = if ($pingIntervalSec -eq 0) { "max. Speed" } else { "${pingIntervalSec}s" }
    $errOnlyText = if ($chkPingErrorsOnly.Checked) { "  [Nur Fehler]" } else { "" }
    $lblPingStatus.Text = "Laeuft... ($intervalText / $durationText)"
    $lblPingStatus.ForeColor = [System.Drawing.Color]::FromArgb(100, 255, 180)

    $logHeader = "--- Ping gestartet: $host_target  (Intervall: $intervalText, Dauer: $durationText)${errOnlyText} ---`r`n"
    Write-Log $logHeader $colorYellow

    if ($script:pingLogFile) {
        Add-Content -Path $script:pingLogFile -Value "Intervall: $intervalText  Dauer: $durationText${errOnlyText}" -Encoding UTF8
        Add-Content -Path $script:pingLogFile -Value ("-" * 80) -Encoding UTF8
    }

    if ($pingIntervalSec -eq 0) {
        $pingTimer.Interval = 100  # ~100ms = so schnell wie moeglich mit GUI-Refresh
    } else {
        $pingTimer.Interval = $pingIntervalSec * 1000
    }
    $pingTimer.Enabled = $true
    $statusLabel.Text = "Ping laeuft: $host_target ..."

    # Ersten Ping sofort senden
    Send-SinglePing
})

# Ping stoppen
$btnPingStop.Add_Click({ Stop-PingTest })

$pingTimer.Add_Tick({ Send-SinglePing })

# Aufraeumen
$form.Add_FormClosing({
    $timer.Enabled = $false; $timer.Dispose()
    $pingTimer.Enabled = $false; $pingTimer.Dispose()
})

# ===================== Anzeige =====================
[void]$form.ShowDialog()

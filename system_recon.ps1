Write-Host "===== SYSTEM RECON TOOL (PowerShell) =====" -ForegroundColor Cyan

# ---------------- OS INFORMATION ----------------
Write-Host "`n[+] Collecting OS Information..." -ForegroundColor Green
$os = Get-CimInstance Win32_OperatingSystem
$computer = Get-CimInstance Win32_ComputerSystem

$osInfo = [PSCustomObject]@{
    Caption        = $os.Caption
    Version        = $os.Version
    OSArchitecture = $os.OSArchitecture
    LastBootUpTime = $os.LastBootUpTime
    ComputerName   = $env:COMPUTERNAME
}

$osInfo | Format-List


# ---------------- CURRENT USER ----------------
Write-Host "`n[+] Getting Current User..." -ForegroundColor Green
Write-Host $env:USERNAME


# ---------------- SYSTEM UPTIME ----------------
Write-Host "`n[+] System Uptime..." -ForegroundColor Green
(Get-CimInstance Win32_OperatingSystem).LastBootUpTime


# ---------------- IP INFORMATION ----------------
Write-Host "`n[+] Collecting IP Address Information..." -ForegroundColor Green
$ipInfo = Get-NetIPAddress | Where-Object {$_.AddressFamily -eq "IPv4"}
$ipInfo | Format-Table -AutoSize


# ---------------- MAC ADDRESSES ----------------
Write-Host "`n[+] Getting MAC Addresses..." -ForegroundColor Green
$macs = Get-NetAdapter | Select-Object Name, MacAddress, Status
$macs | Format-Table -AutoSize


# ---------------- RUNNING PROCESSES ----------------
Write-Host "`n[+] Listing Running Processes..." -ForegroundColor Green
Get-Process | Select-Object Name, Id, CPU, WorkingSet | Sort-Object CPU -Descending | Format-Table -AutoSize


# ---------------- INSTALLED PROGRAMS ----------------
Write-Host "`n[+] Collecting Installed Programs (This may take a moment)..." -ForegroundColor Green
$programs = Get-ItemProperty HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\* |
            Select-Object DisplayName, DisplayVersion, Publisher | Sort-Object DisplayName
$programs | Format-Table -AutoSize


# ---------------- DISK INFORMATION ----------------
Write-Host "`n[+] Disk Information..." -ForegroundColor Green
$disks = Get-CimInstance Win32_LogicalDisk | Select-Object DeviceID, VolumeName, Size, FreeSpace
$disks | Format-Table -AutoSize

Write-Host "`n===== Recon Complete =====" -ForegroundColor Cyan

# tool/gen_flavor_icons.ps1
# Usage: powershell -ExecutionPolicy Bypass -File tool/gen_flavor_icons.ps1
# Pre-requisite: assets/icon/dev.png staging.png prod.png (1024x1024)
# NOTE: uses only PowerShell 5.1-compatible syntax (no 3-arg Join-Path).
Add-Type -AssemblyName System.Drawing

$root = Join-Path $PSScriptRoot '..'
$root = (Resolve-Path $root).Path

$targets = @(
    @{ Flavor = 'dev';     Src = 'assets/icon/dev.png' },
    @{ Flavor = 'staging'; Src = 'assets/icon/staging.png' },
    @{ Flavor = 'prod';    Src = 'assets/icon/prod.png' }
)

# Android launcher icon sizes per density bucket (px)
$densities = @(
    @{ Dpi = 'mdpi';    Size = 48 },
    @{ Dpi = 'hdpi';    Size = 72 },
    @{ Dpi = 'xhdpi';   Size = 96 },
    @{ Dpi = 'xxhdpi';  Size = 144 },
    @{ Dpi = 'xxxhdpi'; Size = 192 }
)

foreach ($t in $targets) {
    $srcPath = Join-Path $root $t.Src
    if (-not (Test-Path $srcPath)) {
        Write-Host "missing source image: $($t.Src), skip $($t.Flavor)" -ForegroundColor Yellow
        continue
    }
    $img = [System.Drawing.Image]::FromFile((Resolve-Path $srcPath))
    foreach ($d in $densities) {
        $outDir = Join-Path $root "android/app/src/$($t.Flavor)/res/mipmap-$($d.Dpi)"
        New-Item -ItemType Directory -Force -Path $outDir | Out-Null
        $bmp = New-Object System.Drawing.Bitmap $img, $d.Size, $d.Size
        $outFile = Join-Path $outDir 'ic_launcher.png'
        $bmp.Save($outFile, [System.Drawing.Imaging.ImageFormat]::Png)
        $bmp.Dispose()
        Write-Host "generated $outFile"
    }
    $img.Dispose()
}
Write-Host "done. three sets of icons written to flavor res dirs."

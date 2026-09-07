# tool/gen_source_placeholder_icons.ps1
# 一次性生成三张 1024x1024 占位源图到 assets/icon/。
# 以后拿到正式设计稿，直接覆盖同名 png 再重跑 gen_flavor_icons.ps1 即可。
# 用法：powershell -ExecutionPolicy Bypass -File tool/gen_source_placeholder_icons.ps1
Add-Type -AssemblyName System.Drawing

function New-PlaceholderIcon([string]$hex, [string]$label, [string]$outFile) {
    $size = 1024
    $bmp = New-Object System.Drawing.Bitmap $size, $size
    $g = [System.Drawing.Graphics]::FromImage($bmp)
    $g.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
    $g.TextRenderingHint = [System.Drawing.Text.TextRenderingHint]::AntiAlias
    $g.Clear([System.Drawing.ColorTranslator]::FromHtml($hex))

    # inner ring decoration (semi-transparent white)
    $ringPen = New-Object System.Drawing.Pen ([System.Drawing.Color]::FromArgb(120, 255, 255, 255)), 40
    $margin = 70
    $rect = New-Object System.Drawing.Rectangle $margin, $margin, ($size - 2 * $margin), ($size - 2 * $margin)
    $g.DrawEllipse($ringPen, $rect)

    # white bold label, auto-fit width
    $fontSize = 300.0
    $font = New-Object System.Drawing.Font 'Arial', $fontSize, ([System.Drawing.FontStyle]::Bold), ([System.Drawing.GraphicsUnit]::Pixel)
    $wd = $g.MeasureString($label, $font).Width
    $target = [Math]::Round($fontSize * 0.72 * $size / [Math]::Max($wd, 1))
    if ($target -lt 40) { $target = 40 }
    $font.Dispose()
    $font = New-Object System.Drawing.Font 'Arial', ([float]$target), ([System.Drawing.FontStyle]::Bold), ([System.Drawing.GraphicsUnit]::Pixel)

    $brush = New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::White)
    $fmt = New-Object System.Drawing.StringFormat
    $fmt.Alignment = [System.Drawing.StringAlignment]::Center
    $fmt.LineAlignment = [System.Drawing.StringAlignment]::Center
    $full = New-Object System.Drawing.RectangleF 0, 0, $size, $size
    $g.DrawString($label, $font, $brush, $full, $fmt)

    $dir = Split-Path -Parent $outFile
    if (-not (Test-Path $dir)) { New-Item -ItemType Directory -Force -Path $dir | Out-Null }
    $bmp.Save($outFile, [System.Drawing.Imaging.ImageFormat]::Png)

    $fmt.Dispose(); $brush.Dispose(); $font.Dispose(); $ringPen.Dispose()
    $g.Dispose(); $bmp.Dispose()
}

$root = Join-Path $PSScriptRoot '..'
$targets = @(
    @{ File = 'dev.png';     Hex = '#2962FF'; Label = 'DEV' },     # blue
    @{ File = 'staging.png'; Hex = '#FF6D00'; Label = 'STAGING' }, # orange
    @{ File = 'prod.png';    Hex = '#00A884'; Label = 'PROD' }     # teal
)

foreach ($t in $targets) {
    $out = Join-Path $root "assets/icon/$($t.File)"
    New-PlaceholderIcon $t.Hex $t.Label $out
    Write-Host "generated $out"
}
Write-Host "done."

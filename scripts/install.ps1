# ============================================================
# MySQL Workbench Snippets Installer
# Copia snippets.txt a la carpeta de snippets de MySQL Workbench
# Hace backup automatico del archivo anterior si existe
# ============================================================

# Rutas de origen y destino
$archivoOrigen = "$(Split-Path $PSScriptRoot)\snippets.txt"
$archivoDestino = "$env:APPDATA\MySQL\Workbench\snippets\User Snippets.txt"
$carpetaDestino = Split-Path $archivoDestino

# Verificar que existe el archivo de snippets
if (-not (Test-Path $archivoOrigen)) {
    Write-Host "ERROR: No se encontro el archivo de origen:" -ForegroundColor Red
    Write-Host "  $archivoOrigen" -ForegroundColor Yellow
    Write-Host "Asegurate de que snippets.txt esta en la misma carpeta que este script." -ForegroundColor Yellow
    exit
}

# Verificar que MySQL Workbench esta instalado
if (-not (Test-Path $carpetaDestino)) {
    Write-Host "ERROR: No se encontro la carpeta de Workbench:" -ForegroundColor Red
    Write-Host "  $carpetaDestino" -ForegroundColor Yellow
    Write-Host "Asegurate de que MySQL Workbench esta instalado." -ForegroundColor Yellow
    exit
}

# Si ya existe un archivo de snippets, hacer backup antes de sobreescribir
if (Test-Path $archivoDestino) {
    $carpetaAntig = "$carpetaDestino\antiguos_snippets"
    if (-not (Test-Path $carpetaAntig)) {
        New-Item -ItemType Directory -Path $carpetaAntig | Out-Null
    }
    $fecha = Get-Date -Format "'h'HH'_m'mm'_s'ss'_d'dd'_m'MM'_a'yyyy"
    $archivoRespaldo = "$carpetaAntig\snippets_$fecha.txt"
    Move-Item $archivoDestino $archivoRespaldo
    Write-Host "Backup guardado en: antiguos_snippets\snippets_$fecha.txt" -ForegroundColor Yellow
    Copy-Item $archivoOrigen $archivoDestino
    Write-Host "Snippets instalados correctamente." -ForegroundColor Green
} else {
    # No habia archivo previo, copiar directamente
    Copy-Item $archivoOrigen $archivoDestino
    Write-Host "Snippets instalados correctamente." -ForegroundColor Green
}

Write-Host "Ruta: $archivoDestino" -ForegroundColor Cyan
Start-Sleep -Seconds 6
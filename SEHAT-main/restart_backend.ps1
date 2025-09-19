# PowerShell script to restart the backend server
Write-Host "🔄 Restarting SEHAT Backend Server..." -ForegroundColor Cyan

# Navigate to backend directory
$backendPath = "C:\Users\shivi\Downloads\SEHAT-main\SEHAT-main\backend"
Set-Location $backendPath

Write-Host "📁 Current directory: $backendPath" -ForegroundColor Yellow

# Kill any existing node processes (optional)
Write-Host "🛑 Stopping existing server processes..." -ForegroundColor Red
try {
    Get-Process node -ErrorAction SilentlyContinue | Stop-Process -Force
    Write-Host "✅ Existing processes stopped" -ForegroundColor Green
} catch {
    Write-Host "ℹ️  No existing processes to stop" -ForegroundColor Gray
}

# Wait a moment
Start-Sleep -Seconds 2

# Start the server
Write-Host "🚀 Starting backend server..." -ForegroundColor Green
Write-Host "🔧 Environment: development (rate limiting disabled for localhost)" -ForegroundColor Yellow
Write-Host "📊 New Rate Limits:" -ForegroundColor Magenta
Write-Host "   - Auth: 50 requests / 5 minutes (localhost skipped)" -ForegroundColor White
Write-Host "   - General: 1000 requests / 15 minutes (localhost skipped)" -ForegroundColor White
Write-Host ""

# Start server in development mode
npm run dev

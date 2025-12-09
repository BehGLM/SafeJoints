# update-safejoints.ps1
# Auto-update SafeJOINTs website repo with no prompts

# Stop on errors inside PowerShell cmdlets
$ErrorActionPreference = "Stop"

try {
    # 1) Go to project folder
    Set-Location "F:\Website\Website"

    # 2) Render the Quarto site (HTML into docs/)
    quarto render
    if ($LASTEXITCODE -ne 0) {
        throw "Quarto render failed with exit code $LASTEXITCODE"
    }

    # 3) Check if there are any changes to commit
    $status = git status --porcelain
    if ([string]::IsNullOrWhiteSpace($status)) {
        Write-Host ""
        Write-Host "======================================="
        Write-Host "✅ No changes detected."
        Write-Host "   Repository is already up to date."
        Write-Host "======================================="
        exit 0
    }

    # 4) Stage all changes
    git add .
    if ($LASTEXITCODE -ne 0) {
        throw "git add failed with exit code $LASTEXITCODE"
    }

    # 5) Auto-generate commit message with timestamp
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $commitMessage = "Auto-update SafeJOINTs site - $timestamp"

    git commit -m "$commitMessage"
    if ($LASTEXITCODE -ne 0) {
        throw "git commit failed with exit code $LASTEXITCODE"
    }

    # 6) Push to GitHub (origin/main)
    git push origin main
    if ($LASTEXITCODE -ne 0) {
        throw "git push failed with exit code $LASTEXITCODE"
    }

    # 7) Final success message
    Write-Host ""
    Write-Host "======================================="
    Write-Host "✅ SafeJOINTs update COMPLETED SUCCESSFULLY"
    Write-Host "   Commit message: $commitMessage"
    Write-Host "======================================="
}
catch {
    # Final failure message
    Write-Host ""
    Write-Host "======================================="
    Write-Host "❌ SafeJOINTs update FAILED"
    Write-Host "Reason: $_"
    Write-Host "======================================="
    exit 1
}

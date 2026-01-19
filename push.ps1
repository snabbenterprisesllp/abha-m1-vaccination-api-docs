# Push script for abha-m1-vaccination-api-docs repository
# This script will help you push with proper authentication

param(
    [string]$Token = ""
)

$repoName = "abha-m1-vaccination-api-docs"
$orgName = "snabbenterprisesllp"
$repoUrl = "https://github.com/$orgName/$repoName"

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Push Documentation Repository" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

cd C:\Users\kaljena\Downloads\CursoreAI\Project\abha-m1-vaccination-api-docs

# Check if token provided
if ($Token) {
    Write-Host "Using provided token for authentication..." -ForegroundColor Yellow
    git remote set-url origin "https://$Token@github.com/$orgName/$repoName.git"
} else {
    Write-Host "No token provided. Will use default authentication." -ForegroundColor Yellow
    Write-Host "If push fails, provide token: .\push.ps1 -Token YOUR_GITHUB_TOKEN" -ForegroundColor Yellow
    Write-Host ""
}

# Ensure remote is set
git remote remove origin 2>$null
if ($Token) {
    git remote add origin "https://$Token@github.com/$orgName/$repoName.git"
} else {
    git remote add origin "https://github.com/$orgName/$repoName.git"
}

git branch -M main

Write-Host "Pushing to GitHub..." -ForegroundColor Yellow
Write-Host ""

$pushResult = git push -u origin main 2>&1

if ($LASTEXITCODE -eq 0) {
    Write-Host ""
    Write-Host "✅ Successfully pushed to GitHub!" -ForegroundColor Green
    Write-Host ""
    Write-Host "Repository URL: $repoUrl" -ForegroundColor Cyan
    Write-Host ""
} else {
    Write-Host ""
    Write-Host "❌ Push failed. Error:" -ForegroundColor Red
    Write-Host $pushResult -ForegroundColor Red
    Write-Host ""
    Write-Host "To push with token, run:" -ForegroundColor Yellow
    Write-Host "  .\push.ps1 -Token YOUR_GITHUB_TOKEN" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "Or authenticate manually and run:" -ForegroundColor Yellow
    Write-Host "  git push -u origin main" -ForegroundColor Cyan
    Write-Host ""
}


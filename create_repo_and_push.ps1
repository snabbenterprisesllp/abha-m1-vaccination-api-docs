# PowerShell script to create GitHub repository via API and push

$repoName = "abha-m1-vaccination-api-docs"
$orgName = "snabbenterprisesllp"
$description = "ABHA M1 Sandbox Documentation for Vaccination Locker API"
$repoUrl = "https://github.com/$orgName/$repoName"

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "GitHub Repository Creation & Push Script" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Check if repository exists by trying to access it
Write-Host "Checking if repository exists..." -ForegroundColor Yellow

# Navigate to documentation directory
cd C:\Users\kaljena\Downloads\CursoreAI\Project\abha-m1-vaccination-api-docs

# Remove existing remote if any
git remote remove origin 2>$null

# Add remote
git remote add origin "https://github.com/$orgName/$repoName.git"
git branch -M main

Write-Host ""
Write-Host "Attempting to push..." -ForegroundColor Yellow
Write-Host ""

# Try to push
$pushOutput = git push -u origin main 2>&1
$pushSuccess = $LASTEXITCODE -eq 0

if ($pushSuccess) {
    Write-Host ""
    Write-Host "✅ Successfully pushed to GitHub!" -ForegroundColor Green
    Write-Host ""
    Write-Host "Repository URL: $repoUrl" -ForegroundColor Cyan
    Write-Host ""
} else {
    Write-Host ""
    Write-Host "❌ Repository does not exist on GitHub yet." -ForegroundColor Red
    Write-Host ""
    Write-Host "Please create the repository manually:" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "Steps:" -ForegroundColor White
    Write-Host "1. Go to: https://github.com/new" -ForegroundColor Cyan
    Write-Host "2. Owner: Select '$orgName'" -ForegroundColor White
    Write-Host "3. Repository name: $repoName" -ForegroundColor White
    Write-Host "4. Description: $description" -ForegroundColor White
    Write-Host "5. Visibility: Public (recommended for ABDM review)" -ForegroundColor White
    Write-Host "6. ⚠️  IMPORTANT: DO NOT check 'Add a README file'" -ForegroundColor Yellow
    Write-Host "7. ⚠️  IMPORTANT: DO NOT check 'Add .gitignore'" -ForegroundColor Yellow
    Write-Host "8. ⚠️  IMPORTANT: DO NOT select a license" -ForegroundColor Yellow
    Write-Host "9. Click 'Create repository'" -ForegroundColor White
    Write-Host ""
    Write-Host "After creating the repository, run this command:" -ForegroundColor Yellow
    Write-Host "  git push -u origin main" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "Or run this script again." -ForegroundColor Yellow
}


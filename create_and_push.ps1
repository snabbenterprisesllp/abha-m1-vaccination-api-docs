# PowerShell script to create GitHub repository and push documentation

$repoName = "abha-m1-vaccination-api-docs"
$orgName = "snabbenterprisesllp"
$description = "ABHA M1 Sandbox Documentation for Vaccination Locker API"

Write-Host "Creating GitHub repository: $repoName" -ForegroundColor Green

# Check if repository already exists by trying to push
Write-Host "Attempting to push to repository..." -ForegroundColor Yellow

cd C:\Users\kaljena\Downloads\CursoreAI\Project\abha-m1-vaccination-api-docs

# Try to push - if repository exists, this will work
git remote remove origin 2>$null
git remote add origin "https://github.com/$orgName/$repoName.git"
git branch -M main

$pushResult = git push -u origin main 2>&1

if ($LASTEXITCODE -eq 0) {
    Write-Host "Successfully pushed to GitHub!" -ForegroundColor Green
    Write-Host "Repository URL: https://github.com/$orgName/$repoName" -ForegroundColor Cyan
} else {
    Write-Host "Repository does not exist on GitHub yet." -ForegroundColor Yellow
    Write-Host ""
    Write-Host "Please create the repository manually:" -ForegroundColor Yellow
    Write-Host "1. Go to: https://github.com/new" -ForegroundColor White
    Write-Host "2. Repository name: $repoName" -ForegroundColor White
    Write-Host "3. Description: $description" -ForegroundColor White
    Write-Host "4. Visibility: Public (recommended)" -ForegroundColor White
    Write-Host "5. DO NOT initialize with README, .gitignore, or license" -ForegroundColor White
    Write-Host "6. Click 'Create repository'" -ForegroundColor White
    Write-Host ""
    Write-Host "Then run this script again, or run:" -ForegroundColor Yellow
    Write-Host "  git push -u origin main" -ForegroundColor White
}


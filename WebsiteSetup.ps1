# Prompt for website names
$siteNames = Read-Host "Enter the names of the websites you want to set up (space-separated)"

# SSH into the Linux machine and run the script with site names as parameters
ssh user@linux-machine "bash -s" < setup-websites.sh -sites $siteNames

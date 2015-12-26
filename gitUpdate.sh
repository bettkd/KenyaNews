# Shell script which when run updates git
# Usage: ./gitUpdate.sh
#!/bin/bash
git pull git@github.com:bettkd/KenyaNews.git version2
git add -A
read -e -p "Please enter the commit message: " commit_message 
echo "Commit message is - $commit_message."
git commit -m "$commit_message"
git push -u origin version2

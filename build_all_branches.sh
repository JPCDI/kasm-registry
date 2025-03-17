#!/bin/sh

DEFAULT=$(git remote show origin | sed -n '/HEAD branch/s/.*: //p')

mkdir base
cat > base/index.html << EOF
<meta http-equiv="refresh" content="0; url=./$DEFAULT/">
EOF
touch base/.nojekyll

# Generating documentation for each other branch in a subdirectory
echo "All branches:"
echo "Running git fetch"
git fetch --all
echo "Running git branch --remotes --format '%(refname:lstrip=3)' | grep -Ev '^(HEAD|develop|gh-pages)$'"
echo "$(git branch --remotes --format '%(refname:lstrip=3)' | grep -Ev '^(HEAD|develop|gh-pages)$')"
echo "Running for loop"
for BRANCH in $(git branch --remotes --format '%(refname:lstrip=3)' | grep -Ev '^(HEAD|develop|gh-pages)$'); do
    echo "Branch: $BRANCH"
    echo "Sanitizing branch name"
    SANITIZED_BRANCH="$(echo $BRANCH | sed 's/\//_/g')"
    echo "Sanitized branch name: $SANITIZED_BRANCH"
    echo "Adding branch to versions.txt"
    echo "$SANITIZED_BRANCH" >> base/versions.txt
    echo "Checking out $BRANCH"
    git checkout $BRANCH -f
    echo "running node processing"
    node processing
    echo "copying public to process"
    cp -a public/. process
    echo "running sed"
    sed -i "s/1.0/$SANITIZED_BRANCH/" site/next.config.js
    echo "running npm run deploy --prefix site"
    npm run deploy --prefix site
    echo "copying process to public"
    cp -a process/. public/ # Have to run it again because the deploy wipes the file and folders out
    echo "removing process"
    rm -rf process
    echo "running sed"
    sed -i "s/$SANITIZED_BRANCH/1.0/" site/next.config.js # Set it back to 1.0 so it can be changed again on the next loop
    echo "moving public to base"
    mv public base/$SANITIZED_BRANCH
    echo "copying favicon.ico"
    cp base/$SANITIZED_BRANCH/favicon.ico base/favicon.ico
done

mv base public

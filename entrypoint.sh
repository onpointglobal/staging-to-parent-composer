#!/bin/sh -l

branch=$1
composer_parent_path=$2
composer_project_path=$3
secret=$4
tag_version=$5
composer_package_name=$(jq -r '.name' $composer_project_path/composer.json)
update_arg = $composer_package_name

if [ -z "$tag_version" ]; then
    composer_version=$(echo $tag_version | cut -c 2-) 
    update_arg = $composer_package_name":"$composer_version
fi

export COMPOSER=composer-$branch.json
composer config --global github-oauth.github.com $secret
cd $composer_parent_path && composer update $update_arg

git config --global user.name github-actions
git config --global user.email github-actions@github.com
git config --get remote.origin.url
git status
git commit -am "update composer.lock with $composer_package_name"
git push origin $branch
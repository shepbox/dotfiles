#!/usr/bin/env bash

cd "$(dirname "${BASH_SOURCE}")";

function doIt() {
	rsync --exclude ".git/" --exclude ".DS_Store" --exclude "bootstrap.sh" \
		--exclude "README.md" --exclude "LICENSE-MIT.txt" --exclude ".gitmodules" -avh --no-perms . ~;
	source ~/.bash_profile;
}

function submodules() {
	read -p "Init submodules? (first time only) (y/N) " -n 1;
	echo "";
	if [[ $REPLY =~ ^[Yy]$ ]]; then
		git submodule init;
		git submodule update;
		git submodule foreach git checkout master;
	else
		updateSubmodules;
	fi;
}

function updateSubmodules() {
	git submodule foreach git pull;
}

function main() {
	git pull origin master;

	submodules;

	if [ "$1" == "--force" -o "$1" == "-f" ]; then
		doIt;
	else
		read -p "This may overwrite existing files in your home directory. Are you sure? (y/N) " -n 1;
		echo "";
		if [[ $REPLY =~ ^[Yy]$ ]]; then
			echo "Going for it!";
			doIt;
		else
			echo "Chicken'd out!";
		fi;
	fi;
}

main;

unset doIt;
unset main;
unset submodules;
unset updateSubmodules;

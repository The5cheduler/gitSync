#!/bin/bash

# Developer: Pk Patel
# Email: parthpatel9414+opensource@gmail.com
# Date: 2021-09-25
# Version: 0.2.0
# Description: gitSync: A shortcut for adding, committing, and pushing files to a git repository

# Check if the terminal supports color
if [ "$TERM" != "dumb" ]; then
  RED='\033[0;31m'
  GREEN='\033[0;32m'
  BLUE='\033[0;34m'
  YELLOW='\033[1;33m'
  CYAN='\033[0;36m'
  MAGENTA='\033[0;35m'
  ORANGE='\033[0;33m'
  NC='\033[0m'
else
  RED=''
  GREEN=''
  BLUE=''
  YELLOW=''
  CYAN=''
  MAGENTA=''
  ORANGE=''
  NC=''
fi

VERSION="0.2.0"

function intro() {
  echo -e "${CYAN}version: $VERSION 🚀 ${NC}"
  echo -e "${CYAN}gitSync 🔧 : A shortcut for adding, committing, and pushing files to a git repository${NC}"
  echo -e "Developed by: ${GREEN}Pk Patel${NC} with ❤️  for the developer community."
}

function help() {
  echo -e "Usage:"
  echo -e "${YELLOW}gitSync <command> [<args>]${NC}"
  echo -e "  ${GREEN}gitSync --version || -v${NC}                    🚀 Show the version of this script"
  echo -e "     ${MAGENTA}example: gitSync --version${NC}"
  echo -e "  ${GREEN}gitSync help || --help || -h || usage${NC}      🆘 Show usage information"
  echo -e "     ${MAGENTA}example: gitSync help || gitSync --help || gitSync -h || gitSync usage${NC}"
  echo -e "  ${GREEN}gitSync single <filename> <commit message>${NC}   📂 Add, commit, and push a single file"
  echo -e "     ${MAGENTA}example: gitSync single index.html \"Initial commit\"${NC}"
  echo -e "  ${GREEN}gitSync multiple <commit message> <filename1> <filename2>...${NC}  📂 Add, commit, and push multiple files"
  echo -e "     ${MAGENTA}example: gitSync multiple \"add index and about pages\" index.html about.html${NC}"
  echo -e "  ${GREEN}gitSync all <commit message>${NC}               📚 Add, commit, and push all files"
  echo -e "     ${MAGENTA}example: gitSync all \"Initial commit\"${NC}"
  echo -e "  ${GREEN}gitSync rebase <branch>${NC}                    🔄 Rebase and push the current branch"
  echo -e "     ${MAGENTA}example: gitSync rebase main${NC}"
  echo -e "  ${GREEN}gitSync update <branch>${NC}                    🔄 Update the current branch with the latest changes from remote/main"
  echo -e "     ${MAGENTA}example: gitSync update feature-branch${NC}"
  exit 1
}

function error() {
  echo -e "${RED}Error: $1${NC}"
  exit 1
}

function check_git() {
  if ! command -v git &> /dev/null; then
    echo -e "${RED}Error: ${NC}git is not installed. Please install git before running this script."
    exit 1
  fi

  if ! git rev-parse --is-inside-work-tree > /dev/null 2>&1; then
    echo -e "${RED}Error: ${NC}This is not a Git repository. Please navigate to a Git repository and try again."
    exit 1
  fi
}

function version() {
  echo -e "${CYAN}version: $VERSION ${NC}"
  exit 0
}

function rebase() {
  check_git || return 1

  if [ -z "$1" ]; then
    echo "Usage: gitSync rebase <branch>"
    echo "example: gitSync rebase main"
    exit 1
  fi

  git fetch origin
  git rebase origin/"$1"
  git push
}

function commit_single() {
  check_git || return 1

  if [ -z "$1" ]; then
    echo "Usage: gitSync single <filename> <commit message>"
    echo "example: gitSync single index.html \"Initial commit\""
    exit 1
  fi

  if [ -z "$2" ]; then
    echo "Usage: gitSync single <filename> <commit message>"
    echo "example: gitSync single index.html \"Initial commit\""
    exit 1
  fi

  git add "$1"
  git commit -m "$2"
  git push
}

function commit_multiple() {
  check_git || return 1

  if [ $# -lt 2 ]; then
    echo "Usage: gitSync multiple <commit message> <filename1> <filename2>..."
    echo "example: gitSync multiple \"add index and about pages\" index.html about.html"
    exit 1
  fi

  commit_message=$1
  shift

  for file in "$@"; do
    git add "$file"
  done

  git commit -m "$commit_message"
  git push
}

function commit_all() {
  check_git || return 1

  if [ -z "$1" ]; then
    echo "Usage: gitSync all <commit message>"
    echo "example: gitSync all \"Initial commit\""
    exit 1
  fi

  commit_message=$1
  shift

  git add .
  git commit -m "$commit_message"
  git push
}

function update() {
  check_git || return 1

  if [ -z "$1" ]; then
    echo "Usage: gitSync update <branch>"
    echo "example: gitSync update feature-branch"
    exit 1
  fi

  git checkout main
  git fetch origin
  git checkout "$1"
  git merge origin/main
}

if [ "$#" -eq 0 ]; then
  intro
  exit 0
fi

case "$1" in
  update)
    shift
    update "$@"
    echo -e "🔄 Updated current branch with the latest changes from remote/main!"
    ;;
  rebase)
    shift
    rebase "$@"
    echo -e "🔄 Rebased and pushed!"
    ;;
  single)
    shift
    commit_single "$@"
    echo -e "🚀 Pushed a $@ file!"
    ;;
  all)
    shift
    commit_all "$@"
    echo -e "🎉 Pushed all files!"
    ;;
  multiple)
    shift
    commit_multiple "$@"
    echo -e "✨ Pushed multiple files!"
    ;;
  --version|-v)
    version
    ;;
  help|--help|-h|usage)
    help
    ;;
  *)
    echo -e "${RED}Invalid command: $1${NC}"
    echo "==> Run ${GREEN}'gitSync help'${NC} to learn more."
    exit 1
    ;;
esac

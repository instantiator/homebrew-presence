#!/bin/bash

usage() {
  cat << EOF

Updates the Homebrew formulae to point to the latest version.

Options:
    -f <path>          --formula <path>              Formula to update (default: Formula/presence-cli.rb)
    -d <filename>      --download <filename>         GitHub download filename (default: Presence.zip)
    -u <github-user>   --github-user <github-user>   GitHub user account (default: instantiator)
    -r <repo>          --repo <repo>                 GitHub repository (default: presence)
    -h                 --help                        Prints this help message and exits

EOF
}

# defaults
FORMULA_PATH="Formula/presence-cli.rb"
GH_USER="instantiator"
GH_REPO="presence"
GH_FILENAME="Presence.zip"

# parameters
while [ -n "$1" ]; do
  case $1 in
  -f | --formula)
    shift
    FORMULA_PATH=$1
    ;;
  -u | --github-user)
    shift
    GH_USER=$1
    ;;
  -r | --repo)
    shift
    GH_REPO=$1
    ;;
  -d | --download)
    shift
    GH_FILENAME=$1
    ;;
  -h | --help)
    usage
    exit 0
    ;;
  *)
    echo "Unknown option $1..."
    usage
    exit 1
    ;;
  esac
  shift
done

# if no github user is provided, show help and exit
if [ -z "$GH_USER" ]; then
  echo "GitHub user is required..."
  usage
  exit 1
fi

# if no github repo is provided, show help and exit
if [ -z "$GH_REPO" ]; then
  echo "GitHub repository is required..."
  usage
  exit 1
fi

# if no formula is provided, show help and exit
if [ -z "$FORMULA_PATH" ]; then
  echo "Formula path is required..."
  usage
  exit 1
fi

# if no github filename, show help and exit
if [ -z "$GH_FILENAME" ]; then
  echo "Download filename is required..."
  usage
  exit 1
fi

# temporary paths
TMP_DIR=$(mktemp -d)
RELEASE_DOWNLOAD_PATH=${TMP_DIR}/${GH_FILENAME}

# get the latest release tag
RELEASE_DATA=$( wget -q -O - https://api.github.com/repos/${GH_USER}/${GH_REPO}/releases )
LATEST_RELEASE=$( echo $RELEASE_DATA | jq -r '.[].tag_name' | sort -V | tail -1 )
RELEASE_DOWNLOAD_URL=$( echo $RELEASE_DATA | jq -r ".[] | select(.tag_name==\"${LATEST_RELEASE}\") | .assets[] | select(.name==\"${GH_FILENAME}\") | .browser_download_url" )

echo "GitHub user:    ${GH_USER}"
echo "GitHub repo:    ${GH_REPO}"
echo "Download file:  ${GH_FILENAME}"
echo "Latest release: ${LATEST_RELEASE}"
echo "Download URL:   ${RELEASE_DOWNLOAD_URL}"
echo "Formula path:   ${FORMULA_PATH}"
echo

echo "Downloading latest release..."
wget -O $RELEASE_DOWNLOAD_PATH $RELEASE_DOWNLOAD_URL
echo

echo "Calculating SHA256..."
SHA256=$(shasum -a 256 $RELEASE_DOWNLOAD_PATH | awk '{print $1}')
echo "SHA256: $SHA256"
echo

echo "Updating formula..."
sed -i '' -e "s|url \".*\"|url \"${RELEASE_DOWNLOAD_URL}\"|g" $FORMULA_PATH
sed -i '' -e "s|sha256 \".*\"|sha256 \"${SHA256}\"|g" $FORMULA_PATH
sed -i '' -e "s|version \".*\"|version \"${LATEST_RELEASE}\"|g" $FORMULA_PATH
echo

# regenerate Info/*.json for all formulae
$INFO_PATH="Info/${FORMULA_FILENAME/%rb/json}"
echo "Updating info json: $INFO_PATH"
mkdir -p Info
FORMULA_FILENAME=$(basename $FORMULA_PATH)
brew info --json "$FORMULA_PATH" | jq '.[0]? // .' > $INFO_PATH
echo

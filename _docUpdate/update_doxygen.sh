#!/bin/bash
# ex: ts=4 sw=4 et filetype=sh nu

GIT_REPO_URL=$1

pushd `dirname $0` > /dev/null
ABS_PATH=$PWD
popd > /dev/null

TARGET_DIR=$ABS_PATH/../doxygen

CLR_RED="\033[31m"
CLR_RST="\033[m"
notice ()
{
    echo -e "${CLR_RED}${1}${CLR_RST}"
}

fatal ()
{
    notice "FATAL: $1"
    exit 1
}

warn ()
{
    notice "WARNING: $1"
}

RC_GOOD=0
RC_BAD=1

if [ "$GIT_REPO_URL" == "" ]; then
    fatal "Must get a git repository URL (local or remote)"
fi

TMP_MASTER_DIRNAME=BackgroundSubtractorCNT
TMP_MASTER=$HOME/tmp/$TMP_MASTER_DIRNAME
rm -rf $TMP_MASTER
mkdir -p $TMP_MASTER
cd $HOME/tmp
if ! `git clone $GIT_REPO_URL -b master --single-branch $TMP_MASTER_DIRNAME`; then
    fatal "Failed to clone '$GIT_REPO_URL'"
fi
cd $TMP_MASTER
git checkout master

# Copy all the needed files
cd $ABS_PATH
cp doxygen_style.css doxygen_header.html.in $TMP_MASTER

# Generate doxygen
cd $TMP_MASTER
mkdir build
cd build
cmake -DBUILD_DOCUMENTATION=ON ..
make doc
cd ..
rm -rf $TARGET_DIR

# HACK1: modify images with maps to be in a scrollable div
find doc/html -type f -name "*html" |xargs grep -l 'img.*usemap'| xargs perl -i -pe 's/<img (.* usemap.*>)/<div style="overflow: auto;"><img style="max-width: 4096px;" $1<\/div>/'
notice "\nCheck doxygen inheritance graphs correctness"

# HACK2: move the search box (see also main.scss for the added containers used in recreate_search_box.pl)
searchBoxFiles=`find doc/html -type f -name "*html" |xargs grep -l 'div.*id="MSearchBox"'`
for file in $searchBoxFiles; do

    # 1. Create the search box in a frame & Remove all search related divs
    perl -i -ne 's/new SearchBox\("searchBox", "search",false/new SearchBox("searchBox", "search",true/; if (/div.*id="MSearch/ ... /div/) {} else {print}' $file

    # 2. Put the search boxes in a container
    tmp_file=${file}.tmp.input
    mv $file $tmp_file
    $ABS_PATH/recreate_search_box.pl $tmp_file $file
    rm $tmp_file

done;
notice "\nCheck doxygen search-box correctness"

# Take doxygen output
mv doc $TARGET_DIR

# Cleanup temp dir
rm -rf $TMP_MASTER


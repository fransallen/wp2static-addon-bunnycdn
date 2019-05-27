#!/bin/bash

######################################
##
## Build WP2Static for wp.org
##
## script archive_name dont_minify
##
## places archive in $HOME/Downloads
##
######################################

# run script from project root
EXEC_DIR=$(pwd)

TMP_DIR=$HOME/plugintmp
rm -Rf $TMP_DIR
mkdir -p $TMP_DIR

rm -Rf $TMP_DIR/wp2static-addon-bunnycdn
mkdir $TMP_DIR/wp2static-addon-bunnycdn


# clear dev dependencies
rm -Rf $EXEC_DIR/vendor/*
# load prod deps
composer install --no-dev --optimize-autoloader


# cp all required sources to build dir
cp -r $EXEC_DIR/src $TMP_DIR/wp2static-addon-bunnycdn/
cp -r $EXEC_DIR/js $TMP_DIR/wp2static-addon-bunnycdn/
cp -r $EXEC_DIR/vendor $TMP_DIR/wp2static-addon-bunnycdn/
cp -r $EXEC_DIR/README.txt $TMP_DIR/wp2static-addon-bunnycdn/
cp -r $EXEC_DIR/LICENSE.txt $TMP_DIR/wp2static-addon-bunnycdn/
cp -r $EXEC_DIR/views $TMP_DIR/wp2static-addon-bunnycdn/
cp -r $EXEC_DIR/wp2static-addon-bunnycdn.php $TMP_DIR/wp2static-addon-bunnycdn/
cp -r $EXEC_DIR/wp2static-addon-bunnycdn.css $TMP_DIR/wp2static-addon-bunnycdn/

cd $TMP_DIR

# tidy permissions
find . -type d -exec chmod 755 {} \;
find . -type f -exec chmod 644 {} \;

# strip comments and whitespace from each PHP file
if [ -z "$2" ]; then
  find .  ! -name 'wp2static.php' -name \*.php -exec $EXEC_DIR/tools/compress_php_file {} \;
fi

zip -r -9 ./$1.zip ./wp2static-addon-bunnycdn

cd -

cp $TMP_DIR/$1.zip $HOME/Downloads/

# reset dev dependencies
cd $EXEC_DIR
# clear dev dependencies
rm -Rf $EXEC_DIR/vendor/*
# load prod deps
composer install

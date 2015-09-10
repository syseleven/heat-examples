#!/bin/sh

# shop source (git repo)
shop_source="https://github.com/proudcommerce/oxid-downloads.git"

# shop version (git branch)
shop_version="CE-4.9.4"
# shop install directory
shop_dir="/var/www/nginx/html"
# shop url
shop_url="http://oxidshop.syseleven.de"
# shop url subdirectory
shop_url_dir=""
# shop utf8 mode
shop_utf8=true
shop_utf8_config=1

# shop demodata
shop_demotdata=true

# shop database host
db_host="db0.local"

# shop database user
db_user="syseleven"

# shop database password
db_pass="syselevenpass"

# shop database name
db_name="syseleven"

# ioly module manager
install_ioly=false
shop_tmp="$shop_dir/tmp"

sleep 20;

mkdir $shop_dir

cd $shop_dir && git clone $shop_source $shop_dir

cd $shop_dir && git checkout $shop_version

cd $shop_dir && chmod -R 777 out/pictures/ out/media/ log/ tmp/ export/ && chmod 666 .htaccess config.inc.php

cd $shop_dir && mysql -h$db_host -u$db_user -p$db_pass $db_name < setup/sql/database.sql

if [ $shop_utf8 = true ]
then
	echo "----------"
	echo "### setting database to utf8"
	echo "----------"
	cd $shop_dir && mysql -h$db_host -u$db_user -p$db_pass $db_name < setup/sql/latin1_to_utf8.sql
	shop_utf8_config=1
fi

if [ $shop_demotdata = true ]
then
	echo "----------"
	echo "### insert demodata into database"
	echo "----------"
	cd $shop_dir && mysql -h$db_host -u$db_user -p$db_pass $db_name --default-character-set=latin1 < setup/sql/demodata.sql
fi

cd $shop_dir && sed -i "s|<dbHost_ce>|$db_host|g" "config.inc.php" && sed -i "s|<dbName_ce>|$db_name|g" "config.inc.php" && sed -i "s|<dbUser_ce>|$db_user|g" "config.inc.php" && sed -i "s|<dbPwd_ce>|$db_pass|g" "config.inc.php" && sed -i "s|<sShopURL_ce>|"$shop_url"/"$shop_url_dir"|g" "config.inc.php" && sed -i "s|<sShopDir_ce>|$shop_dir|g" "config.inc.php" && sed -i "s|<sCompileDir_ce>|$shop_tmp|g" "config.inc.php" && sed -i "s|<iUtfMode>|$shop_utf8_config|g" "config.inc.php"
cd $shop_dir && sed -i "s|RewriteBase /|RewriteBase /$shop_url_dir|g" ".htaccess" 

cd $shop_dir && rm -rf setup/ documentation/

cd $shop_dir; chmod 444 .htaccess config.inc.php

echo "----------"
echo "### installation done"
echo "----------"
echo "shop url: $shop_url"
echo "shop admin url: "$shop_url"/"$shop_url_dir"admin"
echo "shop admin user: admin"
echo "shop admin password: admin"


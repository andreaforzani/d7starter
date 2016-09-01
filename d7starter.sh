#!/bin/bash

# Site
##########################################################
siteName="Drupal 7 Site"
siteSlogan="Test drupal 7 site"
siteLocale="en"
##########################################################

# Database
##########################################################
dbHost="localhost"
dbName="d7test"
dbUser="mydbuser"
dbPassword="mydbpassword"
##########################################################

# Admin
##########################################################
AdminUsername="admin"
AdminPassword="admin"
adminEmail="admin@example.com"
##########################################################

echo -e "////////////////////////////////////////////////////"
echo -e "// Download core"
echo -e "////////////////////////////////////////////////////"

# Download Core
##########################################################

drush dl drupal-7 -y --drupal-project-rename="drupal";
mv drupal/{.,}* ./;

rmdir drupal;

mkdir sites/all/modules/contrib;
mkdir sites/all/modules/custom;
mkdir sites/all/modules/features;
mkdir sites/all/modules/devel;

mkdir tmp;

echo -e "////////////////////////////////////////////////////"
echo -e "// Install core"
echo -e "////////////////////////////////////////////////////"

# Install core
##########################################################
drush site-install -y standard --account-mail=$adminEmail --account-name=$AdminUsername --account-pass=$AdminPassword --site-name=$siteName --site-mail=$adminEmail --locale=$siteLocale --db-url=mysql://$dbUser:$dbPassword@$dbHost/$dbName;

echo -e "////////////////////////////////////////////////////"
echo -e "// Download modules and themes"
echo -e "////////////////////////////////////////////////////"

# Download modules and themes
##########################################################
drush -y dl \
admin_views \
adminimal_theme \
backup_migrate \
ctools \
ckeditor \
ckeditor_link \
coder \
date \
devel \
diff \
entity \
eu_cookie_compliance \
features \
fences \
field_group \
globalredirect \
imce \
jquery_update \
libraries \
masquerade \
menu_block \
metatag \
module_filter \
navbar \
navbar_flush_cache \
pathauto \
redirect \
simplified_menu_admin \
social_media_links \
strongarm \
token \
views \
views_bulk_operations \
webform \
xmlsitemap \
zen;

# Disable some core modules
##########################################################
drush -y dis \
overlay \
toolbar;

mv sites/all/modules/contrib/devel sites/all/modules/devel;
mv sites/all/modules/contrib/coder sites/all/modules/devel;
mv sites/all/modules/contrib/diff sites/all/modules/devel;

echo -e "////////////////////////////////////////////////////"
echo -e "// Enable modules and themes"
echo -e "////////////////////////////////////////////////////"

# Enable modules
##########################################################
drush -y en \
admin_views \
backup_migrate \
ctools \
ckeditor \
ckeditor_link \
coder \
date \
devel \
diff \
entity \
eu_cookie_compliance \
features \
fences \
field_group \
globalredirect \
imce \
jquery_update \
libraries \
masquerade \
menu_block \
metatag \
module_filter \
navbar \
navbar_flush_cache \
pathauto \
redirect \
simplified_menu_admin \
social_media_links \
strongarm \
token \
views \
views_bulk_operations \
webform \
xmlsitemap \
zen;

#  Call navbar makefile to download libraries dependecies
##########################################################
drush make sites/all/modules/contrib/navbar/navbar.make.example --no-core --shallow-clone

echo -e "////////////////////////////////////////////////////"
echo -e "// Pre configure settings"
echo -e "////////////////////////////////////////////////////"

# Pre configure settings
##########################################################
# disable user pictures
drush vset -y user_pictures 0;
# allow only admins to register users
drush vset -y user_register 0;
# set site slogan
drush vset -y site_slogan $siteSlogan;

drush vset admin_theme adminimal;

echo -e "////////////////////////////////////////////////////"
echo -e "// Install Completed"
echo -e "////////////////////////////////////////////////////"
while true; do
    read -p "press enter to exit" yn
    case $yn in
        * ) exit;;
    esac
done
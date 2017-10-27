
function pdrushdb() {  
  # This works if:
  # -you have terminus and drush installed
  # -when you ran git clone, you didn't specify a directory name
  # and used the default directory name.
  
  # Usage:
  # cd into the root drupal directory. If you don't specify an arugment it gets the live database.
  # pdrushdb [dev|test]
  # E.g.) drushdb test
  
  # Gets the current directory name. This corresponds to pantheons site alias.
  pantheon_site_alias=${PWD##*/}

  local DRUPAL_VERSION="$(drush php-eval 'echo drush_drupal_major_version();')"
  if [ ! $DRUPAL_VERSION ]; then
    echo "No Drupal installation found."
    echo "Run this command from the root of a Drupal site that is hosted on Pantheon"
    return 1
  fi
  
  if [ -z "$1" ]; then
    environment="live"
    # if no argument is specified, we assume we'll get the live database.
    # Grabbing from the live environment.    
  else
    environment=$1
  fi
  
  timestamp=`date '+%b%d_%I-%M%p'`
  
  echo "Creating a backup on the ${environment} environment."
  
  # Turn on printing commands for learning.
  set -x
  
  terminus backup:create $pantheon_site_alias.$environment --element=db
  # Actually download the database.
  terminus backup:get $pantheon_site_alias.$environment --element=db --to=./$pantheon_site_alias-$environment-$timestamp.sql.gz
  
  # Turn off the printing of commands.
  { set +x; } 2>/dev/null
  
  if file "${pantheon_site_alias}-${environment}-$timestamp.sql.gz" | grep -q "gzip compressed data"; then
    echo "G G G G G-UNZIP"
    echo "gunzip -c $pantheon_site_alias-$environment-$timestamp.sql.gz | drush sql-cli"
    gunzip -c $pantheon_site_alias-$environment-$timestamp.sql.gz | drush sql-cli
  else
    # I don't think this ever happens.
    echo "Importing..."
    drush sql-cli $pantheon_site_alias.$environment-$timestamp.sql
  fi


}




function tdeploy() {  
  # This works if:
  # -you have terminus and drush installed
  # -when you ran git clone, you didn't specify a directory name
  # and used the default directory name.
  
  # Usage:
  # cd into the root drupal directory. If you don't specify an arugment it gets the live database.
  # pdrushdb [dev|test]
  # E.g.) drushdb test
  
  # Gets the current directory name. This corresponds to pantheons site alias.
  pantheon_site_alias=${PWD##*/}

  local DRUPAL_VERSION="$(drush php-eval 'echo drush_drupal_major_version();')"
  if [ ! $DRUPAL_VERSION ]; then
    echo "No Drupal installation found."
    echo "Run this command from the root of a Drupal site that is hosted on Pantheon"
    return 1
  fi
  
  if [ -z "$1" ]; then
    echo "Specify the environment to deploy to with the first argument.  e.g.) tdeploy test"  
  else
    environment=$1
  fi
  set -x
  terminus env:deploy $pantheon_site_alias.$environment --note "$2"
  # Turn off the printing of commands.
  { set +x; } 2>/dev/null
}

#Clear cache

function tcc() {  
  # This works if:
  # -you have terminus and drush installed
  # -when you ran git clone, you didn't specify a directory name
  # and used the default directory name.
  
  # Usage:
  # cd into the root drupal directory. If you don't specify an arugment it gets the live database.
  # pdrushdb [dev|test]
  # E.g.) drushdb test
  
  # Gets the current directory name. This corresponds to pantheons site alias.
  pantheon_site_alias=${PWD##*/}

  local DRUPAL_VERSION="$(drush php-eval 'echo drush_drupal_major_version();')"
  if [ ! $DRUPAL_VERSION ]; then
    echo "No Drupal installation found."
    echo "Run this command from the root of a Drupal site that is hosted on Pantheon"
    return 1
  fi
  
  if [ -z "$1" ]; then
    echo "Specify the environment to clear cache to with the first argument.  e.g.) tcc test"  
  else
    environment=$1
  fi
  set -x
  terminus env:clear-cache $pantheon_site_alias.$environment
  # Turn off the printing of commands.
  { set +x; } 2>/dev/null
}

#Runs Cron 
function tcr() {  
  # This works if:
  # -you have terminus and drush installed
  # -when you ran git clone, you didn't specify a directory name
  # and used the default directory name.
  
  # Usage:
  # cd into the root drupal directory. If you don't specify an arugment it gets the live database.
  # pdrushdb [dev|test]
  # E.g.) drushdb test
  
  # Gets the current directory name. This corresponds to pantheons site alias.
  pantheon_site_alias=${PWD##*/}

  local DRUPAL_VERSION="$(drush php-eval 'echo drush_drupal_major_version();')"
  if [ ! $DRUPAL_VERSION ]; then
    echo "No Drupal installation found."
    echo "Run this command from the root of a Drupal site that is hosted on Pantheon"
    return 1
  fi
  
  if [ -z "$1" ]; then
    echo "Specify the environment to run cron to with the first argument.  e.g.) tcr test"  
  else
    environment=$1
  fi
  set -x
  terminus env:cron $pantheon_site_alias.$environment
  # Turn off the printing of commands.
  { set +x; } 2>/dev/null
}




function importtopanth() {
if [ $# -lt 1 ]
then
  echo "Usage: $0 @pantheon-alias"
  exit
fi

echo "fetching connection string"
CONNECTION_STRING `drush $1 sql-connect`
echo $CONNECTION_STRING
DATABASE=`echo $CONNECTION_STRING | sed -e 's/.*--database=\([^\\ ]*\).*/\1/g'`
HOST=`echo $CONNECTION_STRING | sed -e 's/.*--host=\([^\\ ]*\).*/\1/g'`
PORT=`echo $CONNECTION_STRING | sed -e 's/.*--port=\([^\\ ]*\).*/\1/g'`
PASSWORD=`echo $CONNECTION_STRING | sed -e 's/.*--password=\([^\\ ]*\).*/\1/g'`
USER=`echo $CONNECTION_STRING | sed -e 's/.*--user=\([^\\ ]*\).*/\1/g'`


}




#Backs up DB
function pbackup() {  
  # This works if:
  # -you have terminus and drush installed
  # -when you ran git clone, you didn't specify a directory name
  # and used the default directory name.
  
  # Usage:
  # cd into the root drupal directory. If you don't specify an arugment it gets the live database.
  # pdrushdb [dev|test]
  # E.g.) drushdb test
  
  # Gets the current directory name. This corresponds to pantheons site alias.
  pantheon_site_alias=${PWD##*/}

  local DRUPAL_VERSION="$(drush php-eval 'echo drush_drupal_major_version();')"
  if [ ! $DRUPAL_VERSION ]; then
    echo "No Drupal installation found."
    echo "Run this command from the root of a Drupal site that is hosted on Pantheon"
    return 1
  fi
  
  if [ -z "$1" ]; then
    echo "Specify the environment to backup to with the first argument.  e.g.) pbackup test"  
  else
    environment=$1
  fi
  set -x
  terminus backup:create $pantheon_site_alias.$environment --element=db
  
  # Turn off the printing of commands.
  { set +x; } 2>/dev/null
}




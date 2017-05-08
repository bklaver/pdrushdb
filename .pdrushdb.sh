
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
    echo "Specify the environment to deploy to with the first argument.  e.g.) tdeploy test"  
  else
    environment=$1
  fi
  set -x
  terminus env:clear-cache $pantheon_site_alias.$environment
  # Turn off the printing of commands.
  { set +x; } 2>/dev/null
}





function agopantheondb() {  
  # This works if:
  # -you have terminus and drush installed
  # -when you ran git clone, you didn't specify a directory name
  # and used the default directory name.
  
  # Usage:
  # cd into the root drupal directory. If you don't specify an arugment it gets the live database.
  # pdrushdb [dev|test]
  # E.g.) drushdb test
  
  # Gets the current directory name. This corresponds to pantheons site alias.
  pantheon_site_alias=ago

  local DRUPAL_VERSION="$(drush php-eval 'echo drush_drupal_major_version();')"
  if [ ! $DRUPAL_VERSION ]; then
    echo "No Drupal installation found."
    echo "Run this command from the root of a Drupal site that is hosted on Pantheon"
    return 1
  fi
  
  environment=test
  
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



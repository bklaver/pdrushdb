

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

  if [ -z "$1" ]; then
    environment="live"
    # if no argument is specified, we assume we'll get the live database.
    # Grabbing from the live environment.    
  else
    environment=$1
        echo $environment
    echo test
    
  fi
  
  echo "Create backup on ${environment} server"
  echo "terminus backup:create $pantheon_site_alias.$environment --element=db"
  terminus backup:create $pantheon_site_alias.$environment --element=db
  echo "Download backup as $pantheon_site_alias.sql.gz"
  echo "terminus backup:get $pantheon_site_alias.$environment --element=db --to=./$pantheon_site_alias-$environment.sql.gz"
  terminus backup:get $pantheon_site_alias.$environment --element=db --to=./$pantheon_site_alias-$environment.sql.gz
  
  if file "${pantheon_site_alias}-${environment}.sql.gz" | grep -q "gzip compressed data"; then
    echo "Gunzip and importing..."
    gunzip -c $pantheon_site_alias.$environment.sql.gz | drush sql-cli
  else
    # I don't think this ever happens.
    echo "Importing..."
    drush sql-cli $pantheon_site_alias.$environment
  fi

}

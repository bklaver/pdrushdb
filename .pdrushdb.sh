

function pdrushdb() {
  # This works if:
  # -you have terminus and drush installed
  # -when you ran git clone, you didn't specify a directory name
  # and used the default directory name.
  
  # Gets the current directory name. This corresponds to pantheons site alias.
  pantheon_site_alias=${PWD##*/}
  echo "Create backup on live server"
  terminus backup:create $pantheon_site_alias.test --element=db
  echo "Download backup as $pantheon_site_alias.sql.gz"
  terminus backup:get $pantheon_site_alias.test --element=db --to=./$pantheon_site_alias.sql.gz
  
  if file "${pantheon_site_alias}.sql.gz" | grep -q "gzip compressed data"; then
    echo "Gunzip and importing..."
    gunzip -c ${PWD##*/}.sql.gz | drush sql-cli
  else
    # I don't think this ever happens.
    echo "Importing..."
   drush sql-cli $pantheon_site_alias
  fi

}

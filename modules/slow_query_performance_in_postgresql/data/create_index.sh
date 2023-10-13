bash

#!/bin/bash



# Set variables

DB_NAME=${DATABASE_NAME}

TABLE_NAME=${TABLE_NAME}

COLUMN_NAME=${COLUMN_NAME}



# Check if indexing exists on column

INDEX_EXISTS=$(psql -U postgres -d $DB_NAME -c "\d+ $TABLE_NAME" | grep -o "$COLUMN_NAME" | wc -l)



# If indexing does not exist, create an index

if [ "$INDEX_EXISTS" -eq "0" ]; then

  psql -U postgres -d $DB_NAME -c "CREATE INDEX idx_$TABLE_NAME\_$COLUMN_NAME ON $TABLE_NAME ($COLUMN_NAME);"

  echo "Index created successfully."

else

  echo "Index already exists."

fi
#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

# If no arg is provided
if [[ ! $1 ]]
then
  echo "Please provide an element as an argument."
else
  # If arg is an atomic number
  if [[ $1 =~ ^[0-9]+$ ]]
  then
    NAME=$($PSQL "SELECT name FROM elements WHERE atomic_number = $1")

    # If the number is present in atomic_number column
    if [[ $NAME ]]
    then
      # Get the rest of the data
      SYMBOL=$($PSQL "SELECT symbol FROM elements WHERE atomic_number = $1")
      TYPE=$($PSQL "SELECT type FROM types JOIN properties USING(type_id) WHERE properties.atomic_number = $1")
      MASS=$($PSQL "SELECT atomic_mass FROM properties WHERE atomic_number = $1")
      MELTING_POINT=$($PSQL "SELECT melting_point_celsius FROM properties WHERE atomic_number = $1")
      BOILING_POINT=$($PSQL "SELECT boiling_point_celsius FROM properties WHERE atomic_number = $1")

      # Print the message
      echo "The element with atomic number $1 is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
    else
      # If the element is not present in the elements table
      echo "I could not find that element in the database."
    fi
  
  # If arg is a symbol
  elif [[ $1 =~ ^[A-Z][a-z]?$ ]]
  then
    NAME=$($PSQL "SELECT name FROM elements WHERE symbol = '$1'")
    
    # If the symbol is present in symbol column
    if [[ $NAME ]]
    then
      # Get the rest of the data
      NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE symbol = '$1'")
      TYPE=$($PSQL "SELECT type FROM types JOIN properties USING(type_id) WHERE properties.atomic_number = $NUMBER")
      MASS=$($PSQL "SELECT atomic_mass FROM properties WHERE atomic_number = $NUMBER")
      MELTING_POINT=$($PSQL "SELECT melting_point_celsius FROM properties WHERE atomic_number = $NUMBER")
      BOILING_POINT=$($PSQL "SELECT boiling_point_celsius FROM properties WHERE atomic_number = $NUMBER")

      # Print the message
      echo "The element with atomic number $NUMBER is $NAME ($1). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
    else
      # If the element is not present in the elements table
      echo "I could not find that element in the database."
    fi

  # If arg is an element's name
  elif [[ $1 =~ ^[A-Z][a-z]+$ ]]
  then
    NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE name = '$1'")

    # If the name is present in name column
    if [[ $NUMBER ]]
    then
      # Get the rest of the data
      SYMBOL=$($PSQL "SELECT symbol FROM elements WHERE name = '$1'")
      TYPE=$($PSQL "SELECT type FROM types JOIN properties USING(type_id) WHERE properties.atomic_number = $NUMBER")
      MASS=$($PSQL "SELECT atomic_mass FROM properties WHERE atomic_number = $NUMBER")
      MELTING_POINT=$($PSQL "SELECT melting_point_celsius FROM properties WHERE atomic_number = $NUMBER")
      BOILING_POINT=$($PSQL "SELECT boiling_point_celsius FROM properties WHERE atomic_number = $NUMBER")

      # Print the message
      echo "The element with atomic number $NUMBER is $1 ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $1 has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
    else
      # If the element is not present in the elements table
      echo "I could not find that element in the database."
    fi
  else
    echo "I could not find that element in the database."
  fi
fi
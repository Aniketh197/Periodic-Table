#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

# Check if an argument is provided
if [[ -z $1 ]]
then
  echo "Please provide an element as an argument."
  exit 0
fi
# Determine if input is a number (atomic_number) or a string (name/symbol)
if [[ $1 =~ ^[0-9]+$ ]]
then
  QUERY="SELECT atomic_number, name, symbol, type, atomic_mass, melting_point_celsius, boiling_point_celsius 
         FROM elements 
         JOIN properties USING(atomic_number) 
         JOIN types USING(type_id) 
         WHERE atomic_number = $1"
else
  QUERY="SELECT atomic_number, name, symbol, type, atomic_mass, melting_point_celsius, boiling_point_celsius 
         FROM elements 
         JOIN properties USING(atomic_number) 
         JOIN types USING(type_id) 
         WHERE symbol = '$1' OR name = '$1'"
fi
# Fetch element details
ELEMENT=$($PSQL "$QUERY")

# Check if element exists
if [[ -z $ELEMENT ]]
then
  echo "I could not find that element in the database."
  exit 0
fi

# Read and format output
IFS="|" read -r ATOMIC_NUMBER NAME SYMBOL TYPE MASS MELTING BOILING <<< "$ELEMENT"
echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELTING celsius and a boiling point of $BOILING celsius."

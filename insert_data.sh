#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

echo $($PSQL "TRUNCATE teams, games")

cat games.csv | while IFS=',' read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do 
#get winner id 
WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER' ")
if [[ $WINNER != 'winner' ]]
then
#check if it's already inserted to the table 
  if [[ -z $WINNER_ID ]] 
  then 
  INSERT_TEAM=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")
  if [[ $INSERT_TEAM == "INSERT 0 1" ]]
  then
  echo Inserted $WINNER
    fi
  fi
fi
#get opponent id
OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT' ")
#remove title 
if [[ $OPPONENT != 'opponent' ]]
then
#check if it's empty
  if [[ -z $OPPONENT_ID ]] 
  then 
  #insert data to table
  INSERT_TEAM2=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")
    if [[ $INSERT_TEAM2 == "INSERT 0 1" ]]
    then 
    #print confirmation in the terminal 
     echo Inserted $OPPONENT
    fi
  fi
fi

TEAM_ID_W=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
TEAM_ID_O=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")

if [[ -n $TEAM_ID_W || -n $TEAM_ID_O ]]
then
 if [[ $YEAR != "year" ]]
 then
  INSERTED_GAMES=$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES($YEAR, '$ROUND', $TEAM_ID_W, $TEAM_ID_O, $WINNER_GOALS, $OPPONENT_GOALS)")                                                                                                 
    if [[ $INSERTED_GAMES == "INSERT 0 1" ]]
    then 
    echo Inserted into games, $YEAR
    fi
  fi
fi



done


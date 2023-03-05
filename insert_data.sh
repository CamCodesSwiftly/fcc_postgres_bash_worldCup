#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
#INSERTING TEAMS
echo "Starting registering Teams"
cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNERGOALS OPPONENTGOALS
do
  #INSERTING WINNER INTO TEAMS
  if [[ $WINNER != "winner" ]]
  then
    #1. see if there's already a team id
    TEAM_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
    if [[ -z $TEAM_ID ]]
    then
      #2. if the team is not already registered, register it in table teams
      INSERT_TEAM_RESULT=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")
    fi
  fi

  #INSERTING OPPONENT INTO TEAMS
  if [[ $OPPONENT != "opponent" ]]
  then
    #1. see if there's already a team id
    TEAM_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
    if [[ -z $TEAM_ID ]]
    then
      #2. if the team is not already registered, register it in table teams
      INSERT_TEAM_RESULT=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")
    fi
  fi
done
echo "Done registering Teams"


#INSERTING INTO GAMES 
echo "Starting registering Games"
cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNERGOALS OPPONENTGOALS
do
  #INSERTING WINNER INTO GAMES
  if [[ $WINNER != "winner" ]]
  then
    #1. get the winner's team_id
    WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
    #2 get the opponent's team_id
    OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
    #4 insert all
    INSERT_INTO_GAMES_RESULT=$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES($YEAR, '$ROUND', $WINNER_ID, $OPPONENT_ID, $WINNERGOALS, $OPPONENTGOALS)")
  fi
done
echo "Done registering Games"
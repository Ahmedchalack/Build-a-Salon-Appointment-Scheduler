#! /bin/bash
echo -e "\n~~~~~ MY SALON ~~~~~\n"
echo -e "\nWelcome to My Salon, how can I help you?"
function MENU_SALON(){
if [[ $1 ]]
then 
echo -e "\n$1"
fi
  psql --username=freecodecamp --dbname=salon --tuples-only -c "SELECT * FROM services" |  while read ID NAME
  do 
  echo "$ID$NAME" | sed 's/|/)/' 
  done
  read SERVICE_ID_SELECTED

    if [[  -z $(psql --username=freecodecamp --dbname=salon --tuples-only -c "SELECT name  FROM services WHERE service_id = '$SERVICE_ID_SELECTED'") ]]
    then 
    MENU_SALON "I could not find that service. What would you like today?"
     else 
      SERVICE=$(psql --username=freecodecamp --dbname=salon --tuples-only -c "SELECT name  FROM services WHERE service_id = '$SERVICE_ID_SELECTED'")
      echo -e "\nWhat's your phone number?"
      read CUSTOMER_PHONE
      if [[ -z $(psql --username=freecodecamp --dbname=salon --tuples-only -c "SELECT phone  FROM customers WHERE phone = '$CUSTOMER_PHONE'") ]]
      then
            #phone don't exist
      echo -e "\nI don't have a record for that phone number, what's your name?"
      read CUSTOMER_NAME 
      INSERT_CUSTOMER=$(psql --username=freecodecamp --dbname=salon -c "INSERT INTO customers(phone, name) VALUES('$CUSTOMER_PHONE', '$CUSTOMER_NAME')")
      echo $INSERT_CUSTOMER
      #time
      echo -e "\nWhat time would you like your $SERVICE, $NAME?"
      read SERVICE_TIME
      ID_customer=$(psql --username=freecodecamp --dbname=salon --tuples-only -c "SELECT customer_id  FROM customers WHERE phone = '$CUSTOMER_PHONE'")
       INSERT_TIME=$(psql --username=freecodecamp --dbname=salon -c "INSERT INTO appointments(customer_id, service_id, time) VALUES('$ID_customer', '$SERVICE_ID_SELECTED', '$SERVICE_TIME')")
      echo $INSERT_TIME
      echo "I have put you down for a $SERVICE at $SERVICE_TIME, $CUSTOMER_NAME."
      else
         #phone  exist
      NAME_EXIST=$(psql --username=freecodecamp --dbname=salon --tuples-only -c "SELECT name  FROM customers WHERE phone = '$CUSTOMER_PHONE'")   
      echo -e "\nWhat time would you like your $SERVICE, $NAME_EXIST?"
      read SERVICE_TIME
      ID_customer=$(psql --username=freecodecamp --dbname=salon --tuples-only -c "SELECT customer_id  FROM customers WHERE phone = '$CUSTOMER_PHONE'")
       INSERT_TIME=$(psql --username=freecodecamp --dbname=salon -c "INSERT INTO appointments(customer_id, service_id, time) VALUES('$ID_customer', '$SERVICE_ID_SELECTED', '$SERVICE_TIME')")
      echo $INSERT_TIME
      echo "I have put you down for a $SERVICE at $SERVICE_TIME, $NAME_EXIST."
      fi
    fi
   
}

MENU_SALON 

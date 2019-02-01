ACCOUNT=ubuntu
if [ $(grep -c "^$ACCOUNT:" /etc/passwd) -eq 0 ]; then
  echo "Missing user $ACCOUNT. Creating "
  adduser $ACCOUNT
  usermod -aG sudo $ACCOUNT
  usermod -aG docker $ACCOUNT
fi

sudoers_record=$(cat /etc/sudoers | grep $ACCOUNT)
if [ "$sudoers_record" = "" ]; then
  echo "Missing /etc/sudoers record"
  echo "$ACCOUNT  ALL=(ALL) NOPASSWD:ALL" | sudo tee -a /etc/sudoers
fi

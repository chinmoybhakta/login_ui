
RegExp gmail = RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$");
RegExp password = RegExp(r"^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&+-/%!#_-])[A-Za-z\d@$!%*?&+-/%!#_-]{8,}$");

bool check_gmail(String mail) {
  if(gmail.hasMatch(mail)) return true;
  else return false;
}

bool check_password(String pass) {
  if(password.hasMatch(pass)) return true;
  else return false;
}
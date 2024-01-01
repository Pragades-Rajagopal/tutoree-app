Map<String, String> endpoints = {
  "login": "/api/login",
  "user": "/api/users",
};

Map<String, String> apiHeader = {
  'Content-type': 'application/json',
  'Accept': 'application/json'
};

Map<String, String> alertDialog = {
  'IncorrectPassword': 'please enter the correct password',
  'passwordCharacter': 'password must be atleast 6 characters',
  'loginErrorTitle': 'login error',
  'userNotRegistered': 'user not registered or OTP not verified',
  'registerErrorTitle': 'registration error',
  'mobileNoExists': 'mobile number already exists',
  'emailExists': 'email already exists',
};

Map<String, String> responseErrors = {
  'UNIQUE_mobile_no': 'UNIQUE constraint failed: users.mobile_no',
  'UNIQUE_email': 'UNIQUE constraint failed: users.email',
};

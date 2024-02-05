Map<String, String> endpoints = {
  "login": "/api/login",
  "logout": "/api/logout",
  "user": "/api/users",
  "otp": "/api/validate-otp",
  "resendOtp": "/api/resend-otp",
  "resetPassword": "/api/reset-password",
  "studentTutorList": "/api/student/tutor-list",
  "sendTutorRequest": "/api/student/request",
  "studentProfile": "/api/student/interest",
  "feed": "/api/feed",
  "tutorProfile": "/api/tutor/profile",
  "feeduserData": "/api/feed-user",
  "studentListForTutor": "/api/tutor/request",
  "course": "/api/all-courses",
  "addStudentInterest": "/api/student/interest",
  "addTutorProfile": "/api/tutor/profile",
  "deactivate": "/api/deactivate",
};

Map<String, String> apiHeader = {
  'Content-type': 'application/json',
  'Accept': 'application/json'
};

Map<String, String> alertDialog = {
  'relax': 'relax',
  'IncorrectPassword': 'please enter the correct password',
  'passwordCharacter': 'password must be atleast 6 characters',
  'loginErrorTitle': 'login error',
  'userNotRegistered': 'user not registered or OTP not verified',
  'registerErrorTitle': 'registration error',
  'mobileNoExists': 'mobile number already exists',
  'emailNotExists': 'email does not exists',
  'emailExists': 'email already exists',
  'otpNotValidated': 'OTP not validated',
  'otpValidated': 'OTP validated',
  'rerouteLoginPage': 'redirecting to login page',
  'oops': 'oops',
  'commonError': 'something went wrong',
  'commonSuccess': 'success',
  'emailSent': 'OTP sent to your registered email address',
  'passResetSuccess': 'password reset successful',
  'emailNotExistsOrUnregistered': 'email does not exists or not active',
  'tutorReqExists': 'request has already been sent',
  'tutorReqError': 'unable to send request at this moment',
  'tutorReqSuccess': 'request sent successfully',
  'addFeedError': 'unable to add feed at this moment',
  'addFeedSuccess': 'feed added successfully',
  'addIntrstCheckError':
      'Either the user is not a student or not yet activated as student',
  'interestAdded': 'Interests added',
  'deleteFeed': 'feed deleted successfully',
  'deleteFeedError': 'Error while deleting feed',
  'deactivationSuccess': 'Account deactivated',
};

Map<String, String> responseErrors = {
  'UNIQUE_mobile_no': 'UNIQUE constraint failed: users.mobile_no',
  'UNIQUE_email': 'UNIQUE constraint failed: users.email',
};

Map<String, String> textFieldErrors = {
  'email': 'email is mandatory',
  'mobile': 'mobile number is mandatory with 10 digits',
  'password': 'password is mandatory with greater than 6 characters',
  'mandatory': 'this field is mandatory',
  'otp_mandatory': 'enter 4 digit otp',
  'add_feed_mandatory': 'enter something',
  'add_interest_mandatory': 'add atleast one interest'
};

Map<String, String> commonConfig = {
  'support_email': 'hello@tutoree.com',
};

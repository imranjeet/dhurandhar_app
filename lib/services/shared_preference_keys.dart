// If keys changed, make sure to update them in the kotlin code too!

class SharedPreferenceKeys {
  ///Token related Keys
  static const String accessToken = 'accessToken';
  static const String deviceId = 'deviceId';

  ///FCM
  static const String pushNotificationToken = 'pushNotificationToken';
  static const String pushNotificationSaved = 'pushNotificationSaved';

  // User settings
  static const String firebaseLogin = 'firebaseLogin';
  static const String vibrateOnOffer = 'vibrateOnOffer';
  static const String isBatteryOptimization = 'isBatteryOptimization';
  static const String timerLimit = 'timerLimit';


  //Flags
  static const String autoStartOnLaunchFlag = 'autoStartOnLaunchFlag';
  static const String firstLaunch = 'firstLaunch';
  static const String facebookEventSent = 'facebookEventSent';
  static const String areDeviceCredsSent = 'areDeviceCredsSent';
  static const String iseDriverAvailable = 'iseDriverAvailable';


  // MinAppVersion
  static const String minAppVersion = 'minAppVersion';

  
}

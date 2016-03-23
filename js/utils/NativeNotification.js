/* 
* @Author: shaolie
* @Date:   2015-11-24 16:44:33
* @Last Modified by:   shaolie
* @Last Modified time: 2016-03-23 11:25:52
*/

/* @flow */
'use strict';

import React, {
  NativeModules
} from 'react-native';

var NativeNotificationManager = NativeModules.NativeNotification;

var NativeNotification;
export default NativeNotification = {
  postNotification : function(name: string, userInfo: Object) {
    NativeNotificationManager.postNotification(name, userInfo);
  }
}

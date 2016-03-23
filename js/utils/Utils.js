/*
* @Author: shaolie
* @Date:   2016-03-23 00:03:38
* @Last Modified by:   shaolie
* @Last Modified time: 2016-03-23 10:32:53
*/

'use strict';

import React, {
  NetInfo,
  Platform,
} from 'react-native';

let isAndroid = (Platform.OS === 'android');

export async function isWifi(callback) {
  var isWif = false;
  if (isAndroid){
    return new Promise((resolve, reject) => {
      NetInfo.isConnectionExpensive((metered, error) => {
        if (error) {
          reject(error);
          callback && callback(false, error);
        } else {
          isWif =  !metered;
          resolve(isWif);
          callback && callback(isWif);
        }
      });
    });
  } else {
    let reachability = await NetInfo.fetch();
    isWif = (reachability == 'wifi');
    callback && callback(isWif);
    return isWif;
  }
}
/*
* @Author: shaolie
* @Date:   2016-03-23 10:42:19
* @Last Modified by:   shaolie
* @Last Modified time: 2016-03-23 11:25:39
*/

'use strict';

import NativeNotification from './NativeNotification';
import * as Utils from './Utils';

var utils = {
  NativeNotification,
  ...Utils,
};

module.exports = utils;
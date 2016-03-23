/**
 * Sample React Native App
 * https://github.com/facebook/react-native
 */
'use strict';
import React, {
  AppRegistry,
  Component,
  StyleSheet,
  Text,
  View,
  NetInfo,
} from 'react-native';

import {
  isWifi,
  NativeNotification
} from './js/utils';

const JSBundleVersion = 1.0;
let hadDownloadJSBundle = true;

class DynamicUpdateDemo extends Component {
  componentDidMount() {
    NetInfo.addEventListener('change', (reachability) => {
      if (reachability == 'wifi' && hadDownloadJSBundle == false) {
        hadDownloadJSBundle = true;
        NativeNotification.postNotification('HadNewJSBundleVersion');
      }
    });
    this._checkUpdate();
  }

  _checkUpdate() {
    console.log('check update');
    this._getLatestVersion((err, version)=>{
      if (err || !version) {
        return;
      }
      console.log('current version is', version);
      let serverJSVersion = version.jsVersion;
      if (serverJSVersion > JSBundleVersion) {
        console.log('have new version');
        //通知 Native 有新的 JS 版本
        isWifi((wifi) => {
          if (wifi) {
            hadDownloadJSBundle = true;
            NativeNotification.postNotification('HadNewJSBundleVersion');
          } else {
            hadDownloadJSBundle = false;
          }
        });
      }
    });
  }

  _getLatestVersion(callback) {
    //FINISH ME: 这里只是随机获取是否有新版本
    let version = JSBundleVersion + Math.random() - 0.4;
    setTimeout(() => {
      callback(null, {jsVersion:version});
    }, 2000);
  }

  render() {
    return (
      <View style={styles.container}>
        <Text style={styles.welcome}>
          Welcome to React Native!
        </Text>
        <Text style={styles.instructions}>
          To get started, edit index.ios.js
        </Text>
        <Text style={styles.instructions}>
          Press Cmd+R to reload,{'\n'}
          Cmd+D or shake for dev menu
        </Text>
      </View>
    );
  }
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
    backgroundColor: '#F5FCFF',
  },
  welcome: {
    fontSize: 20,
    textAlign: 'center',
    margin: 10,
  },
  instructions: {
    textAlign: 'center',
    color: '#333333',
    marginBottom: 5,
  },
});

AppRegistry.registerComponent('DynamicUpdateDemo', () => DynamicUpdateDemo);

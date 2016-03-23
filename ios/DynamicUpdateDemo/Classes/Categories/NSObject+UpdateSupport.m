//
//  NSObject+UpdateSupport.m
//  DynamicUpdateDemo
//
//  Created by Shaolie on 16/3/20.
//  Copyright © 2016年 LinShaoLie. All rights reserved.
//

#import <CommonCrypto/CommonDigest.h>
#import "NSObject+UpdateSupport.h"
#import "SLFileManager.h"
#import "SLNetworkManager.h"
#import <RCTRootView.h>
#import <RCTBridge.h>

BOOL checkMD5(NSData *sourceData, NSString *dstMD5);
@implementation NSObject (UpdateSupport)

- (NSString *)JSBundlePath {
  NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
  NSString *bundlePath = [docPath stringByAppendingPathComponent:@"JSBundle"];
  
  if(![SLFileManager isFileExistAtPath:bundlePath]) {
    NSError *error = nil;
    [SLFileManager createDirectory:@"JSBundle" inDirectory:docPath error:&error];
  }
  return bundlePath;
}

- (BOOL)resetJSBundlePath {
  [SLFileManager deleteFileWithPath:[self JSBundlePath] error:nil];
  
  BOOL(^createBundle)(BOOL) = ^(BOOL retry) {
    NSError *error;
    NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    [SLFileManager createDirectory:@"JSBundle" inDirectory:docPath error:&error];
    if (error) {
      if (retry) {
        createBundle(NO);
      } else {
        return NO;
      }
    }
    
    return YES;
  };
  return createBundle(YES);
}

- (NSURL *)URLForCodeInBundle {
  return [[NSBundle mainBundle] URLForResource:@"main" withExtension:@"jsbundle"];
}

- (NSString *)pathForCodeInDocumentsDirectory {
  NSString *version = APP_VERSION;
  NSString *fileName = [[@"main" stringByAppendingString:version] stringByAppendingPathExtension:@"jsbundle"];
  
  NSString *filePath = [[self JSBundlePath] stringByAppendingPathComponent:fileName];
  return filePath;
}

- (NSURL *)URLForCodeInDocumentsDirectory {
  return [NSURL fileURLWithPath:[self pathForCodeInDocumentsDirectory]];
}

- (BOOL)hasCodeInDocumentsDirectory {
  return [SLFileManager isFileExistAtPath:[self pathForCodeInDocumentsDirectory]];
}

- (BOOL)copyBundleFileToURL:(NSURL *)url {
  NSURL *bundleFileURL = [[NSBundle mainBundle] URLForResource:@"main" withExtension:@"jsbundle"];
  return [SLFileManager copyFileAtURL:bundleFileURL toURL:url];
}

- (RCTBridge *)createBridgeWithBundleURL:(NSURL *)bundleURL {
  return [[RCTBridge alloc] initWithBundleURL:bundleURL moduleProvider:nil launchOptions:nil];
}

- (RCTRootView *)createRootViewWithModuleName:(NSString *)moduleName
                                       bridge:(RCTBridge *)bridge {
  return [[RCTRootView alloc] initWithBridge:bridge moduleName:moduleName initialProperties:nil];
}	

- (RCTRootView *)createRootViewWithURL:(NSURL *)url
                            moduleName:(NSString *)moduleName
                         launchOptions:(NSDictionary *)launchOptions {
  return [[RCTRootView alloc] initWithBundleURL:url
                                     moduleName:moduleName
                              initialProperties:nil
                                  launchOptions:launchOptions];
}

- (RCTRootView *)getRootViewModuleName:(NSString *)moduleName
                         launchOptions:(NSDictionary *)launchOptions {
  NSURL *jsCodeLocation = nil;
  RCTRootView *rootView = nil;
#if DEBUG
#if TARGET_OS_SIMULATOR
  //debug simulator
  jsCodeLocation = [NSURL URLWithString:@"http://localhost:8081/index.ios.bundle?platform=ios&dev=true"];
#else
  //debug device
  NSString *serverIP = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"SERVER_IP"];
  NSString *jsCodeUrlString = [NSString stringWithFormat:@"http://%@:8081/index.ios.bundle?platform=ios&dev=true", serverIP];
  NSString *jsBundleUrlString = [jsCodeUrlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
  jsCodeLocation = [NSURL URLWithString:jsBundleUrlString];
#endif
  rootView = [self createRootViewWithURL:jsCodeLocation moduleName:moduleName launchOptions:launchOptions];
  
#else
  //production
  jsCodeLocation = [self URLForCodeInDocumentsDirectory];
  if (![self hasCodeInDocumentsDirectory]) {
    [self resetJSBundlePath];
    
    BOOL copyResult = [self copyBundleFileToURL:jsCodeLocation];
    if (!copyResult) {
      jsCodeLocation = [self URLForCodeInBundle];
    }
  }
  RCTBridge *bridge = [self createBridgeWithBundleURL:jsCodeLocation];
  rootView = [self createRootViewWithModuleName:moduleName bridge:bridge];
  
#endif
  
#if 0 && DEBUG
  jsCodeLocation = [self URLForCodeInDocumentsDirectory];
  if (![self hasCodeInDocumentsDirectory]) {
    [self resetJSBundlePath];
    
    BOOL copyResult = [self copyBundleFileToURL:jsCodeLocation];
    if (!copyResult) {
      jsCodeLocation = [self URLForCodeInBundle];
    }
  }
  RCTBridge *bridge = [self createBridgeWithBundleURL:jsCodeLocation];
  rootView = [self createRootViewWithModuleName:moduleName bridge:bridge];
#endif
  return rootView;
}

- (void)downloadCodeFrom:(NSString *)srcURLString
            md5URLString:(NSString *)md5URLString
                   toURL:(NSURL *)dstURL
         completeHandler:(CompletionBlock)complete {
  //下载MD5数据
  [SLNetworkManager sendWithRequestMethor:(RequestMethodGET) URLString:md5URLString parameters:nil error:nil completionHandler:^(NSData *md5Data, NSURLResponse *response, NSError *connectionError) {
    if (connectionError && md5Data.length < 32) {
      return;
    }
    
    //下载JS
    [SLNetworkManager sendWithRequestMethor:(RequestMethodGET) URLString:srcURLString parameters:nil error:nil completionHandler:^(NSData *data, NSURLResponse *response, NSError *connectionError) {
      if (connectionError) {
        return;
      }
      
      //MD5 校验
      NSString *md5String = [[NSString alloc] initWithData:md5Data encoding:NSUTF8StringEncoding];
      if(checkMD5(data, md5String)) {
        //校验成功，写入文件
        NSError *error = nil;
        [data writeToURL:dstURL options:(NSDataWritingAtomic) error:&error];
        if (error) {
          !complete ?: complete(NO);
          //写入失败，删除
          [SLFileManager deleteFileWithURL:dstURL error:nil];
        } else {
          !complete ?: complete(YES);
        }
      }
    }];
  }];
}

@end


/**
 * MD5 校验
 */
BOOL checkMD5(NSData *sourceData, NSString *dstMD5) {
  unsigned char result[16];
  CC_MD5(sourceData.bytes, (CC_LONG)sourceData.length, result);
  NSMutableString *dataString = [NSMutableString stringWithCapacity:32];
  for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
    [dataString appendFormat:@"%02x", result[i]];
  }
  
  BOOL checkResult = NO;
  if ([[dstMD5 stringByReplacingOccurrencesOfString:@"\n" withString:@""] isEqualToString:dataString]) {
    //校验成功
    checkResult = YES;
  }
  return checkResult;
}

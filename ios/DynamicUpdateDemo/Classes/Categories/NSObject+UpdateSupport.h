//
//  NSObject+UpdateSupport.h
//  DynamicUpdateDemo
//
//  Created by Shaolie on 16/3/20.
//  Copyright © 2016年 LinShaoLie. All rights reserved.
//

#import <Foundation/Foundation.h>

#define APP_VERSION ([[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"])

@class RCTRootView;

@interface NSObject (UpdateSupport)
typedef void(^CompletionBlock)(BOOL result);

/**
 * 拷贝JS到指定路径
 */
- (BOOL)copyBundleFileToURL:(NSURL *)url;

/**
 * 判断要读取的JS是否已经存在Documents内
 */
- (BOOL)hasCodeInDocumentsDirectory;

/**
 * 获取JS在Documents的路径
 */
- (NSString *)pathForCodeInDocumentsDirectory;

/**
 * 获取JS在项目上的URL
 */
- (NSURL *)URLForCodeInBundle;

/**
 * 获取JS在Documents的URL
 */
- (NSURL *)URLForCodeInDocumentsDirectory;

/**
 * 重置（删除原路径上的文件，重新创建）
 */
- (BOOL)resetJSBundlePath;

/**
 * 初始化rootView
 */
- (RCTRootView *)getRootViewModuleName:(NSString *)moduleName
                         launchOptions:(NSDictionary *)launchOptions;

/**
 * 下载操作
 */
- (void)downloadCodeFrom:(NSString *)srcURLString
            md5URLString:(NSString *)md5URLString
                   toURL:(NSURL *)dstURL
         completeHandler:(CompletionBlock)complete;
@end

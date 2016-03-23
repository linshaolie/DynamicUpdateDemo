//
//  SLFileManager.h
//
//  Created by lin on 14-10-14.
//  Copyright (c) 2014年 linshaolie. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SLFileManager : NSObject

/*! @description 判断文件是否存在
 *  @param path 文件路径
 *  @return 文件是否存在
 */
+ (BOOL)isFileExistAtPath:(NSString *)path;

/*! @description 在指定目录下创建一个目录
 *  @param fileName:要创建的文件名
 *  @param dstPath:指定的目录
 *  @param error:错误信息
 *  @return 返回创建好的文件完整路径
 */
+ (NSString *)createDirectory:(NSString *)fileName inDirectory:(NSString *)dstPath error:(NSError **)error;

/*! @description 删除指定目录（文件）
 *  @parameter destPath 目标路径
 *  @parameter error 错误信息
 *  @return 删除成功返回YES,否则返回NO
 */
+ (BOOL) deleteFileWithPath:(NSString *)destPath error:(NSError **)error;

/*! @description 删除指定目录（文件）
 *  @parameter destPath 目标URL
 *  @parameter error 错误信息
 *  @return 删除成功返回YES,否则返回NO
 */
+ (BOOL) deleteFileWithURL:(NSURL *)URL error:(NSError **)error;

/*! @description 创建文件
 *  @parameter fileName 文件名称
 *  @parameter dstPath 目标路径
 *  @return 创建后文件的绝对路径
 */
+ (NSString *)createFile:(NSString *)fileName inDirectory:(NSString *)dstPath;

/*! @description 拷贝文件
 *  @parameter path 源路径
 *  @parameter newPath 目标路径
 *  @return 是否拷贝成功
 */
+ (BOOL) copyFileAtPath:(NSString *)path toPath:(NSString *)newPath;

/*! @description 拷贝文件
 *  @parameter path 源URL
 *  @parameter newPath 目标URL
 *  @return 是否拷贝成功
 */
+ (BOOL)copyFileAtURL:(NSURL *)srcURL toURL:(NSURL *)dstURL;

/*! @description 获取文件大小
 *  @parameter filePath 目标路径
 *  @return 文件大小
 */
+ (long long) fileSizeAtPath:(NSString*) filePath;

/*! @description 获取文件夹的大小
 *  @parameter filePath 目标路径
 *  @return 文件夹大小
 */
+ (float )folderSizeAtPath:(NSString*) folderPath;

/*! @description 获得目录下的所有子文件名称
 *  @parameter path 目标路径
 *  @return 所有文件名称
 */
+ (NSArray *)childFilesNameAtPath:(NSString *)path;

/*! @description 获取文件属性
 *  @parameter path 目标路径
 *  @return 文件属性
 */
+ (NSDictionary *)fileAttributeAtPath:(NSString *)path;     
@end

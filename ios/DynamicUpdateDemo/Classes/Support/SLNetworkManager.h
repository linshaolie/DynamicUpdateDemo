//
//  SLNetworkManager.h
//  DynamicUpdateDemo
//
//  Created by Shaolie on 16/3/20.
//  Copyright © 2016年 LinShaoLie. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, RequestMethod) {
  RequestMethodGET,
  RequestMethodPOST,
};

typedef void(^CompletionBlock)(BOOL result);
typedef void(^CompletionHandleBlock)(NSData* data, NSURLResponse* response, NSError* connectionError);

typedef void(^ReturnValueBlock)(NSDictionary *dic);
typedef void(^ErrorCodeBlock)(NSDictionary *dic);
typedef void(^FailureBlock)(NSError *error);


@interface SLNetworkManager : NSObject

+ (NSURLSessionDataTask *)sendWithRequestMethor:(RequestMethod)requestMethod URLString:(NSString *)urlString parameters:(NSDictionary *)parameters error:(NSError *__autoreleasing *)error completionHandler:(CompletionHandleBlock)completion;

@end

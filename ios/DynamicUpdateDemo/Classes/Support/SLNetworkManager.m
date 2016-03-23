//
//  SLNetworkManager.m
//  DynamicUpdateDemo
//
//  Created by Shaolie on 16/3/20.
//  Copyright © 2016年 LinShaoLie. All rights reserved.
//

#import "SLNetworkManager.h"

@implementation SLNetworkManager

+ (NSURLSessionDataTask *)sendWithRequestMethor:(RequestMethod)requestMethod URLString:(NSString *)urlString parameters:(NSDictionary *)parameters error:(NSError *__autoreleasing *)error completionHandler:(void(^)(NSData *data, NSURLResponse *response, NSError *error))completion {
  NSString *method = @"GET";
  if (requestMethod == RequestMethodPOST) {
    method = @"POST";
  }
  
  urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
  NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]];
  request.HTTPMethod = method;
  request.cachePolicy = NSURLRequestReloadIgnoringCacheData;
  if (RequestMethodPOST) {
    if (parameters) {
      request.HTTPBody = [QueryStringFromParametersWithEncoding(parameters, NSUTF8StringEncoding) dataUsingEncoding:NSUTF8StringEncoding];
    }
  }
  
  NSURLSession *session = [NSURLSession sharedSession];
  
  NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
    if (completion) {
      completion(data, response, error);
    }
  }];
  [task resume];
  return task;
}


static NSString * QueryStringFromParametersWithEncoding(NSDictionary *parameters, NSStringEncoding stringEncoding) {
  NSMutableArray *mutablePairs = [NSMutableArray array];
  [parameters enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
    NSString *ercentEscapedKey = key;
    NSString *ercentEscapedValue = obj;
    if ([key isKindOfClass:[NSString class]]) {
      ercentEscapedKey = [key stringByAddingPercentEscapesUsingEncoding:stringEncoding];
    }
    if ([ercentEscapedValue isKindOfClass:[NSString class]]) {
      ercentEscapedValue = [key stringByAddingPercentEscapesUsingEncoding:stringEncoding];
    }
    NSString *pair = [NSString stringWithFormat:@"%@=%@", ercentEscapedKey, ercentEscapedValue];
    [mutablePairs addObject:pair];
  }];
  
  return [mutablePairs componentsJoinedByString:@"&"];
}

@end

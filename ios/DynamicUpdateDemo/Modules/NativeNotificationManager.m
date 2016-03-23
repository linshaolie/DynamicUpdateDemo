//
//  NativeNotificationManager.m
//  Seed
//
//  Created by Shaolie on 15/11/24.
//  Copyright © 2015年 Facebook. All rights reserved.
//

#import "NativeNotificationManager.h"

@implementation NativeNotificationManager

+ (void)addObserver:(id)observer selector:(SEL)aSelector name:(NSString *)aName object:(id)anObject {
  [[NSNotificationCenter defaultCenter] addObserver:observer selector:aSelector name:aName object:anObject];
}

+ (void)removeObserver:(id)observer {
  [[NSNotificationCenter defaultCenter] removeObserver:observer];
}

+ (void)removeObserver:(id)observer name:(nullable NSString *)aName object:(nullable id)anObject {
  [[NSNotificationCenter defaultCenter] removeObserver:observer name:aName object:anObject];
}

RCT_EXPORT_MODULE(NativeNotification);

RCT_EXPORT_METHOD(postNotification:(NSString *)name userInfo:(NSDictionary *)userInfo)
{
  [[NSNotificationCenter defaultCenter] postNotificationName:name object:nil userInfo:userInfo];
}

@end

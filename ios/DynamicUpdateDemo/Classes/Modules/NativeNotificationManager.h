//
//  NativeNotificationManager.h
//  Seed
//
//  Created by Shaolie on 15/11/24.
//  Copyright © 2015年 Facebook. All rights reserved.
//

#import "RCTBridgeModule.h"
#import "RCTComponent.h"

NS_ASSUME_NONNULL_BEGIN

@interface NativeNotificationManager : NSObject <RCTBridgeModule>

+ (void)addObserver:(id)observer selector:(SEL)aSelector name:(nullable NSString *)aName object:(nullable id)anObject;

+ (void)removeObserver:(id)observer;
+ (void)removeObserver:(id)observer name:(nullable NSString *)aName object:(nullable id)anObject;
@end

NS_ASSUME_NONNULL_END
//
//  MYRouterAction.h
//  PWNote
//
//  Created by MingYan on 2018/11/25.
//  Copyright © 2018 MingYan. All rights reserved.
//  

#import <UIKit/UIKit.h>

typedef BOOL(^ActionBlock)(NSDictionary *param);

@interface MYRouterAction : NSObject

- (instancetype)initWithAction:(ActionBlock)block NS_DESIGNATED_INITIALIZER;
+ (instancetype)routerWithAction:(ActionBlock)block;

- (instancetype)init NS_UNAVAILABLE;

- (BOOL)executeAction:(NSDictionary *)param;

@end

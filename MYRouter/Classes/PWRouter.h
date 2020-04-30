//
//  PWRouter.h
//  PWNote
//
//  Created by 明妍 on 2018/11/25.
//  Copyright © 2018 明妍. All rights reserved.
//  Router Component

#import <UIKit/UIKit.h>

@class PWRouterAction;

@interface PWRouter : NSObject

+ (instancetype)sharedInstance;

- (void)routerURL:(NSString *)url param:(NSDictionary *)param;

@end

@interface PWRouter (Register)

- (void)setupWithNavigation:(UINavigationController *)navigationController;

- (void)registerRouterWithURLAddress:(NSString *)address action:(PWRouterAction *)action;

@end

//
//  MYRouter.h
//  PWNote
//
//  Created by MingYan on 2018/11/25.
//  Copyright © 2018 MingYan. All rights reserved.
//  Router Component

#import <UIKit/UIKit.h>

@class MYRouterAction;

@interface MYRouter : NSObject

+ (instancetype)sharedInstance;

- (void)routerURL:(NSString *)url param:(NSDictionary *)param;

@end

@interface MYRouter (Register)

- (void)setupWithNavigation:(UINavigationController *)navigationController;

- (void)registerRouterWithURLAddress:(NSString *)address action:(MYRouterAction *)action;

@end

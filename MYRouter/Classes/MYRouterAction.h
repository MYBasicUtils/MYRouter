//
//  MYRouterAction.h
//  PWNote
//
//  Created by MingYan on 2018/11/25.
//  Copyright © 2018 MingYan. All rights reserved.
//  

#import <UIKit/UIKit.h>

typedef void(^ActionBlock)(UINavigationController *navigationController);

typedef enum : NSUInteger {
    MYRouterActionTypePushNewPage,// push一个新的页面
    MYRouterActionTypePresentNewPage,// presnet一个新的页面
    MYRouterActionTypeAction,// 一些动作
} MYRouterActionType;

@interface MYRouterAction : NSObject

@property (nonatomic, strong) NSString *address; /**< 地址  */
@property (nonatomic, assign) MYRouterActionType actionType;/** < 动作类型*/
@property(nonatomic, copy) ActionBlock actionBlock;/**< 动作  */

@end

//
//  PWRouterAction.h
//  PWNote
//
//  Created by 明妍 on 2018/11/25.
//  Copyright © 2018 明妍. All rights reserved.
//  

#import <UIKit/UIKit.h>

typedef void(^ActionBlock)(UINavigationController *navigationController);

typedef enum : NSUInteger {
    PWRouterActionTypePushNewPage,// push一个新的页面
    PWRouterActionTypePresentNewPage,// presnet一个新的页面
    PWRouterActionTypeAction,// 一些动作
} PWRouterActionType;

@interface PWRouterAction : NSObject

@property (nonatomic, strong) NSString *address; /**< 地址  */
@property (nonatomic, assign) PWRouterActionType actionType;/** < 动作类型*/
@property(nonatomic, copy) ActionBlock actionBlock;/**< 动作  */

@end

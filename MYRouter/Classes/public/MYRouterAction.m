//
//  MYRouterAction.m
//  PWNote
//
//  Created by MingYan on 2018/11/25.
//  Copyright © 2018 MingYan. All rights reserved.
//

#import "MYRouterAction.h"

@interface MYRouterAction ()

@property(nonatomic, copy) ActionBlock actionBlock;/**< 动作  */

@end

@implementation MYRouterAction

- (instancetype)initWithAction:(ActionBlock)block {
    if (self = [super init]) {
        self.actionBlock = block;
    }
    return self;
}
+ (instancetype)routerWithAction:(ActionBlock)block {
    return [[self alloc] initWithAction:block];
}

- (BOOL)executeAction:(NSDictionary *)param {
    if (self.actionBlock) {
        return self.actionBlock(param);
    }
    return YES;
}

@end

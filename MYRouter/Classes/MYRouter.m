//
//  MYRouter.m
//  PWNote
//
//  Created by MingYan on 2018/11/25.
//  Copyright © 2018 MingYan. All rights reserved.
//

#import "MYRouter.h"
#import "MYUtils.h"
#import "MYRouterAction.h"

@interface MYRouter ()

@property (nonatomic, strong) NSMutableDictionary *routerDict;
@property (nonatomic, weak) UINavigationController *navigationController;

@end

@implementation MYRouter

static MYRouter *__onetimeClass;


#pragma mark - --------------------dealloc ------------------
#pragma mark - --------------------life cycle--------------------

+ (instancetype)sharedInstance {
    static dispatch_once_t oneToken;
    dispatch_once(&oneToken, ^{
        __onetimeClass = [[self alloc] init];
    });
    return __onetimeClass;
}

#pragma mark - --------------------UITableViewDelegate--------------
#pragma mark - --------------------CustomDelegate--------------
#pragma mark - --------------------Event Response--------------

- (void)setupWithNavigation:(UINavigationController *)navigationController {
    self.navigationController = navigationController;
}

- (void)routerURL:(NSString *)url param:(NSDictionary *)param {
    NSURL *URL = [NSURL URLWithString:url];
    NSAssert(URL, @"url is not NSURL");
    if ([URL.scheme isEqualToString:@"pwnote"] &&
        [self.routerDict.allKeys containsObject:[URL.host lowercaseString]]) {
        MYRouterAction *action = self.routerDict[URL.host];
        if (action.actionBlock) {
            action.actionBlock(self.navigationController);
        }
    } else if ([URL.scheme isEqualToString:@"http"] ||
               [URL.scheme isEqualToString:@"https"]) {
        
    } else {
        [[UIApplication sharedApplication] openURL:URL options:@{} completionHandler:^(BOOL success) {
            
        }];
    }
}

- (void)registerRouterWithURLAddress:(NSString *)address action:(MYRouterAction *)action {
    NSAssert(address.length != 0, @"address is empty");
    self.routerDict[address] = action;
    action.address = address;   
}

#pragma mark - --------------------private methods--------------
#pragma mark - --------------------getters & setters & init members ------------------

- (NSMutableDictionary *)routerDict {
    if (!_routerDict) {
        _routerDict = [NSMutableDictionary dictionary];
    }
    return _routerDict;
}

@end

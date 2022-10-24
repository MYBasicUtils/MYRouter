//
//  MYRouterInterceptorCondition.m
//  MYRouter
//
//  Created by APPLE on 2022/10/20.
//

#import "MYRouterInterceptorCondition.h"
#import "MYRouterUtils.h"
#import "MYRouterServer.h"

@implementation MYRouterInterceptorCondition

- (BOOL)matchRequest:(NSString *)hostPathComponent {
    return [MYRouterUtils router:hostPathComponent isMatchWithRouter:self.router];
}

- (void)setPathString:(NSString *)pathString {
    _pathString = pathString;
    NSString *requestURL = [MYRouterUtils requestURLWithRouterURL:pathString inScheme:self.scheme];
    self.router = [MYRouterUtils fullPathInRequestURL:requestURL];
    self.hostPathComponents = [MYRouterUtils pathWithOutParamInRequestURL:requestURL];
    self.requireParams = [MYRouterUtils reqireParams:requestURL];
}

- (BOOL)matchRouter:(NSString *)router withParam:(NSDictionary *)param {
    // 拦截条件
    // 1. param中有某个参数
    // 2. router符合条件
    NSString *path = [MYRouterUtils fullPathInRequestURL:router];
    if (self.pathString.length) {
        // 先判断是否在一个path下
        if (![self matchRequest:path]) {
            return NO;
        }
    }

    NSMutableDictionary *urlParam = [NSMutableDictionary dictionaryWithDictionary:param];
    [urlParam setValuesForKeysWithDictionary:[MYRouterUtils parametersInRequestURL:router]];
    for (NSString *paramName in self.requireParams) {
        id object = urlParam[paramName];
        if (!object) {
            return NO;
        }
    }
    return YES;
}

@end

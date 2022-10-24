//
//  MYRouterServer.m
//  MYRouter
//
//  Created by APPLE on 2022/10/10.
//

#import "MYRouterServer.h"
#import "MYRouter+Private.h"
#import "MYRouterResponse.h"
#import "MYRouterRequest.h"
#import "MYRouterUtils.h"

@interface MYRouterServer ()


@end

@implementation MYRouterServer

+ (instancetype)sharedInstance { 
    static id instance;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (MYRouterResponse *)executeRequest:(MYRouterRequest *)request inRouterItems:(NSArray<id<MYRouterItemProtocol>> *)routerItems {
    MYRouterResponse *response = [[MYRouterResponse alloc] init];
    if (!routerItems.count) {
        return response;
    }
    
    for (NSObject<MYRouterItemProtocol> *routerItem in routerItems) {
        if ([routerItem matchRequest:request.hostPathComponent]) {
            // 处理router在其中的path中带的参数
            NSMutableArray<NSString *> *pathParams = [NSMutableArray<NSString *> array];
            if ([routerItem.hostPathComponents isEqualToString:@"/*"] || [routerItem.hostPathComponents isEqualToString:@"*"]) {
                // 不需要计算path参数
            } else {
                // 计算path的参数
                NSString *requestPath = [request.hostPathComponent substringFromIndex:routerItem.hostPathComponents.length];
                if (requestPath.length) {
                    NSArray<NSString *> *paths = [requestPath componentsSeparatedByString:@"/"];
                    for (NSString *path in paths) {
                        if (!path.length) {
                            continue;
                        }
                        [pathParams addObject:path];
                    }
                }
            }
            // 计算query的参数
            [pathParams addObjectsFromArray:request.allParameters.allKeys];
            if (pathParams.count < routerItem.requireParams.count) {
                continue;
            }
            // 判断是否有require
            if (routerItem.requireParams.count) {
                NSMutableDictionary *param = [NSMutableDictionary dictionary];
                for (int i = 0; i < routerItem.requireParams.count; i++) {
                    param[routerItem.requireParams[i]] = pathParams[i];
                }
                [param addEntriesFromDictionary:request.allParameters];
                response.isMatch = YES;
                response.item = routerItem;
                response.allParameters = param.copy;
            } else {
                
                response.isMatch = YES;
                response.item = routerItem;
                response.allParameters = request.allParameters;
            }
            
            break;
        }
    }
    
    return response;
}

@end

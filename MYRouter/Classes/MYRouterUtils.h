//
//  MYRouterUtils.h
//  MYRouter
//
//  Created by APPLE on 2022/10/10.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MYRouterUtils : NSObject

/// 将请求的url转为标准格式
+ (NSString *)requestURLWithRouterURL:(NSString *)routeURL inSchema:(NSString *)schema;
/// 完整的paths
+ (NSString *)fullPathInRequestURL:(NSString *)requestURL;
/// 去除参数的path
+ (NSString *)pathWithOutParamInRequestURL:(NSString *)requestURL;

+ (NSDictionary *)parametersInRequestURL:(NSString *)requestURL;

/// 从requestURL中转换path需要的参数
+ (NSArray *)reqireParams:(NSString *)requestURL;

+ (BOOL)router:(NSString *)router1 isMatchWithRouter:(NSString *)router2;

@end

NS_ASSUME_NONNULL_END

//
//  MYRouterRequest.h
//  MYRouter
//
//  Created by APPLE on 2022/10/9.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MYRouterRequest : NSObject

@property (nonatomic, strong, readonly) NSString *hostPathComponent;

/// 初始化router请求
/// @param requestURL 请求的router 的URL
/// @param params 额外的参数
- (instancetype)initWithRequestURL:(NSString *)requestURL additionParameters:(NSDictionary *)params NS_DESIGNATED_INITIALIZER;

- (instancetype)init NS_UNAVAILABLE;

- (NSDictionary *)allParameters;

@end

NS_ASSUME_NONNULL_END

//
//  MYRouterInterceptor.h
//  MYRouter
//
//  Created by APPLE on 2022/10/20.
//

#import <Foundation/Foundation.h>
#import "MYRouterAction.h"

NS_ASSUME_NONNULL_BEGIN

@class MYRouterResponse;
@class MYRouterRequest;

@interface MYRouterInterceptor : NSObject 

@property (nonatomic, strong) MYRouterAction *preAction;
@property (nonatomic, strong) MYRouterAction *postAction;

@property(nonatomic, strong) MYRouterResponse *response;

+ (instancetype)interceptorWithScheme:(NSString *)scheme
                               router:(NSString *)router
                                param:(NSArray<NSString *> *)paramName
                            preAction:(BOOL(^)(NSDictionary *param))action
                           postAction:(BOOL(^)(NSDictionary *param))postAction;

- (instancetype)initWithScheme:(NSString *)scheme
                        router:(NSString *)router
                         param:(NSArray<NSString *> *)paramName
                     preAction:(BOOL(^)(NSDictionary *param))action
                    postAction:(BOOL(^)(NSDictionary *param))postAction NS_DESIGNATED_INITIALIZER;


- (instancetype)init NS_UNAVAILABLE;

/// router和param是否满足该拦截器的条件
- (BOOL)matchRouter:(NSString *)router withParam:(NSDictionary *)param;

- (MYRouterResponse *)executeRequest:(MYRouterRequest *)request;


@end

NS_ASSUME_NONNULL_END

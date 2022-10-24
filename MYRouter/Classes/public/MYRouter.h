//
//  MYRouter.h
//  PWNote
//
//  Created by MingYan on 2018/11/25.
//  Copyright © 2018 MingYan. All rights reserved.
//  Router Component

#import <UIKit/UIKit.h>
#import "MYRouterInterceptor.h"
#import "MYRouterAction.h"

FOUNDATION_EXPORT const NSInteger MYROUTER_PRIORITY_HIGH;
FOUNDATION_EXPORT const NSInteger MYROUTER_PRIORITY_NORMAL;
FOUNDATION_EXPORT const NSInteger MYROUTER_PRIORITY_LOW;

@interface MYRouter : NSObject

/// 返回一个给定的shema名称的实例
- (instancetype)initWithScheme:(NSString *)scheme NS_DESIGNATED_INITIALIZER;

/// 返回一个给定的shema名称的示例
+ (instancetype)routerWithScheme:(NSString *)scheme;

/// 制定约定的动作，其动作需要对应的router地址和参数
/// 返回是否可以被router
- (BOOL)routerURL:(NSString *)routeURL withParameters:(NSDictionary *)param;

/// 制定约定动作，若scheme为未注册
+ (BOOL)routerURL:(NSString *)routerURL withParameters:(NSDictionary *)param;

- (instancetype)init NS_UNAVAILABLE;

@end

///-------------------------------
/// @name Scheme相关操作
///-------------------------------

@interface MYRouter (Scheme)

+ (void)setDefaultSchemeName:(NSString *)schemeName;
/// 返回一个默认的router
+ (instancetype)defaultRouter;

@end

///-------------------------------
/// @name 注册与注销
///-------------------------------

@interface MYRouter (Register)


/// 注册router，并规定router的动作
- (void)registerRouter:(NSString *)router handlerAction:(BOOL (^)(NSDictionary *))actionBlock;

/// 注册router，并规定router的动作
/// @description 由于方法没有scheme入口，因此使用默认scheme进行注册
+ (void)registerRouter:(NSString *)router handlerAction:(BOOL (^)(NSDictionary *))actionBlock;

/// 注册router，并规定router的动作
/// @param router router
/// @param priority 优先级，
/// @param actionBlock 动作
- (void)registerRouter:(NSString *)router priority:(NSInteger)priority handlerAction:(BOOL(^)(NSDictionary *param))actionBlock;

/// 注册router，并规定router的动作
/// @param router router
/// @param priority 优先级
/// @param scheme scheme
/// @param actionBlock 动作
+ (void)registerRouter:(NSString *)router
              priority:(NSInteger)priority
              toScheme:(NSString *)scheme
         handlerAction:(BOOL(^)(NSDictionary *param))actionBlock;

/// 将已注册的router从列表中删除
/// @param router router
- (void)unRegisterRouter:(NSString *)router;

/// 注销scheme中的router
+ (void)unRegisterRouter:(NSString *)router inScheme:(NSString *)scheme;

/// 注销所有的router
+ (void)unRegisterAllRouters;

@end

///-------------------------------
/// @name 拦截器
///-------------------------------
@interface MYRouter (Interceptor)

/// 添加一个拦截器，需要在跳转的router和param符合填入的条件才会启动拦截器。
/// @param router 符合条件的router
/// @param paramName 需要符合的参数名称，注意：如果参数在path中，请按照path的顺序书写
/// @param preAction 前置拦截器：在router跳转前调用。当条件符合时，用户对其进行逻辑补充，若返回NO，则拦截该router
/// @param postAction 后置处理器：在router跳转后调用，主要用于处理一些后置的实例销毁。通常默认返回YES。
- (void)addInterceptorWithRouter:(NSString *)router
                       paramName:(NSArray<NSString *> *)paramName
                       preAction:(BOOL(^)(NSDictionary *param))preAction
                      postAction:(BOOL(^)(NSDictionary *param))postAction;

/// 添加拦截器
- (void)addInterceptor:(MYRouterInterceptor *)interceptor;


/// 删除拦截器
- (void)removeInterceptor:(MYRouterInterceptor *)interceptor;


/// 删除所有拦截器
+ (void)removeAllInterceptors;

@end


///-------------------------------
/// @name 日志控制 TODO
///-------------------------------
//@interface MYRouter (Log)
//
///// 设置是否开启router日志
//+ (void)setRouterVerboseLogEnabled:(BOOL)enabled;

//@end

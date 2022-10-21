//
//  MYRouter.m
//  PWNote
//
//  Created by MingYan on 2018/11/25.
//  Copyright © 2018 MingYan. All rights reserved.
//

#import "MYRouter.h"
#import <objc/objc.h>
#import "MYRouterItemModel.h"
#import "MYRouterAction.h"
#import "MYRouterRequest.h"
#import "MYRouterResponse.h"
#import "MYRouterServer.h"
#import "MYRouterUtils.h"

NSInteger const MYROUTER_PRIORITY_HIGH = 10;
NSInteger const MYROUTER_PRIORITY_NORMAL = 0;
NSInteger const MYROUTER_PRIORITY_LOW = -0;

BOOL MYGlobal_RouterLogEnabled = false;

NSString *MYGlobal_RouterDefaultSchemaName = @"default";

static NSMutableDictionary<NSString *,MYRouter *> *MYGlobal_RouterMap = nil;

@interface MYRouter ()

@property (nonatomic, strong) NSMutableArray<MYRouterItemModel *> *routerItems;/**<  路由 */
@property (nonatomic, strong) NSString *schema;/**<  schema */
@property (nonatomic, strong) NSMutableArray<MYRouterInterceptor *> *interceptors;/**< 拦截器  */

@end

@implementation MYRouter
#pragma mark - dealloc
#pragma mark - life cycle

+ (instancetype)defaultRouter {
    return [self routerWithSchema:MYGlobal_RouterDefaultSchemaName];
}

- (instancetype)initWithSchema:(NSString *)schema {
    if (self = [super init]) {
        self.schema = schema;
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            MYGlobal_RouterMap = [NSMutableDictionary<NSString *,MYRouter *> dictionary];
        });
        MYGlobal_RouterMap[schema] = self;
    }
    return self;
}

+ (instancetype)routerWithSchema:(NSString *)schema {
    if (!schema.length) {
        return nil;
    }
    MYRouter *router = MYGlobal_RouterMap[schema];
    if (!router) {
        router = [[self alloc] initWithSchema:schema];
    }
    return router;
}

#pragma mark - Event Response

- (BOOL)routerURL:(NSString *)routeURL WithParameters:(NSDictionary *)param {
    if (!routeURL.length) {
        return false;
    }
    // 这里需要拼为一个完整的reqeust-url
    NSString *requestURL = [MYRouterUtils requestURLWithRouterURL:routeURL inSchema:self.schema];
    MYRouterRequest *request = [[MYRouterRequest alloc] initWithRequestURL:requestURL additionParameters:param];
    NSMutableArray<MYRouterInterceptor *> *matchInterceptors = [NSMutableArray array];
    BOOL interceptorSuccess = YES;
    // 前置拦截器
    for (MYRouterInterceptor *interceptor in self.interceptors) {
        MYRouterResponse *interceptorResponse = [interceptor executeRequest:request];
        if (interceptorResponse.isMatch) {
            NSMutableDictionary *preActionParam = [NSMutableDictionary dictionary];
            [preActionParam addEntriesFromDictionary:interceptorResponse.allParameters];
            preActionParam[@"originalRouter"] = routeURL;
            BOOL success = [interceptor.preAction executeAction:preActionParam];
            interceptorSuccess = success & interceptorSuccess;
            [matchInterceptors addObject:interceptor];
            if (!success) {
                break;
            }
        }
    }
    
    MYRouterResponse *response;
    if (interceptorSuccess) {
        response = [MYRouterServer.sharedInstance executeRequest:request inRouterItems:self.routerItems];
        if (response.isMatch && response.item) {
            if ([response.item isKindOfClass:MYRouterItemModel.class]) {
                MYRouterItemModel *innerItemModel = (MYRouterItemModel *)response.item;
                if (innerItemModel.action) {
                    [innerItemModel.action executeAction:[response allParameters]];
                }
            }
            
        }
    }
    // 后置拦截器
    for (MYRouterInterceptor *interceptor in matchInterceptors.reverseObjectEnumerator) {
        NSMutableDictionary *postActionParam = [NSMutableDictionary dictionaryWithDictionary:interceptor.response.allParameters];
        postActionParam[@"originalRouter"] = routeURL;
        [interceptor.postAction executeAction:postActionParam];
    }
    
    return response.isMatch;
}

#pragma mark - schema

+ (void)setDefaultSchemaName:(NSString *)schemaName {
    if (!schemaName.length) {
        return;
    }
    MYGlobal_RouterDefaultSchemaName = schemaName;
}

#pragma mark - register

- (void)registerRouter:(NSString *)router handlerAction:(BOOL (^)(NSDictionary *))actionBlock {
    [self registerRouter:router priority:0 handlerAction:actionBlock];
}

+ (void)registerRouter:(NSString *)routerURL handlerAction:(BOOL (^)(NSDictionary *))actionBlock {
    MYRouter *router = MYGlobal_RouterMap[MYGlobal_RouterDefaultSchemaName];
    if (!router) {
        router = [self defaultRouter];
    }
    [router registerRouter:routerURL handlerAction:actionBlock];
}

- (void)registerRouter:(NSString *)router priority:(NSInteger)priority handlerAction:(BOOL (^)(NSDictionary *))actionBlock {
    if (!router.length) {
        return;
    }
    MYRouterItemModel *routerItem = [[MYRouterItemModel alloc] init];
    routerItem.schema = self.schema;
    routerItem.pathString = router;
    routerItem.priority = priority;
    routerItem.action = [[MYRouterAction alloc] initWithAction:actionBlock];
    
    [self.routerItems addObject:routerItem];
    //TODO: wmy 当优先级有值时，需要对routerItems sort一下
    
}

+ (void)registerRouter:(NSString *)routerURL priority:(NSInteger)priority toSchema:(NSString *)schema handlerAction:(BOOL (^)(NSDictionary *))actionBlock {
    if (!schema.length || !routerURL.length || !actionBlock) {
        return;
    }
    MYRouter *router = MYGlobal_RouterMap[schema];
    if (!router) {
        router = [self defaultRouter];
    }
    [router registerRouter:routerURL priority:priority handlerAction:actionBlock];
}

- (void)unRegisterRouter:(NSString *)router {
    if (!router.length) {
        return;
    }
    MYRouterItemModel *findItem = nil;
    for (MYRouterItemModel *item in self.routerItems) {
        if ([item.pathString isEqualToString:router]) {
            findItem = item;
            break;
        }
    }
    // 这里如果是个模糊的定位，则查不到，无法删除。
    if (findItem) {
        [self.routerItems removeObject:findItem];
    }
    
}

+ (void)unRegisterRouter:(NSString *)routerURL inSchema:(NSString *)schema {
    MYRouter *router = MYGlobal_RouterMap[schema];
    if (!router) {
        router = [self defaultRouter];
    }
    [router unRegisterRouter:routerURL];
}

+ (void)unRegisterAllRouters {
    [MYGlobal_RouterMap removeAllObjects];
}

#pragma mark - interrupter
- (void)addInterceptorWithRouter:(NSString *)router
                       paramName:(NSArray<NSString *> *)paramName
                       preAction:(BOOL(^)(NSDictionary *param))preAction
                      postAction:(BOOL(^)(NSDictionary *param))postAction {
    MYRouterInterceptor *interceptor = [MYRouterInterceptor interceptorWithSchema:self.schema router:router param:paramName preAction:preAction postAction:postAction];
    [self addInterceptor:interceptor];
}

- (void)addInterceptor:(MYRouterInterceptor *)interrupter {
    if ([self.interceptors containsObject:interrupter]) {
        [self.interceptors removeObject:interrupter];
    }
    [self.interceptors insertObject:interrupter atIndex:0];
}

/// 删除拦截器
- (void)removeInterceptor:(MYRouterInterceptor *)interceptor {
    [self.interceptors removeObject:interceptor];
}

- (void)removeInterceptors {
    [self.interceptors removeAllObjects];
}

/// 删除所有拦截器
+ (void)removeAllInterceptors {
    for (NSString *routerName in MYGlobal_RouterMap) {
        MYRouter *router = MYGlobal_RouterMap[routerName];
        [router removeInterceptors];
    }
}

#pragma mark - log

+ (void)setRouterVerboseLogEnabled:(BOOL)enabled {
    MYGlobal_RouterLogEnabled = enabled;
}

+ (void)verboselog:(NSString *)string {
    if (MYGlobal_RouterLogEnabled) {
        NSLog(@"%@",string);
    }
}

#pragma mark - private

+ (NSDictionary *)allRouterParameters {
    return MYGlobal_RouterMap;
}

#pragma mark - getters & setters & init members

- (NSMutableArray<MYRouterItemModel *> *)routerItems {
    if (!_routerItems) {
        _routerItems = [NSMutableArray array];
        //TODO: wmy 获取数据时，需要根据优先级对其进行排序
    }
    return _routerItems;
}

- (NSMutableArray<MYRouterInterceptor *> *)interceptors {
    if (!_interceptors) {
        _interceptors = [NSMutableArray array];
    }
    return _interceptors;
}

@end

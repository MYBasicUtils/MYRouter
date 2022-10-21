//
//  MYRouterInterceptor.m
//  MYRouter
//
//  Created by APPLE on 2022/10/20.
//

#import "MYRouterInterceptor.h"
#import "MYRouterUtils.h"
#import "MYRouterItemProtocol.h"
#import "MYRouterInterceptorCondition.h"
#import "MYRouterResponse.h"
#import "MYRouterRequest.h"
#import "MYRouterServer.h"

@interface MYRouterInterceptor ()

@property (nonatomic, strong) MYRouterInterceptorCondition *condition;


@end

@implementation MYRouterInterceptor

+ (instancetype)interceptorWithSchema:(NSString *)schema
                               router:(NSString *)router
                                param:(NSArray<NSString *> *)paramName
                            preAction:(BOOL(^)(NSDictionary *param))action
                           postAction:(BOOL(^)(NSDictionary *param))postAction {
    return [[self alloc] initWithSchema:schema router:router param:paramName preAction:action postAction:postAction];
}

- (instancetype)initWithSchema:(NSString *)schema
                        router:(NSString *)router
                         param:(NSArray<NSString *> *)paramName
                     preAction:(BOOL(^)(NSDictionary *param))action
                    postAction:(BOOL(^)(NSDictionary *param))postAction  {
    
    MYRouterInterceptorCondition *condition = [[MYRouterInterceptorCondition alloc] init];
    condition.schema = schema;
    NSArray<NSString *> *urlParams = [MYRouterUtils reqireParams:router];
    condition.pathString = router;
    NSMutableArray *paramNames = [NSMutableArray arrayWithArray:paramName];
    for (NSString *urlParam in urlParams) {
        if (![paramNames containsObject:urlParam]) {
            [paramNames addObject:urlParam];
        }
    }
    condition.requireParams = paramNames;
    if (self = [super init]) {
        self.condition = condition;
        self.preAction = [MYRouterAction routerWithAction:action];
        self.postAction = [MYRouterAction routerWithAction:postAction];
    }
    return self;
}

- (BOOL)matchRouter:(NSString *)router withParam:(NSDictionary *)param {
    return [self.condition matchRouter:router withParam:param];
}

- (MYRouterResponse *)executeRequest:(MYRouterRequest *)request {
    self.response = [MYRouterServer.sharedInstance executeRequest:request inRouterItems:@[self.condition]];
    return self.response;
}

@end

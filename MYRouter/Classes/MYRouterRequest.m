//
//  MYRouterRequest.m
//  MYRouter
//
//  Created by APPLE on 2022/10/9.
//

#import "MYRouterRequest.h"
#import "MYRouterUtils.h"

@interface MYRouterRequest ()


@property (nonatomic, strong) NSString *hostPathComponent;

@property (nonatomic, strong) NSString *requestURL;/**<  请求的routerURL */
@property (nonatomic, strong) NSDictionary *additionParameters;/**<  额外的请求参数 */

@property (nonatomic, strong) NSDictionary *params;/**<  url中的参数 */

@property (nonatomic, strong) NSDictionary *allParameters;/**<  所有的参数 */

@end

@implementation MYRouterRequest

- (instancetype)initWithRequestURL:(NSString *)requestURL additionParameters:(NSDictionary *)param {
    if (self = [super init]) {
        self.requestURL = requestURL;
        self.additionParameters = param;
        
        // 此处处理requestURL中的url。
        self.hostPathComponent = [MYRouterUtils fullPathInRequestURL:requestURL];
        // 把url的参数都拿出来
        self.params = [MYRouterUtils parametersInRequestURL:requestURL];
    }
    return self;
}

- (NSDictionary *)allParameters {
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:self.additionParameters];
    [dict addEntriesFromDictionary:self.params];
    return [dict copy];
}

@end

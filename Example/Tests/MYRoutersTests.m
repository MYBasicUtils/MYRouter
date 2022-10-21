//
//  MYRoutersTests.m
//  MYRouter_Tests
//
//  Created by APPLE on 2022/10/9.
//  Copyright © 2022 WenMingYan. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <MYRouter/MYRouter+Private.h>
#import <MYRouter/MYRouter.h>

#define kRouterTestsSchema @"testSchema"

#define MYRouteAssertCanRoute() XCTAssertTrue(self.didRoute,@"cannot route!");
#define MYRouteAssertCanNotRoute() XCTAssertTrue(!self.didRoute,@"can route!");

#define MYRouteAssertParameter(someParameter) XCTAssertTrue([self.matchParam isEqualToDictionary:someParameter], @"parameter is not match!");

#ifdef DEBUG

#define TestLog(FORMAT, ...) fprintf(stderr,"[TEST LOG] %s\n",[[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]);

#else

#define TestLog(...)

#endif


@interface MYRoutersTests : XCTestCase

@property (nonatomic, assign) BOOL didRoute;/**< 是否可以被路由到  */
@property (nonatomic, strong) NSDictionary *matchParam;/**<  匹配参数 */

@end

@implementation MYRoutersTests

- (void)setUp {
    TestLog(@"---------- start test ----------");
    
    [MYRouter setRouterVerboseLogEnabled:YES];
    [MYRouter setDefaultSchemaName:kRouterTestsSchema];
}

- (void)tearDown {
    [MYRouter removeAllInterceptors];
    [MYRouter unRegisterAllRouters];
    TestLog(@"----------  end test  ----------");
}

- (void)testRouter {
    TestLog(@"test register test/ and route ①test/ ②/test ③test ④add query");
    [[MYRouter defaultRouter] registerRouter:@"test/"
                               handlerAction:[self defaultHandlerAction]];
    [[MYRouter defaultRouter] registerRouter:@"test/test2"
                               handlerAction:[self defaultHandlerAction]];
    
    NSDictionary *appRouterDict = [MYRouter allRouterParameters];
    XCTAssertEqual(appRouterDict.count, 1,@"app router parameters's count is not equal 1");
    XCTAssertEqual(MYRouter.defaultRouter.routerItems.count, 2,@"app router parameters's count is not equal 2");
    
    [self route:@"test/"];
    MYRouteAssertCanRoute();
    MYRouteAssertParameter(@{});

    [self route:@"/test"];
    MYRouteAssertCanRoute();
    MYRouteAssertParameter(@{});

    [self route:@"test"];
    MYRouteAssertCanRoute();
    MYRouteAssertParameter(@{});
    
    [self route:@"test?aaa=1&bbb=2"];
    MYRouteAssertCanRoute();
    NSDictionary *resultParam = @{@"aaa" : @"1", @"bbb": @"2"};
    MYRouteAssertParameter(resultParam);
    
    [self route:@"/test?aaa=1&bbb=2"];
    MYRouteAssertCanRoute();
    NSDictionary *resultParam1 = @{@"aaa" : @"1", @"bbb": @"2"};
    MYRouteAssertParameter(resultParam1);
    
    [self route:@"/test/test2?aaa=1&bbb=2"];
    MYRouteAssertCanRoute();
    NSDictionary *resultParam2 = @{@"aaa" : @"1", @"bbb": @"2"};
    MYRouteAssertParameter(resultParam2);
}

- (void)testRouterWithParameter {
    TestLog(@"test register test/ and route ①test/ ②/test ③test ④add query with parameters");
    [[MYRouter defaultRouter] registerRouter:@"test/"
                               handlerAction:[self defaultHandlerAction]];
    [[MYRouter defaultRouter] registerRouter:@"test/test2"
                               handlerAction:[self defaultHandlerAction]];
    
    NSDictionary *appRouterDict = [MYRouter allRouterParameters];
    XCTAssertEqual(appRouterDict.count, 1,@"app router parameters's count is not equal 1");
    XCTAssertEqual(MYRouter.defaultRouter.routerItems.count, 2,@"app router parameters's count is not equal 2");
    NSDictionary *oriParam = @{@"id":@1,@"ccc":@"ddd"};
    [self route:@"test/" WithParameters:oriParam];
    MYRouteAssertCanRoute();
    MYRouteAssertParameter(oriParam);

    [self route:@"/test" WithParameters:oriParam];
    MYRouteAssertCanRoute();
    MYRouteAssertParameter(oriParam);

    [self route:@"test" WithParameters:oriParam];
    MYRouteAssertCanRoute();
    MYRouteAssertParameter(oriParam);

    [self route:@"test?aaa=1&bbb=2" WithParameters:oriParam];
    MYRouteAssertCanRoute();
    NSDictionary *resultParam = @{@"aaa" : @"1", @"bbb": @"2", @"id":@1,@"ccc":@"ddd"};
    MYRouteAssertParameter(resultParam);

    [self route:@"/test?aaa=1&bbb=2" WithParameters:oriParam];
    MYRouteAssertCanRoute();
    MYRouteAssertParameter(resultParam);
    
    [self route:@"/test/test2?aaa=1&bbb=2" WithParameters:oriParam];
    MYRouteAssertCanRoute();
    MYRouteAssertParameter(resultParam);
}



- (void)testSchemaRouter {
    [[MYRouter defaultRouter] registerRouter:@"test://test1"
                               handlerAction:[self defaultHandlerAction]];
    // 这里会忽略schema跳转
    [self route:@"test1://test1"];
    MYRouteAssertCanRoute();
}


- (void)testSchemaRouterOptional {
    [[MYRouter defaultRouter] registerRouter:@"test://test1"
                               handlerAction:[self defaultHandlerAction]];
    [[MYRouter defaultRouter] registerRouter:@"test://test1/:houseId/:roomId"
                               handlerAction:[self defaultHandlerAction]];
    // 这里会忽略schema跳转
    [self route:@"test1://test1/123/1"];
    NSDictionary *resultParam = @{@"houseId" : @"123", @"roomId" : @"1"};
    MYRouteAssertCanRoute();
    MYRouteAssertParameter(resultParam);
    
    [self route:@"test1://test1"];
    MYRouteAssertCanRoute();
}

// 优先级
- (void)testSchemaRouterOptionalWithPrority {
    //TODO: wmy test 去除注释
//    [[MYRouter defaultRouter] registerRouter:@"test://test1"
//                               handlerAction:[self defaultHandlerAction]];
    [[MYRouter defaultRouter] registerRouter:@"test://test1/:houseId/:roomId"
                                    priority:MYROUTER_PRIORITY_HIGH
                               handlerAction:[self defaultHandlerAction]];

    // 这里会忽略schema跳转
    [self route:@"test1://test1/123/1"];
    NSDictionary *resultParam = @{@"houseId" : @"123", @"roomId" : @"1"};
    MYRouteAssertCanRoute();
    MYRouteAssertParameter(resultParam);
    
//    [self route:@"test1://test1"];
//    MYRouteAssertCanRoute();
}


- (void)testInterceptor {
    [[MYRouter defaultRouter] addInterceptorWithRouter:@"test1" paramName:@[] preAction:^BOOL(NSDictionary *param) {
        TestLog(@"execute pre actoin with param:%@",param);
        return NO;
    } postAction:^BOOL(NSDictionary *param) {
        TestLog(@"execute pre actoin with param:%@",param);
        return YES;
    }];
    [[MYRouter defaultRouter] registerRouter:@"test://test1"
                               handlerAction:[self defaultHandlerAction]];
    [self route:@"test1://test1"];
    MYRouteAssertCanNotRoute();
}

// 测试拦截器
- (void)testInterceptorWithURLParam {
    NSDictionary *resultParam = @{@"houseId" : @"123", @"roomId" : @"1"};
    NSDictionary *inteceptorParam = @{@"houseId" : @"123", @"roomId" : @"1",@"originalRouter":@"test1://test1/123/1"};
    [[MYRouter defaultRouter] addInterceptorWithRouter:@"test1/:houseId/:roomId" paramName:@[] preAction:^BOOL(NSDictionary *param) {
        TestLog(@"execute pre actoin with param:%@",param);
        XCTAssertTrue([param isEqualToDictionary:inteceptorParam]);
        return YES;
    } postAction:^BOOL(NSDictionary *param) {
        TestLog(@"execute pre actoin with param:%@",param);
        XCTAssertTrue([param isEqualToDictionary:inteceptorParam]);
        return YES;
    }];
    [[MYRouter defaultRouter] registerRouter:@"test1/:houseId/:roomId"
                               handlerAction:[self defaultHandlerAction]];
    
    [self route:@"test1://test1/123/1"];
    
    MYRouteAssertCanRoute();
    MYRouteAssertParameter(resultParam);
}


- (void)testInterceptorWithURLParamWithCustom {
    NSDictionary *inteceptorParam = @{@"houseId" : @"123", @"roomId" : @"1",@"originalRouter":@"test1://test1/123/1"};
    [[MYRouter defaultRouter] addInterceptorWithRouter:@"/test1/:houseId/:roomId" paramName:@[@"houseId",@"roomId"] preAction:^BOOL(NSDictionary *param) {
        TestLog(@"execute pre actoin with param:%@",param);
        XCTAssertTrue([param isEqualToDictionary:inteceptorParam]);
        return NO;
    } postAction:^BOOL(NSDictionary *param) {
        TestLog(@"execute pre actoin with param:%@",param);
        XCTAssertTrue([param isEqualToDictionary:inteceptorParam]);
        return YES;
    }];
    
    [[MYRouter defaultRouter] registerRouter:@"test1/:houseId/:roomId"
                               handlerAction:[self defaultHandlerAction]];
    
    [self route:@"test1://test1/123/1"];
    
    MYRouteAssertCanNotRoute();
}

- (void)testInterceptorWithURLParamWithHouseIdRoomId {
    NSDictionary *inteceptorParam = @{@"houseId" : @"123", @"roomId" : @"1",@"originalRouter":@"test1://test1/123/1"};
    [[MYRouter defaultRouter] addInterceptorWithRouter:@"test1/:houseId/:roomId" paramName:@[@"houseId",@"roomId"] preAction:^BOOL(NSDictionary *param) {
        TestLog(@"execute pre actoin with param:%@",param);
        XCTAssertTrue([param isEqualToDictionary:inteceptorParam]);
        return NO;
    } postAction:^BOOL(NSDictionary *param) {
        TestLog(@"execute pre actoin with param:%@",param);
        XCTAssertTrue([param isEqualToDictionary:inteceptorParam]);
        return YES;
    }];
    
    [[MYRouter defaultRouter] registerRouter:@"test1/:houseId/:roomId"
                               handlerAction:[self defaultHandlerAction]];
    
    [self route:@"test1://test1/123/1"];
    
    MYRouteAssertCanNotRoute();
}

// 测试多个拦截器
- (void)testMultiInterceptorsWithURLParamWithCustom {
//    NSDictionary *resultParam = @{@"houseId" : @"123", @"roomId" : @"1"};
    NSDictionary *inteceptorParam = @{@"log" : @"logDescription", @"login" : @"1",@"originalRouter":@"test1://test1/123/1?log=logDescription&login=1"};
    [[MYRouter defaultRouter] addInterceptorWithRouter:@"*" paramName:@[@"log"] preAction:^BOOL(NSDictionary *param) {
        TestLog(@"execute pre actoin with param:%@",param);
        XCTAssertTrue([param isEqualToDictionary:inteceptorParam]);
        return NO;
    } postAction:^BOOL(NSDictionary *param) {
        TestLog(@"execute pre actoin with param:%@",param);
        XCTAssertTrue([param isEqualToDictionary:inteceptorParam]);
        return YES;
    }];
    
    [[MYRouter defaultRouter] addInterceptorWithRouter:@"*" paramName:@[@"login"] preAction:^BOOL(NSDictionary *param) {
        TestLog(@"execute pre actoin with param:%@",param);
        XCTAssertTrue([param isEqualToDictionary:inteceptorParam]);
        BOOL login = [param[@"login"] boolValue];
        if (login) {
            return YES;
        }
        return NO;
    } postAction:^BOOL(NSDictionary *param) {
        TestLog(@"execute pre actoin with param:%@",param);
        XCTAssertTrue([param isEqualToDictionary:inteceptorParam]);
        return YES;
    }];
    
    
    [[MYRouter defaultRouter] registerRouter:@"test1/:houseId/:roomId"
                               handlerAction:[self defaultHandlerAction]];
    
    [self route:@"test1://test1/123/1?log=logDescription&login=1"];
    
    MYRouteAssertCanNotRoute();
}


#pragma mark - utils

- (void)route:(NSString *)routeURL {
    [self route:routeURL WithParameters:nil];
}

- (void)route:(NSString *)routeURL WithParameters:(NSDictionary *)param {
    self.didRoute = [[MYRouter defaultRouter] routerURL:routeURL WithParameters:param];
}

- (BOOL (^)(NSDictionary *))defaultHandlerAction {
    BOOL(^handlerActionBlock)(NSDictionary *params) = ^BOOL (NSDictionary *params) {
        self.matchParam = params;
        TestLog(@"do router success!");
        return YES;
    };
    return handlerActionBlock;
}

@end

//
//  MYRouterServer.h
//  MYRouter
//
//  Created by APPLE on 2022/10/10.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class MYRouterResponse;
@class MYRouterRequest;
@class MYRouter;
@protocol MYRouterItemProtocol;

@interface MYRouterServer : NSObject

+ (instancetype)sharedInstance;

- (MYRouterResponse *)executeRequest:(MYRouterRequest *)request inRouterItems:(NSArray<id<MYRouterItemProtocol>> *)routerItems;

@end

NS_ASSUME_NONNULL_END

//
//  MYRouterResponse.h
//  MYRouter
//
//  Created by APPLE on 2022/10/10.
//

#import <Foundation/Foundation.h>
#import "MYRouterItemProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface MYRouterResponse : NSObject

@property (nonatomic, assign) BOOL isMatch;/**< 是否查找到符合的router  */ 

@property (nonatomic, strong) NSObject<MYRouterItemProtocol> *item;/**<  符合的router */

@property (nonatomic, strong) NSDictionary *allParameters;

@end

NS_ASSUME_NONNULL_END

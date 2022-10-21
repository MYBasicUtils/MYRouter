//
//  MYRouterInterceptorCondition.h
//  MYRouter
//
//  Created by APPLE on 2022/10/20.
//

#import <Foundation/Foundation.h>
#import "MYRouterItemProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface MYRouterInterceptorCondition : NSObject <MYRouterItemProtocol>

@property (nonatomic, strong) NSString *schema;/**<  schema */
@property (nonatomic, strong) NSString *pathString;/**<  原始路径 */
@property (nonatomic, strong) NSString *router;/**< 修改过后的router  */ 
@property (nonatomic, strong) NSString *hostPathComponents;/**<  host path */

@property (nonatomic, strong) NSArray<NSString *> *requireParams;/**<  判定path中需要的param */

- (BOOL)matchRequest:(NSString *)hostPathComponent;

- (BOOL)matchRouter:(NSString *)router withParam:(NSDictionary *)param;

@end

NS_ASSUME_NONNULL_END

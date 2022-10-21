//
//  MYRouter+Private.h
//  MYRouter
//
//  Created by APPLE on 2022/10/10.
//

#import "MYRouter.h"
#import "MYRouterItemModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MYRouter (Private)

@property (nonatomic, strong) NSMutableArray<MYRouterItemModel *> *routerItems;/**<  路由 */

+ (NSDictionary *)allRouterParameters;

@end

NS_ASSUME_NONNULL_END

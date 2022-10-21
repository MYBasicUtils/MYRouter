//
//  MYRouterItemModel.h
//  MYRouter
//
//  Created by MingYan on 2022/10/9.
//  用于存放注册时的router

#import <Foundation/Foundation.h>
#import "MYRouterItemProtocol.h"

@class MYRouterAction;

NS_ASSUME_NONNULL_BEGIN

@interface MYRouterItemModel : NSObject <MYRouterItemProtocol>

@property (nonatomic, strong) NSString *schema;/**<  schema */
@property (nonatomic, strong) NSString *pathString;/**<  原始路径 */
@property (nonatomic, strong) NSString *router;/**< 修改过后的router  */ 

@property (nonatomic, strong, readonly) NSString *hostPathComponents;/**<  host path */

@property (nonatomic, strong) NSArray<NSString *> *requireParams;/**<  判定path中需要的param */

@property(nonatomic, strong) MYRouterAction *action;/**< 动作  */
@property (nonatomic, assign) NSInteger priority;/**< 优先级  */

- (BOOL)matchRequest:(NSString *)hostPathComponent;

@end

NS_ASSUME_NONNULL_END

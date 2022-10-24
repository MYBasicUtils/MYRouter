//
//  MYRouterItemProtocol.h
//  Pods
//
//  Created by APPLE on 2022/10/20.
//

#ifndef MYRouterItemProtocol_h
#define MYRouterItemProtocol_h

#import <Foundation/Foundation.h>

@protocol MYRouterItemProtocol

@property (nonatomic, strong) NSString *scheme;/**<  scheme */
@property (nonatomic, strong) NSString *pathString;/**<  原始路径 */
@property (nonatomic, strong) NSString *router;/**< 修改过后的router  */ 

@property (nonatomic, strong, readonly) NSString *hostPathComponents;/**<  host path */

@property (nonatomic, strong) NSArray<NSString *> *requireParams;/**<  判定path中需要的param */

- (BOOL)matchRequest:(NSString *)hostPathComponent;

@end
#endif /* MYRouterItemProtocol_h */

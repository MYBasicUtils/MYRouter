//
//  MYRouterItemModel.m
//  MYRouter
//
//  Created by MingYan on 2022/10/9.
//

#import "MYRouterItemModel.h"
#import "MYRouterUtils.h"

@interface MYRouterItemModel ()

@property (nonatomic, strong) NSString *hostPathComponents;/**<  host path */

@end

@implementation MYRouterItemModel

- (void)setPathString:(NSString *)pathString {
    _pathString = pathString;
    NSString *requestURL = [MYRouterUtils requestURLWithRouterURL:pathString inSchema:self.schema];
    self.router = [MYRouterUtils fullPathInRequestURL:requestURL];
    self.hostPathComponents = [MYRouterUtils pathWithOutParamInRequestURL:requestURL];
    self.requireParams = [MYRouterUtils reqireParams:requestURL];
}

- (BOOL)matchRequest:(NSString *)hostPathComponent {
    return [MYRouterUtils router:hostPathComponent isMatchWithRouter:self.router];
}



@end

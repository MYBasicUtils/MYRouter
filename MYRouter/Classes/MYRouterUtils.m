//
//  MYRouterUtils.m
//  MYRouter
//
//  Created by APPLE on 2022/10/10.

#import "MYRouterUtils.h"

NSString *kMYRouterWildcardCharacter = @"[\\w]+";

@implementation MYRouterUtils

+ (NSString *)requestURLWithRouterURL:(NSString *)routeURL inScheme:(NSString *)scheme {
    NSMutableString *requestURL = [NSMutableString string];
    NSString *tempRouteURL = routeURL;
    //TODO: 判断是否有scheme，如果没有scheme进行requestURL的全拼串
    if (!routeURL.length) {
        return [NSString stringWithFormat:@"%@://",scheme];
    }
    // scheme
    [requestURL appendString:[NSString stringWithFormat:@"%@:/",scheme]];
    NSRange range = [tempRouteURL rangeOfString:@":/"];
    if (range.length != NSNotFound && range.length != 0) {
        // 找到了，前面是scheme，后面是host + path
        tempRouteURL = [tempRouteURL substringWithRange:NSMakeRange(range.location + 2, tempRouteURL.length - range.location -2)];
    }
    if (![tempRouteURL hasPrefix:@"/"]) {
        [requestURL appendString:@"/"];
    }
    NSURLComponents *components = [[NSURLComponents alloc] initWithString:tempRouteURL];
    if (components.host.length) {
        [requestURL appendString:components.host];
    }
    if (components.path.length) {
        [requestURL appendString:components.path];
    }
    
    if ([requestURL hasSuffix:@"/"]) {
        [requestURL deleteCharactersInRange:NSMakeRange(requestURL.length - 1, 1)];
    }
    // 处理参数情况
    if (components.queryItems.count) {
        [requestURL appendString:@"?"];
        for (NSURLQueryItem *queryItem in components.queryItems) {
            [requestURL appendString:[NSString stringWithFormat:@"%@=%@",queryItem.name,queryItem.value]];
            [requestURL appendString:@"&"];
        }
        [requestURL deleteCharactersInRange:NSMakeRange(requestURL.length - 1, 1)];
    }
    return requestURL;
}

+ (NSString *)fullPathInRequestURL:(NSString *)requestURL {
    NSMutableString *result = [NSMutableString string];
    NSURLComponents *components = [[NSURLComponents alloc] initWithString:requestURL];
    if (components.host.length) {
        [result appendString:@"/"];
        [result appendString:components.host];
    }
    if (components.path.length) {
        if (components.path.length) {
            if ([components.path isEqualToString:@"/"]) {
                [result appendString:@"/"];
            } else {
                NSArray<NSString *> *paths = [components.path componentsSeparatedByString:@"/"];
                for (NSString *path in paths) {
                    if (!path.length) {
                        continue;
                    }
                    [result appendString:@"/"];
                    if (![path hasPrefix:@":"]) {
                        [result appendString:path];
                    } else {
                        [result appendString:kMYRouterWildcardCharacter];
                    }
                }
            }
        }
    }
    return result.copy;
}

+ (NSString *)pathWithOutParamInRequestURL:(NSString *)requestURL {
    NSMutableString *result = [NSMutableString string];
    NSURLComponents *components = [[NSURLComponents alloc] initWithString:requestURL];
    if (components.host.length) {
        [result appendString:@"/"];
        [result appendString:components.host];
    }
    if (components.path.length) {
        if (components.path.length) {
            if ([components.path isEqualToString:@"/"]) {
                [result appendString:@"/"];
            } else {
                NSArray<NSString *> *paths = [components.path componentsSeparatedByString:@"/"];
                for (NSString *path in paths) {
                    if (!path.length) {
                        continue;
                    }
                    if (![path hasPrefix:@":"]) {
                        [result appendString:@"/"];
                        [result appendString:path];
                    }
                }
            }
        }
    }
    return result.copy;
}

+ (NSArray *)reqireParams:(NSString *)requestURL {
    NSMutableArray<NSString *> *result = [NSMutableArray array];
    NSURLComponents *components = [[NSURLComponents alloc] initWithString:requestURL];
    if (components.path.length) {
        NSArray<NSString *> *paths = [components.path componentsSeparatedByString:@"/"];
        for (NSString *path in paths) {
            if (!path.length) {
                continue;
            }
            if ([path hasPrefix:@":"] && path.length > 1) {
                [result addObject:[path substringWithRange:NSMakeRange(1, path.length - 1)]];
            }
        }
    }
    
    return result.copy;
}

+ (NSDictionary *)parametersInRequestURL:(NSString *)requestURL {
    NSURLComponents *components = [[NSURLComponents alloc] initWithString:requestURL];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    for (NSURLQueryItem *queryItem in components.queryItems) {
        param[queryItem.name] = queryItem.value;
    }
    return param.copy;
}



+ (BOOL)router:(NSString *)router1 isMatchWithRouter:(NSString *)router2 {
    if ([router2 isEqualToString:@"/*"] || [router2 isEqualToString:@"*"]) {
        return YES;
    }
    // 完全相等。
    if ([router1 isEqualToString:router2]) {
        return YES;
    } else if ([router2 containsString:kMYRouterWildcardCharacter]){
        NSMutableString *tmpPath = [NSMutableString string];
        NSArray<NSString *> *paths = [router1 componentsSeparatedByString:@"/"];
        for (NSString *aPath in paths) {
            if (!aPath.length) {
                continue;
            }
            [tmpPath appendString:@"/"];
            [tmpPath appendString:aPath];
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",router2];
            if ([predicate evaluateWithObject:tmpPath]) {
                return YES;
            }
        }
        return NO;
    }
    return NO;
}

@end

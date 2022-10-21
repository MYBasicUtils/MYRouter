# MYRouter

## 描述

MYRouter用于构建一个高效的Router，并且可以通过一定的规则添加拦截器。MYRouter旨在使用较少的代码轻松处理应用程序中复杂的URL方案。

## 安装

MYRouter可使用Cocoapods进行安装。

## 入门

### 1. 注册router

MYRouter可以在任何地方进行初始化和注册。
```
[MYRouter defaultRouter] registerRouter:@"<#your router#>" handlerAction:^BOOL(NSDictionary *param) {
    // do something
}];
```

MYRouter提供了多种注册方式：
```

/// 注册router，并规定router的动作
- (void)registerRouter:(NSString *)router handlerAction:(BOOL (^)(NSDictionary *))actionBlock;

/// 注册router，并规定router的动作
/// @description 由于方法没有schema入口，因此使用默认schema进行注册
+ (void)registerRouter:(NSString *)router handlerAction:(BOOL (^)(NSDictionary *))actionBlock;

/// 注册router，并规定router的动作
/// @param router router
/// @param priority 优先级，
/// @param actionBlock 动作
- (void)registerRouter:(NSString *)router priority:(NSInteger)priority handlerAction:(BOOL(^)(NSDictionary *param))actionBlock;

/// 注册router，并规定router的动作
/// @param router router
/// @param priority 优先级
/// @param schema schema
/// @param actionBlock 动作
+ (void)registerRouter:(NSString *)router
              priority:(NSInteger)priority
              toSchema:(NSString *)schema
         handlerAction:(BOOL(^)(NSDictionary *param))actionBlock;
```

在注册router之后，即可在任意处进行打开URL:
```
    [[MYRouter defaultRouter] routerURL:<#your router has registed#> WithParameters:<#parameter#>];
```



路由也可以使用下标语法注册：
```
[MYRouter defaultRouter] registerRouter:@"/test/:houseId/:roomId" handlerAction:^BOOL(NSDictionary *param) {
        // do something
    }];
```
添加之后，对于路由：/test/houseId123/roomId456 ,返回的参数中会带有：
```
{
    "houseId":"houseId123",
    "roomId" :"roomId456"   
}
```

#### 1.1 优先级

在注册一定量的router规则后，有可能在跳转时match多个router，此时会默认根据注册的规则进行跳转，一旦有一个符合条件，后续即使有符合条件的router也不会再调用。
若需要将某个优先级进行提前，可以将优先级调整为MYROUTER_PRIORITY_HIGH

#### 1.2 MYRouter 默认schema
MYRouter自带默认的schema为"default", 开发者可以使用以下方法重新配置：
```
[MYRouter setDefaultSchemaName:@"<#your schema#>"];
```


### 2. 拦截器

拦截器的作用主要是通过注册router的规则对路径或带有部分参数的url做拦截，之后根据开发者的规则来判定拦截与否。

注册拦截器：
```
 [[MYRouter defaultRouter] addInterceptorWithRouter:@"<#your interceptor router#>" paramName:@[@"paramName"] preAction:^BOOL(NSDictionary *param) {
    // 当返回NO之后，router将不会进行跳转，但是该拦截器的postAction会执行
    // 当返回NO之后，若之后还有拦截器，则会不会再执行后续的拦截器操作。
    return NO;
} postAction:^BOOL(NSDictionary *param) {
    // postAction 通常返回YES，主要用于一些前置拦截的数据回收工作
    // 目前返回无特殊作用
    return YES;
}];
```
如果注册多个拦截器，则会根据注册顺序调用preAction，逆序调用postAction。

在注册拦截器后，如果对应的router符合拦截器的规则，则会启用拦截器，不符合则直接跳过。

拦截器是有顺序的，通常先注册的拦截器先调用。


### 后续计划
1. 添加通配符
2. 列出结构图

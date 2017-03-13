iOS APP 网络请求框架
===
- 用 Objective-C 实现的. 
- 项目依赖[AFNetworking 3.0](https://github.com/AFNetworking/AFNetworking)
- 支持 ARC 和 CocoaPods 
- iOS 7.0
- 编译环境 Xcode 8.0

===

###CocoaPods:

`pod 'TUNetworking'`


###有什么问题请issue我

GitHub：[chengxianghe](https://github.com/chengxianghe) 

###Usage

参照Demo


普通GET请求
```
TestRequest *request = [[TestRequest alloc] init];

[request sendRequestWithSuccess:^(__kindof TUBaseRequest * _Nonnull baseRequest, id  _Nullable responseObject) {
    NSLog(@"requestSuccess:%@", responseObject);
} failur:^(__kindof TUBaseRequest * _Nonnull baseRequest, NSError * _Nonnull error) {
    NSLog(@"requestFailur:%@", error);
}];

```

普通GET请求带缓存读取
```
TestRequest *request = [[TestRequest alloc] init];

[request sendRequestWithCache:^(__kindof TUBaseRequest * _Nonnull baseRequest, id  _Nullable cacheResult, NSError * _Nonnull error) {
    if (error) {
        NSLog(@"Read Cache Error:%@!", error.description);
    } else {
        NSLog(@"Read Cache Succeed For Request:%@", NSStringFromClass([request class]));
    }
} success:^(__kindof TUBaseRequest * _Nonnull baseRequest, id  _Nullable responseObject) {
    NSLog(@"requestSuccess:%@", responseObject);
} failur:^(__kindof TUBaseRequest * _Nonnull baseRequest, NSError * _Nonnull error) {
    NSLog(@"requestFailur:%@", error);
}];

```
缓存大小计算
```
[TUCacheManager getCacheSizeOfAllWithCompletion:^(CGFloat totalSize) {
    NSLog(@"%@", [NSString stringWithFormat:@"request缓存大小：%.2f K", totalSize/1024]);
}];
```

缓存清理
```
[TUCacheManager getCacheSizeOfAllWithCompletion:^(CGFloat totalSize) {
    NSLog(@"开始清理缓存！总缓存大小：%.2f M", totalSize/1024/1024);
    [TUCacheManager clearAllCacheWithCompletion:^{
        NSLog(@"清理缓存完成！");
        sender.enabled = YES;
    }];
}];
```

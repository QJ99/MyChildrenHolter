//
//  ChildHTTPSessionManager.m
//  ChildrenTemp
//
//  Created by QJ on 15/3/3.
//  Copyright (c) 2015年 QJ. All rights reserved.
//

#import "ChildHTTPSessionManager.h"
#import "MJExtension.h"
static ChildHTTPSessionManager *_instace;
@implementation ChildHTTPSessionManager
+(instancetype)shareChildHTTPSessionManager{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instace = [[self alloc]initWithBaseURL:[NSURL URLWithString:kHttpRequestPath]];
        _instace.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
        [_instace.responseSerializer setAcceptableContentTypes:[NSSet setWithObject:@"text/html"]];
    });
    return _instace;
}
-(void)startNetworkActivityIndicatorVisible{
    [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:YES];
}
-(void)stopNetworkActivityIndicatorVisible{
    __block BOOL check = NO;
   [self.tasks enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
       NSURLSessionTask *task = (NSURLSessionTask*)obj;
       if ([task state] == NSURLSessionTaskStateRunning) {
           check = YES;
           *stop = YES;
       }
   }];
    if (!check) {
        [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:check];
    }
}
+(instancetype)allocWithZone:(struct _NSZone *)zone{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instace = [super allocWithZone:zone];
    });
    return _instace;
}
- (void)postBaseWithPath:(NSString *)path
              parameters:(NSDictionary *)param
                 success:(void (^)(id responseObject))success
                 failure:(void (^)(NSError *error))failure{
    [self startNetworkActivityIndicatorVisible];
    [self POST:path parameters:param success:^(NSURLSessionDataTask *task, id responseObject) {
        if (success) {
            success(responseObject);
        }
        [self stopNetworkActivityIndicatorVisible];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}
#pragma mark -登录
-(void)postLogin:(NSDictionary *)param success:(void (^)(LoginInfor *status, LoginModel *model))success failure:(void (^)(NSError *error))failure{
    [self postBaseWithPath:@"Interface/login" parameters:param success:^(id responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]]&&[[responseObject allKeys]containsObject:@"status"]&&[[responseObject allKeys]containsObject:@"info"]) {
            LoginInfor *status = [LoginInfor objectWithKeyValues:responseObject];
            LoginModel *model = status.data[0];//当前子用户
            success(status,model);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}
#pragma mark -注册
- (void)postRegister:(NSDictionary *)param success:(void (^)(InforModel *, LoginModel *))success failure:(void (^)(NSError *))failure{
    [self postBaseWithPath:@"Interface/register" parameters:param success:^(id responseObject) {
      
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}
@end

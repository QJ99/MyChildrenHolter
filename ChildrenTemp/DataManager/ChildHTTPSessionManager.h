//
//  ChildHTTPSessionManager.h
//  ChildrenTemp
//
//  Created by QJ on 15/3/3.
//  Copyright (c) 2015年 QJ. All rights reserved.
//

#import "AFHTTPSessionManager.h"
#import "LoginInfor.h"
#import "LoginModel.h"
#import "InforModel.h"
@interface ChildHTTPSessionManager : AFHTTPSessionManager
+(instancetype)shareChildHTTPSessionManager;
-(void)postLogin:(NSDictionary *)param success:(void (^)(LoginInfor *status, LoginModel *infor))success failure:(void (^)(NSError *error))failure;
-(void)postRegister:(NSDictionary *)param success:(void (^)(InforModel *status, LoginModel *infor))success failure:(void (^)(NSError *error))failure;
@end

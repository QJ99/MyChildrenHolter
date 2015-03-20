//
//  LoginInfor.m
//  ChildrenTemp
//
//  Created by QJ on 15/3/19.
//  Copyright (c) 2015年 QJ. All rights reserved.
//

#import "LoginInfor.h"
#import "LoginModel.h"

@implementation LoginInfor
+ (NSDictionary *)objectClassInArray
{
    return @{
             @"data" : [LoginModel class],
             };
}
@end

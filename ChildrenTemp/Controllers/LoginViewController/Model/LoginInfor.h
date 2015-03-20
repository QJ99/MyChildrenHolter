//
//  LoginInfor.h
//  ChildrenTemp
//
//  Created by QJ on 15/3/19.
//  Copyright (c) 2015年 QJ. All rights reserved.
//

#import "InforModel.h"
@interface LoginInfor : InforModel
@property(strong, nonatomic) NSString *account;
@property(strong, nonatomic) NSString *uid;
//@property(strong, nonatomic) NSMutableDictionary *data;
@property (strong, nonatomic) NSArray *data;
@end

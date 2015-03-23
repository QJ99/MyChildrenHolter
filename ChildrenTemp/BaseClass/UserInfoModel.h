//
//  UserInfoModel.h
//  ChildrenTemp
//
//  Created by QJ on 15/3/3.
//  Copyright (c) 2015年 QJ. All rights reserved.
//

#import "BaseModel.h"
@interface UserInfoModel : BaseModel
@property (nonatomic, strong) NSString *uid;
@property (nonatomic, strong) NSString *account;
@property (nonatomic, strong) NSString *userName;
@property (nonatomic, strong) NSString *password;
@property (nonatomic, strong) NSString *ring;
@property (nonatomic, strong) NSMutableArray *childArray;
@end

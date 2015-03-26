//
//  HolterChildDataManager.m
//  ChildrenTemp
//
//  Created by QJ on 15/3/3.
//  Copyright (c) 2015年 QJ. All rights reserved.
//

#import "HolterChildDataManager.h"
static HolterChildDataManager *_instace;
@implementation HolterChildDataManager
+(id)sharedHolterChildDataManagerInstance{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instace = [[self alloc]init];
    });
    return _instace;
}
+(instancetype)allocWithZone:(struct _NSZone *)zone{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instace = [super allocWithZone:zone];
    });
    return _instace;
}
static HomeViewController *staticHome = nil;
static dispatch_once_t onceToken;
- (HomeViewController *)homeVC{
    dispatch_once(&onceToken, ^{
        staticHome = [[HomeViewController alloc] initWithNibName:@"HomeViewController" bundle:nil];
    });
    return staticHome;
}

- (void)resetNilHomeVC{
    staticHome = nil;
    onceToken = 0;
}

-(void)homeAnimateShowLeftSide:(BOOL)animation{
    [HDM.homeVC animationMove];
}
- (void)popHlintMsg:(NSString *)message{
    if (!message) {
        return;
    }
    UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"温馨提醒" message:message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alter show];
}
- (void)errorPopMsg:(NSError *)error{
//    DLog(@"%@----%ld",error,(long)error.code);
    if ([error code] == -1004) {
        [self popHlintMsg:HTTPConnectSeverError];
    }else if ([error code] == -1001){
        [self popHlintMsg:HTTPConnectOutOfTime];
    }else{
        [self popHlintMsg:HTTPConnectFaildError];
    }
}
-(BOOL)isEmail:(NSString *)email{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}
-(BOOL)isPhoneNum:(NSString*)honeNum{
    NSString *telphone = @"^(1(([357][0-9])|(47)|[8][012356789]))\\d{8}$";
    NSPredicate *telphoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", telphone];
    return [telphoneTest evaluateWithObject:honeNum];
}
@end

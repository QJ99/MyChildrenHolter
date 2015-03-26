//
//  HolterChildDataManager.h
//  ChildrenTemp
//
//  Created by QJ on 15/3/3.
//  Copyright (c) 2015年 QJ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "HomeViewController.h"
#import "BaseViewController.h"
@interface HolterChildDataManager : NSObject
@property (nonatomic, readonly) HomeViewController *homeVC;
+ (id)sharedHolterChildDataManagerInstance;
- (void)popHlintMsg:(NSString *)message;
- (void)errorPopMsg:(NSError *)error;
-(BOOL)isEmail:(NSString *)email;
-(BOOL)isPhoneNum:(NSString*)honeNum;
- (void)homeAnimateShowLeftSide:(BOOL)animation;
@end

//
//  HolterChildDataManager.h
//  ChildrenTemp
//
//  Created by QJ on 15/3/3.
//  Copyright (c) 2015年 QJ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface HolterChildDataManager : NSObject
+ (id)sharedHolterChildDataManagerInstance;
- (void)popHlintMsg:(NSString *)message;
- (void)errorPopMsg:(NSError *)error;
-(BOOL)isEmail:(NSString *)email;
-(BOOL)isPhoneNum:(NSString*)honeNum;
@end

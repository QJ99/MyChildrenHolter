//
//  CommonController.h
//  ChildrenTemp
//
//  Created by qj on 15/3/24.
//  Copyright (c) 2015年 QJ. All rights reserved.
//

#import "BaseViewController.h"
@class CommonController;
@protocol CommonViewDelegate<NSObject>
-(void)mainMenuButtonClick:(CommonController*)main isTapButton:(BOOL)isTap;
@end
@interface CommonController : BaseViewController
@property(weak, nonatomic) id<CommonViewDelegate>delegate;
@end

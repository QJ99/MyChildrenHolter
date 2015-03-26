//
//  ConnectViewController.h
//  ChildrenTemp
//
//  Created by QJ on 15/3/25.
//  Copyright (c) 2015年 QJ. All rights reserved.
//

#import "CommonController.h"
@class ConnectViewController;
@protocol connectviewDelegate<NSObject,CommonViewDelegate>
-(void)connectview:(ConnectViewController*)connect pushController:(BOOL)push;
@end
@interface ConnectViewController : CommonController
@property (weak, nonatomic)id<connectviewDelegate> connectDelegate;
@property (strong, nonatomic) NSString *title;
@end

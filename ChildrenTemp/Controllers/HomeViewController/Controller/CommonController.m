//
//  CommonController.m
//  ChildrenTemp
//
//  Created by qj on 15/3/24.
//  Copyright (c) 2015年 QJ. All rights reserved.
//

#import "CommonController.h"

@interface CommonController ()

@end

@implementation CommonController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (IBAction)menuButtonClick:(UIButton *)sender {
    if ([_delegate respondsToSelector:@selector(mainMenuButtonClick:isTapButton:)]) {
        [_delegate mainMenuButtonClick:self isTapButton:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

//
//  HomeViewController.m
//  ChildrenTemp
//
//  Created by QJ on 15/1/29.
//  Copyright (c) 2015年 QJ. All rights reserved.
//

#import "HomeViewController.h"
#import "HomeLeftView.h"
#define kdisRight 70
@interface HomeViewController ()

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    HomeLeftView *leftView = [HomeLeftView loadHomeLeftView];
    leftView.frame = CGRectMake(0, 0, self.view.frame.size.width-kdisRight, self.view.frame.size.height);
    [self.view addSubview:leftView];
    
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

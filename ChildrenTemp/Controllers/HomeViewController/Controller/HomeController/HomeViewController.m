//
//  HomeViewController.m
//  ChildrenTemp
//
//  Created by QJ on 15/1/29.
//  Copyright (c) 2015年 QJ. All rights reserved.
//

#import "HomeViewController.h"
#import "HomeLeftView.h"
#import "MainViewController.h"
#import "MyNavgationViewController.h"
#import "TempViewController.h"
#import "ColothingViewController.h"
#import "EnvironViewController.h"
#import "KnowLedgeViewController.h"
#import "SettingViewController.h"
#import "RemindViewController.h"
#import "UserCentryViewController.h"
#import "ConnectViewController.h"
#define kdisRight 70
@interface HomeViewController ()<CommonViewDelegate,homeLeftDelegate,connectviewDelegate>
@property (strong, nonatomic) MyNavgationViewController *myNav;
@end
@implementation HomeViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    HomeLeftView *leftView = [HomeLeftView loadHomeLeftView];
    [leftView setDelegate:self];
    [leftView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.view addSubview:leftView];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[leftView]-70-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(leftView)]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[leftView]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(leftView)]];
    ConnectViewController *connect = [[ConnectViewController alloc]init];
    _myNav = [[MyNavgationViewController alloc]initWithRootViewController:connect];
    [connect setDelegate:self];
    [connect setConnectDelegate:(id<connectviewDelegate>)self];
    _myNav.view.frame = self.view.bounds;
    [self.view addSubview:_myNav.view];
}
#pragma mark connectViewDelegate
-(void)connectview:(ConnectViewController *)connect pushController:(BOOL)push{
    MainViewController *main = [[MainViewController alloc]initWithNibName:@"MainViewController" bundle:nil];
    [main setDelegate:(id<CommonViewDelegate>)self];
    [self switchRootViewController:main];
}
#pragma mark -切换控制器
-(void)switchRootViewController:(UIViewController*)controller{
    if (!_myNav) {
        _myNav = [[MyNavgationViewController alloc]initWithRootViewController:controller];
    }else{
        [_myNav pushViewController:controller animated:NO];
    }
}
#pragma mark -cumter Delegate
#pragma mark 移动视图
-(void)mainMenuButtonClick:(CommonController*)main isTapButton:(BOOL)isTap{
    [self animationMove];
}
#pragma mark 模块切换（体温，环境，衣内）
-(void)homeLeftView:(HomeLeftView *)leftView selectItem:(NSString *)selelctItem{
    if ([selelctItem isEqualToString:@"体温测量"]) {
        TempViewController *temp = [[TempViewController alloc]initWithNibName:@"TempViewController" bundle:nil];
        [self switchRootViewController:temp];
        [temp setDelegate:self];
        [self animationMove];
    }else if ([selelctItem isEqualToString:@"衣内微气候"]){
        ColothingViewController *coloth = [[ColothingViewController alloc]initWithNibName:@"ColothingViewController" bundle:nil];
        [self switchRootViewController:coloth];
        [coloth setDelegate:self];
        
        [self animationMove];
    }else if ([selelctItem isEqualToString:@"环境温湿度"]){
        EnvironViewController *env = [[EnvironViewController alloc]initWithNibName:@"EnvironViewController" bundle:nil];
        [self switchRootViewController:env];
        [env setDelegate:self];
        [self animationMove];
    }else if ([selelctItem isEqualToString:@"KnowLedgeViewController"]){
        KnowLedgeViewController *knowledge = [[KnowLedgeViewController alloc]initWithNibName:@"KnowLedgeViewController" bundle:nil];
        [self switchRootViewController:knowledge];
        [knowledge setDelegate:self];
        [self animationMove];
    }else if ([selelctItem isEqualToString:@"SettingViewController"]){
        SettingViewController *setting = [[SettingViewController alloc]initWithNibName:@"SettingViewController" bundle:nil];
        [self switchRootViewController:setting];
        [setting setDelegate:self];
        [self animationMove];
    }else if ([selelctItem isEqualToString:@"RemindViewController"]){
        RemindViewController *setting = [[RemindViewController alloc]initWithNibName:@"RemindViewController" bundle:nil];
        [self switchRootViewController:setting];
        [setting setDelegate:self];
        [self animationMove];
    }else if ([selelctItem isEqualToString:@"UserCentryViewController"]){
        UserCentryViewController *user = [[UserCentryViewController alloc]initWithNibName:@"UserCentryViewController" bundle:nil];
        [self switchRootViewController:user];
        [user setDelegate:self];
        [self animationMove];
    }
}
#pragma mark 动画平移
-(void)animationMove{
    if (_myNav) {
        if (_myNav.view.frame.origin.x == 0) {
            [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                CGRect rect = _myNav.view.frame;
                rect.origin.x = self.view.frame.size.width-70;
                _myNav.view.frame = rect;
            } completion:^(BOOL finished) {
                
            }];
        }else{
            [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                CGRect rect = _myNav.view.frame;
                rect.origin.x = 0;
                _myNav.view.frame = rect;
            } completion:^(BOOL finished) {
                
            }];
        }
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

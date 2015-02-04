//
//  LogInViewController.m
//  ChildrenTemp
//
//  Created by QJ on 15/1/29.
//  Copyright (c) 2015年 QJ. All rights reserved.
//

#import "LogInViewController.h"
#import "RegisterViewController.h"
@interface LogInViewController ()
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UITextField *userNameTextfield;
@property (weak, nonatomic) IBOutlet UITextField *passWordTextfield;
@property (weak, nonatomic) IBOutlet UIButton *registerButton;
@end

@implementation LogInViewController
- (IBAction)exitedFeild:(UITextField *)sender {
}
- (IBAction)tapBgView:(UITapGestureRecognizer *)sender {
    [_passWordTextfield  resignFirstResponder];
    [_userNameTextfield resignFirstResponder];
}
- (IBAction)registerButtonClick:(UIButton *)sender {
    RegisterViewController *regisetVC = [[RegisterViewController alloc]init];
    [self.navigationController pushViewController:regisetVC animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [_registerButton.imageView setContentMode:UIViewContentModeScaleAspectFit];
    [_registerButton setBackgroundImage:[UIImage imageNamed:@"login_register.png"] forState:UIControlStateNormal];
    [_loginButton setBackgroundColor: kcolorWithRGB(255,131,85)];
    _loginButton.layer.cornerRadius = 15.0;
    _loginButton.layer.masksToBounds = YES;
    [_loginButton setTitle:@"登 录" forState:UIControlStateNormal];
    [_loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
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

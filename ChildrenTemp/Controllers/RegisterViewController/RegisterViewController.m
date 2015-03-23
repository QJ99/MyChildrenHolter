//
//  RegisterViewController.m
//  ChildrenTemp
//
//  Created by QJ on 15/2/4.
//  Copyright (c) 2015年 QJ. All rights reserved.
//

#import "RegisterViewController.h"
#import "MyButton.h"
@interface RegisterViewController ()
@property (weak, nonatomic) IBOutlet UITextField *userTextField;
@property (weak, nonatomic) IBOutlet UITextField *passWordTextField;
@property (weak, nonatomic) IBOutlet MyButton *RegisterButton;

@property (weak, nonatomic) IBOutlet MyButton *popButton;
@end

@implementation RegisterViewController
- (IBAction)quitKeyBoard:(UITapGestureRecognizer *)sender {
    [_passWordTextField resignFirstResponder];
    [_userTextField resignFirstResponder];
}
- (IBAction)doneQuite:(UITextField *)sender {
}
- (IBAction)registerButtonClick:(MyButton *)sender {
    if (!_userTextField || ![_userTextField.text length]) {
        [HDM popHlintMsg:@"请输入手机号或邮箱!"];
        return;
    }
    
    if (![HDM isEmail:_userTextField.text] && ![HDM isPhoneNum:_userTextField.text]) {
        [HDM popHlintMsg:@"请输入手机号或邮箱!"];
        return;
    }
    
    if (!_passWordTextField || ![_passWordTextField.text length] || [_passWordTextField.text length] < 6) {
        [HDM popHlintMsg:@"请输入密码[长度6-16位]!"];
        return;
    }
    
    NSDictionary *userDict = nil;
    if ([HDM isPhoneNum:_userTextField.text]) {//手机注册
        userDict = @{@"phone":_userTextField.text,
                     @"password":_passWordTextField.text,
                     };
    }else{
        userDict = @{@"email":_userTextField.text,
                     @"password":_passWordTextField.text,
                     };
    }
    MyLog(@"%@------%@------%@",_userTextField.text,_passWordTextField.text,userDict);
    [HHM postRegister:userDict success:^(InforModel *status, LoginModel *infor) {
        
    } failure:^(NSError *error) {
        
    }];
}
- (IBAction)popVC:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if (textField == _userTextField) {
    }else if (textField == _passWordTextField){
        if ([newString length] > 16) {
            return NO;
        }
    }
    return YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [_RegisterButton setBackgroundColor:kcolorWithRGB(255,131,85)];
    [_popButton.imageView setContentMode:UIViewContentModeScaleAspectFit];
    [_popButton setBackgroundImage:[UIImage imageNamed:@"login_register.png"] forState:UIControlStateNormal];
    [_popButton setTitle:@"已有账号，直接登录" forState:UIControlStateNormal];
    _RegisterButton.layer.cornerRadius = 15.0;
    _RegisterButton.layer.masksToBounds = YES;
    
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

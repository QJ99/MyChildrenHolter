//
//  TempViewController.m
//  ChildrenTemp
//
//  Created by qj on 15/3/24.
//  Copyright (c) 2015年 QJ. All rights reserved.
//

#import "TempViewController.h"
#import "CalendarSelectView.h"
@interface TempViewController ()
@property (weak, nonatomic) IBOutlet UIButton *addRecoder;
@property (weak, nonatomic) IBOutlet UIButton *historyButton;
@end

@implementation TempViewController
-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        [_historyButton.imageView setContentMode:UIViewContentModeScaleAspectFit];
        [_addRecoder.imageView setContentMode:UIViewContentModeScaleAspectFit];
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    CalendarSelectView *calendar = [CalendarSelectView loadCalendara];
    [calendar setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.view addSubview:calendar];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[calendar]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(calendar)]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-64-[calendar(90)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(calendar)]];
}
#pragma mark -跳入备注
- (IBAction)addRecoderButtonClick:(UIButton *)sender {
}
#pragma mark -跳入历史
- (IBAction)historyButtonClick:(UIButton *)sender {
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

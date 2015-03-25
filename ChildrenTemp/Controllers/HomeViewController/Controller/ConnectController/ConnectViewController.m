//
//  ConnectViewController.m
//  ChildrenTemp
//
//  Created by QJ on 15/3/25.
//  Copyright (c) 2015年 QJ. All rights reserved.
//

#import "ConnectViewController.h"
#import "DeviceScanView.h"
@interface ConnectViewController ()
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UIView *middleView;
@property (weak, nonatomic) IBOutlet UIButton *connectButton;
@end

@implementation ConnectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self buildUI];
    DeviceScanView *device = [DeviceScanView loadDeviceScan];
    device.frame = CGRectMake(20, 100, 280, 130);
    [self.view addSubview:device];
        [self.view setBackgroundColor:[UIColor darkGrayColor]];
}
#pragma mark -界面搭建
-(void)buildUI{
    _bottomView.backgroundColor = kcolorWithRGB(138, 102, 95);
    _bottomView.layer.cornerRadius = _bottomView.frame.size.width *0.5;
    _bottomView.layer.masksToBounds = YES;
    
    _middleView.backgroundColor = kcolorWithRGB(111, 80, 74);
    _middleView.layer.cornerRadius = _middleView.frame.size.width *0.5;
    _middleView.layer.masksToBounds = YES;
    
    [_connectButton setBackgroundColor:kcolorWithRGB(220, 213, 188)];
    _connectButton.layer.cornerRadius = _connectButton.frame.size.width *0.5;
    [_connectButton setTitle:@"连接设备" forState:UIControlStateNormal];
    _connectButton.layer.masksToBounds = YES;
    [_connectButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [_connectButton addTarget:self action:@selector(connectLightBule:) forControlEvents:UIControlEventTouchUpInside];
}
#pragma mark -连接蓝牙
-(void)connectLightBule:(UIButton*)connectButton{
    switch (HBM.bleAction) {
        case bleNotConnect:{
            [_connectButton setTitle:@"连接设备中..." forState:UIControlStateNormal];
            [HBM startScanPeripheral:YES doneBlock:^(CBCentralManagerState centralState, BOOL refresh, NSArray *peripheralDicArr) {
                
            }];
        }
            break;
        case bleScanning:{
            [HBM stopScanPeripheral];
            [_connectButton setTitle:@"连接设备" forState:UIControlStateNormal];
        }
            break;
        case bleConnecting:{
            [HBM cancelPeripheralConnectionDoneBlock:^(CBPeripheral *peripheral) {
                
            }];
        }
            break;
        case bleConnected:{
            [HBM cancelPeripheralConnectionDoneBlock:^(CBPeripheral *peripheral) {
                
            }];
        }
            break;
        case bleNotify:{
            [HBM fetchActualTimeDataEnable:NO doneBlock:nil];
        }
            break;
        default:
            break;
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

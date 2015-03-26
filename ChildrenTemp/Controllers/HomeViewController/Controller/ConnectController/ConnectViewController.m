//
//  ConnectViewController.m
//  ChildrenTemp
//
//  Created by QJ on 15/3/25.
//  Copyright (c) 2015年 QJ. All rights reserved.
//

#import "ConnectViewController.h"
#import "DeviceScanView.h"
#import "MainViewController.h"
@interface ConnectViewController ()<deviceDelegate>
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UIView *middleView;
@property (weak, nonatomic) IBOutlet UIButton *connectButton;
@property (strong, nonatomic) NSMutableArray *blueToothArrayM;
@property (strong, nonatomic) DeviceScanView *deviceScan;
@property (weak, nonatomic) UIView *peripheralContainView;
@property (weak, nonatomic) UIView *peripheralAlphaView;
@end

@implementation ConnectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self buildUI];
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
                if (!_blueToothArrayM) {
                    _blueToothArrayM = [NSMutableArray array];
                    [_blueToothArrayM addObjectsFromArray:peripheralDicArr];
                }else{
                    [_blueToothArrayM removeAllObjects];
                    [_blueToothArrayM addObjectsFromArray:peripheralDicArr];
                }
                if (peripheralDicArr.count == 1) {
                    [[self class]cancelPreviousPerformRequestsWithTarget:self selector:@selector(selectedBlueTooth) object:nil];
                    [self performSelector:@selector(selectedBlueTooth) withObject:nil afterDelay:5.0];
                }
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
#pragma mark -搜索到的蓝牙设备
-(void)selectedBlueTooth{
    if (![_blueToothArrayM count]) {//没有搜到蓝牙设备
        return;
    }
    if(!_deviceScan){
        UIWindow *keywindow = [UIApplication sharedApplication].keyWindow;
        UIView *peripheralContainView = [[UIView alloc]initWithFrame:keywindow.bounds];
        [peripheralContainView setBackgroundColor:[UIColor clearColor]];
        _peripheralContainView = peripheralContainView;
        [keywindow addSubview:peripheralContainView];
        
        UIView *peripherlAlphaView = [[UIView alloc]initWithFrame:peripheralContainView.bounds];
        _peripheralAlphaView = peripherlAlphaView;
        [peripherlAlphaView setBackgroundColor:[UIColor blackColor]];
        [peripherlAlphaView setAlpha:0.0];
        [peripheralContainView addSubview:peripherlAlphaView];
        _deviceScan = [DeviceScanView loadDeviceScan];
        [_deviceScan setDelegate:self];
        _deviceScan.center = CGPointMake(peripheralContainView.bounds.size.width*0.5, peripheralContainView.bounds.size.height*0.5);
        if ([_blueToothArrayM count]==1) {
            _deviceScan.bounds = CGRectMake(0, 0, 280, 139.5);
        }else{
            _deviceScan.bounds = CGRectMake(0, 0, 280, 190);
        }
        
        [peripheralContainView addSubview:_deviceScan];
        [_deviceScan refreshDataSource:_blueToothArrayM];
        [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            [peripherlAlphaView setAlpha:0.5];
            [_deviceScan setAlpha:1.0f];
        } completion:^(BOOL finished) {
            
        }];

    }
}
#pragma mark -deviceDelegte
-(void)deviceScanview:(DeviceScanView *)scanview didSelectIndex:(NSInteger)index{
    [self stopScanPeripheral:nil];
    [_connectButton setTitle:@"设备连接中..." forState:UIControlStateNormal];
    [self peripheralState:index];
}
-(void)deviceScanview:(DeviceScanView *)scanview didSelectCancle:(BOOL)cancle{
    if (cancle) {
        [self stopScanPeripheral:nil];
        [_connectButton setTitle:@"连接设备" forState:UIControlStateNormal];
    }
}
- (void)peripheralState:(int)index{
    [HBM connectPeripheral:index doneBlock:^(CBPeripheral *peripheral) {
        if (peripheral) {
            switch (peripheral.state) {
                case CBPeripheralStateDisconnected:{
                }
                    break;
                case CBPeripheralStateConnecting:{
                    
                }
                    break;
                case CBPeripheralStateConnected:{
//                    MainViewController *main = [[MainViewController alloc]initWithNibName:@"MainViewController" bundle:nil];
//                    [self.navigationController pushViewController:main animated:YES];
                    if ([_connectDelegate respondsToSelector:@selector(connectview:pushController:)]) {
                        [_connectDelegate connectview:self pushController:YES];
                        
                    }
                    
                }
                    break;
                default:
                    break;
            }
        }else{
        }
    }];
}

- (void)stopScanPeripheral:(id)sender{
    if (_peripheralContainView) {
        [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            [_peripheralAlphaView setAlpha:0.0f];
            [_deviceScan setAlpha:0.0f];
        } completion:^(BOOL finished) {
            [_deviceScan removeFromSuperview];
            _deviceScan = nil;
            [_peripheralContainView removeFromSuperview];
            _peripheralContainView = nil;
            [HBM stopScanPeripheral];
        }];
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

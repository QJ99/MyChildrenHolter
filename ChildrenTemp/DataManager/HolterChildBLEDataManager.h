//
//  HolterBLEDataManager.h
//  HolterBLEDemo
//
//  Created by David on 9/12/14.
//  Copyright (c) 2014 David. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>

#define hDevice  @"hDevice"
#define hName    @"hName"

typedef enum {
    bleNotConnect = 0,
    bleScanning,
    bleConnecting,
    bleConnected,
    bleNotify,
    bleNotSupport
}BLEAction;

typedef void(^CentralStateBlock)(CBCentralManagerState centralState, BOOL refresh, NSArray *peripheralDicArr);
typedef void(^PeripheralBlock)(CBPeripheral *peripheral);
typedef void(^ActualTimeDataBlock)(NSDictionary *actualTimeData);
typedef void(^currentBatty)(float battyPersent);
//历史值
typedef void(^histoyTempAndEnHBlock)(NSArray *historyData);
typedef void(^DeviceNameBlock)(NSString *name);
//数据长度
typedef void (^DataLength)(int length);
typedef void (^checktimeDone)();

@interface HolterChildBLEDataManager : NSObject
@property (readonly, nonatomic, strong) NSMutableDictionary *deviceInfoDic;
@property (readonly, nonatomic, assign) BLEAction bleAction;
+ (id)sharedInstance;
- (void)startScanPeripheral:(BOOL)scan doneBlock:(CentralStateBlock)centralStateBlock;
- (void)stopScanPeripheral;

//Bug => select peripheral when peripheral is poweroff
- (void)connectPeripheral:(int)peripheralIndex doneBlock:(PeripheralBlock)doneBlock;

- (void)cancelPeripheralConnectionDoneBlock:(PeripheralBlock)doneBlock;

- (void)fetchActualTimeDataEnable:(BOOL)enable doneBlock:(ActualTimeDataBlock)doneBlock;
//获取历史数据
- (void)fetchHistoryTempAndEnHBlock:(histoyTempAndEnHBlock)historyTempDataBlock;

- (void)writeDeviceName:(NSString *)name doneBlock:(DeviceNameBlock)doneBlock;
//时间校验
- (void)checkTime:(int)timeInterval;
- (void)checkTimeBlock:(int)timeInterval doneBlock:(checktimeDone)done;
- (void)connectPeripheral:(CBPeripheral*)perihperal;
//计算历史数据的长度
- (void)calculateDataLength:(DataLength)length;
//读取🔋
- (void)currentBatty:(currentBatty)batty;
@end

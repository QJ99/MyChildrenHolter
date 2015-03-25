//
//  HolterBLEDataManager.m
//  HolterBLEDemo
//
//  Created by David on 9/12/14.
//  Copyright (c) 2014 David. All rights reserved.
//

#import "HolterChildBLEDataManager.h"

@interface HolterChildBLEDataManager()
@property (assign, nonatomic) BOOL bleStatus; //BLE Status
@property (strong, nonatomic) CBCentralManager *centralManager;
@property (strong, nonatomic) CBPeripheral *curPeripheral;
/**
 *  Arr -> Dic key hDevice : hName:
 *  key: hDevice value:peripheral
 *  key: hName   value:peripheral.name
 */
@property (nonatomic, strong) NSMutableArray *peripheralDicArr;
@property (nonatomic, copy) CentralStateBlock centralStateBlock;
@property (nonatomic, copy) PeripheralBlock peripheralDoneBlock;
@property (nonatomic, copy) DeviceNameBlock deviceNameDoneBlock;

@property (nonatomic, strong) NSMutableDictionary *deviceInfoDic;
@property (nonatomic, copy) ActualTimeDataBlock actualTimeDataBlock;
@property (nonatomic, copy) histoyTempAndEnHBlock historyTempAndEnHBlock;
@property (nonatomic, copy) DataLength dataLength;
@property (nonatomic, assign) BLEAction bleAction;
@property (copy, nonatomic) currentBatty calculateBatty;
@property (copy, nonatomic) checktimeDone timeDone;

@property (nonatomic, assign) int timeInterval;
@property (nonatomic, assign) int writeData;
@property (nonatomic, assign) int maxTime;
//@property (nonatomic, strong) NSData *tempTimeData;
//@property (nonatomic, strong) NSData *userDefinedNameData;
@end

@implementation HolterChildBLEDataManager

+ (id)sharedInstance{
    
    static HolterChildBLEDataManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[HolterChildBLEDataManager alloc] init];
        manager.bleStatus = NO;
    });
    //    manager.writeData = 0;
    return manager;
}

- (CBUUID *)servicesUUID{
    Byte byte[] = {255, 240};
    NSData *serviceData = [[NSData alloc] initWithBytes:byte length:2];
    return [CBUUID UUIDWithData:serviceData];
}

- (CBUUID *)deviceInfoUUID{
    Byte byte[] = {24, 10};
    NSData *deviceData = [[NSData alloc] initWithBytes:byte length:2];
    return [CBUUID UUIDWithData:deviceData];
}
- (void)startScanPeripheral:(BOOL)scan doneBlock:(CentralStateBlock)centralStateBlock {
    if (!scan) {
        if (centralStateBlock) {
            _centralStateBlock = centralStateBlock;
        }
        return;
    }
    if (!_peripheralDicArr) {
        _peripheralDicArr = [[NSMutableArray alloc] init];
    }
    [_peripheralDicArr removeAllObjects];
    
    if (centralStateBlock) {
        _centralStateBlock = centralStateBlock;
    }
    if (_centralManager && _centralManager.state != CBCentralManagerStatePoweredOn) {
        _bleAction = bleNotConnect;
        _centralStateBlock(CBCentralManagerStatePoweredOff, NO, nil);
        return;
    }
    
    _bleAction = bleScanning;
    if (!_centralManager) {
        [HBM addObserver:self forKeyPath:@"bleStatus" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:NULL];
        _centralManager = [[CBCentralManager alloc] initWithDelegate:(id<CBCentralManagerDelegate>)HBM queue:nil];
    }else{
        if (_centralStateBlock) {
            _centralStateBlock(_centralManager.state, NO, _peripheralDicArr);
        }
        if (_centralManager.state == CBCentralManagerStatePoweredOn) {
            MyLog(@"scanForPeripheralsWithServices");
            [_centralManager scanForPeripheralsWithServices:@[[self servicesUUID]]
                                                    options:@{CBCentralManagerScanOptionAllowDuplicatesKey : @YES}];
        }
    }
    
    if (_curPeripheral) {
        [_curPeripheral setDelegate:nil];
        [_centralManager cancelPeripheralConnection:_curPeripheral];
        _curPeripheral = nil;
        _peripheralDoneBlock = nil;
    }
}

- (void)stopScanPeripheral{
    _bleAction = bleNotConnect;
    //    _centralStateBlock = nil;  //===================
    if (_centralManager && _centralManager.state == CBCentralManagerStatePoweredOn) {
        [_centralManager stopScan];
    }
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    if([keyPath isEqualToString:@"bleStatus"]){
        if (!_bleStatus) {
            _bleAction = bleNotConnect;
//            _deviceInfoDic = nil;
        }
        if (_centralStateBlock) {
            _centralStateBlock(_centralManager.state, NO, _peripheralDicArr);
        }
        if (_centralManager.state == CBCentralManagerStatePoweredOn) {
            [_centralManager scanForPeripheralsWithServices:@[[self servicesUUID]]
                                                    options:@{CBCentralManagerScanOptionAllowDuplicatesKey : @YES}];
        }else{
            [self stopScanPeripheral];
        }
    }
}

- (void)connectPeripheral:(int)peripheralIndex doneBlock:(PeripheralBlock)doneBlock{
    if (peripheralIndex == -1) {
        _peripheralDoneBlock = doneBlock;
        return;
    }
    _bleAction = bleConnecting;
    _peripheralDoneBlock = doneBlock;
    if (!_deviceInfoDic) {
        _deviceInfoDic = [NSMutableDictionary dictionaryWithDictionary:@{@"System ID"                    : @"",
                                                                         @"Model Number String"          : @"",
                                                                         @"Serial Number String"         : @"",
                                                                         @"Firmware Revision String"     : @"",
                                                                         @"Hardware Revision String"     : @"",
                                                                         @"Software Revision String"     : @"",
                                                                         @"Manufacturer Name String"     : @"",
                                                                         @"IEEE Regulatory Certification": @"",
                                                                         @"PnP ID"                       : @"",
                                                                         @"hName"                        : @"",
                                                                         @"battery"                      : @""}];
    }
    if ([_peripheralDicArr count]) {
        [_deviceInfoDic setObject:_peripheralDicArr[peripheralIndex][hName] forKey:@"hName"];
        _curPeripheral = _peripheralDicArr[peripheralIndex][hDevice];
        [_curPeripheral setDelegate:(id<CBPeripheralDelegate>)HBM];
        MyLog(@"%@", _curPeripheral);
        [_centralManager connectPeripheral:_curPeripheral options:nil];
        [self performSelector:@selector(connectingSelectPeripheralLost) withObject:nil afterDelay:10];
    }
    
}

- (void)cancelPeripheralConnectionDoneBlock:(PeripheralBlock)doneBlock{
    MyLog(@"cancelPeripheralConnection:(CBPeripheral *)peripheral doneBlock:(PeripheralBlock)doneBlock");
    _bleAction = bleNotConnect;
    _peripheralDoneBlock = doneBlock;
    if (_curPeripheral) {
        [_centralManager cancelPeripheralConnection:_curPeripheral];
    }
}
- (void)fetchDeviceInformation{
    [self readCharacteristic:[self deviceInfoUUID] cUUID:nil];
}
#pragma mark -获取实时环境温湿度
- (void)fetchActualTimeDataEnable:(BOOL)enable doneBlock:(ActualTimeDataBlock)doneBlock{
    if (doneBlock) {
        _actualTimeDataBlock = doneBlock;
    }
    if ((enable && doneBlock) || (!enable && !doneBlock)) {
        [self fetchActualTimeDataEnable:enable];
    }
}
#pragma mark -获取历史值
-(void)fetchHistoryTempAndEnHBlock:(histoyTempAndEnHBlock)historyTempDataBlock{
    _writeData = 0;
    _historyTempAndEnHBlock = historyTempDataBlock;
    [self historyTempTimeDataWrite];
}
- (void)fetchActualTimeDataEnable:(BOOL)enable{
    [self notifyCharacteristic:[self servicesUUID] cUUID:[CBUUID UUIDWithString:@"FFF4"] enable:enable];
}
#pragma mark -校验时间
-(void)checkTimeBlock:(int)timeInterval doneBlock:(checktimeDone)done{
    _timeDone = done;
    Byte finalByte[4];
    
    finalByte[0]=timeInterval&0xff;
    finalByte[1]=(timeInterval>>8)&0xff;
    finalByte[2]=(timeInterval>>16)&0xff;
    finalByte[3]=(timeInterval>>24)&0xff;
    NSData *tempTimeData = [[NSData alloc] initWithBytes:finalByte length:4];
    CBUUID *sUUID = [self servicesUUID];
    CBUUID *cUUID = [CBUUID UUIDWithString:@"FFF3"];
    [self writeCharacteristic:sUUID cUUID:cUUID data:tempTimeData];
}
-(void)checkTime:(int)timeInterval{
    Byte finalByte[4];
    finalByte[0]=timeInterval&0xff;
    finalByte[1]=(timeInterval>>8)&0xff;
    finalByte[2]=(timeInterval>>16)&0xff;
    finalByte[3]=(timeInterval>>24)&0xff;
    NSData *tempTimeData = [[NSData alloc] initWithBytes:finalByte length:4];
    CBUUID *sUUID = [self servicesUUID];
    CBUUID *cUUID = [CBUUID UUIDWithString:@"FFF3"];
    [self writeCharacteristic:sUUID cUUID:cUUID data:tempTimeData];
}
#pragma mark -测量历史数据长度
-(void)calculateDataLength:(DataLength)length{
    _dataLength = length;
    _writeData = 0xfffe;
    
}
- (void)readCharacteristic:(CBUUID *)sUUID cUUID:(CBUUID *)cUUID{
    if (_curPeripheral && sUUID) {
        for ( CBService *service in _curPeripheral.services ) {
            if([service.UUID isEqual:sUUID]) {
                for ( CBCharacteristic *characteristic in service.characteristics ) {
                    if (cUUID) {
                        if ([characteristic.UUID isEqual:cUUID]) {
                            [_curPeripheral readValueForCharacteristic:characteristic];
                        }
                    }else{
                        [_curPeripheral readValueForCharacteristic:characteristic];
                    }
                }
            }
        }
    }
}


- (void)writeDeviceName:(NSString *)name doneBlock:(DeviceNameBlock)doneBlock{
    if (name && doneBlock) {
        _deviceNameDoneBlock = doneBlock;
        
        NSData *data = [name dataUsingEncoding: NSUTF8StringEncoding];
        
        Byte *byte = (Byte *)[data bytes];
        
        for(int i=0;i<[data length];i++)
            printf("byte[%d] = %d\n", i, byte[i]);
        
        Byte finalByte[20];
        for (int i = 0; i < 20; i++) {
            if (i < [data length]) {
                finalByte[i] = byte[i];
            }else{
                finalByte[i] = 0;
            }
        }
        NSData * userDefinedNameData = [[NSData alloc] initWithBytes:finalByte length:20];
        CBUUID *cUUID = [CBUUID UUIDWithString:@"FFF1"];
        [self writeCharacteristic:[self servicesUUID] cUUID:cUUID data:userDefinedNameData];
    }
}

- (void)writeCharacteristic:(CBUUID *)sUUID cUUID:(CBUUID *)cUUID data:(NSData *)writeDate {
    for ( CBService *service in _curPeripheral.services ) {
        if([service.UUID isEqual:sUUID]) {
            for ( CBCharacteristic *characteristic in service.characteristics ) {
                if ([characteristic.UUID isEqual:cUUID]) {
                    [_curPeripheral writeValue:writeDate forCharacteristic:characteristic type:CBCharacteristicWriteWithResponse];
                }
            }
        }
    }
}

- (void)notifyCharacteristic:(CBUUID *)sUUID cUUID:(CBUUID *)cUUID enable:(BOOL)enable{
    if (_curPeripheral && sUUID) {
        for ( CBService *service in _curPeripheral.services ) {
            if([service.UUID isEqual:sUUID]) {
                for ( CBCharacteristic *characteristic in service.characteristics ) {
                    if ([characteristic.UUID isEqual:cUUID]) {
                        if (enable && ![characteristic isNotifying]) {
                            [_curPeripheral setNotifyValue:enable forCharacteristic:characteristic];
                        }else{
                            [_curPeripheral setNotifyValue:enable forCharacteristic:characteristic];
                        }
                    }
                }
            }
        }
    }
}
#pragma mark -读取历史值
- (void)historyTempTimeDataWrite{
    
    if (_writeData == 0xfffe) {
        int interval1 = 0xfffe;
        Byte finalByte1[2];
        finalByte1[1] = (UInt8)interval1&0xff;
        finalByte1[0] = (UInt8)(interval1>>8)&0xff;
        
        NSData *tempTimeData1 = [[NSData alloc] initWithBytes:finalByte1 length:2];
        CBUUID *sUUID1 = [self servicesUUID];
        CBUUID *cUUID1 = [CBUUID UUIDWithString:@"FFF5"];
        [self writeCharacteristic:sUUID1 cUUID:cUUID1 data:tempTimeData1];
        
    }else{
        int interval = _writeData;
        Byte finalByte[2];
        finalByte[1]=(UInt8)interval&0xff;
        finalByte[0]=(UInt8)(interval>>8)&0XFF;
        NSData *tempTimeData = [[NSData alloc] initWithBytes:finalByte length:2];
        CBUUID *sUUID = [self servicesUUID];
        CBUUID *cUUID = [CBUUID UUIDWithString:@"FFF5"];
        [self writeCharacteristic:sUUID cUUID:cUUID data:tempTimeData];
    }
}
#pragma mark -读取🔋
-(void)currentBatty:(currentBatty)batty{
    _calculateBatty = batty;
    CBUUID *services = [self servicesUUID];
    CBUUID *cUUID = [CBUUID UUIDWithString:@"FFF7"];
    for ( CBService *service in _curPeripheral.services ) {
        if([service.UUID isEqual:services]) {
            for ( CBCharacteristic *characteristic in service.characteristics ) {
                if ([characteristic.UUID isEqual:cUUID]) {
                    [_curPeripheral readValueForCharacteristic:characteristic];
                }
            }
        }
    }
}
- (void)historyTempDataRead{
    CBUUID *services = [self servicesUUID];
    CBUUID *cUUID = [CBUUID UUIDWithString:@"FFF2"];
    for ( CBService *service in _curPeripheral.services ) {
        if([service.UUID isEqual:services]) {
            for ( CBCharacteristic *characteristic in service.characteristics ) {
                if ([characteristic.UUID isEqual:cUUID]) {
                    [_curPeripheral readValueForCharacteristic:characteristic];
                }
            }
        }
    }
}

#pragma mark - CBCentralManagerDelegate
- (void)centralManagerDidUpdateState:(CBCentralManager *)central{
    switch (central.state) {
        case 0:{
            MyLog(@"CBCentralManagerStateUnknown");
            _bleAction = bleNotSupport;
            [HBM setBleStatus:NO];
        }
            break;
        case 1:{
            MyLog(@"CBCentralManagerStateResetting");
            _bleAction = bleNotSupport;
            [HBM setBleStatus:NO];
        }
            break;
        case 2:{
            MyLog(@"CBCentralManagerStateUnsupported");
            _bleAction = bleNotSupport;
            [HBM setBleStatus:NO];
        }
            break;
        case 3:{
            MyLog(@"CBCentralManagerStateUnauthorized");
            _bleAction = bleNotSupport;
            [HBM setBleStatus:NO];
        }
            break;
        case 4:{
            MyLog(@"CBCentralManagerStatePoweredOff");
            _bleAction = bleNotSupport;
            if (_peripheralDoneBlock) {
                _peripheralDoneBlock(nil);
            }
            [HBM setBleStatus:NO];
        }
            break;
        case 5:{
            MyLog(@"CBCentralManagerStatePoweredOn");
            if (_bleAction == bleNotSupport) {
                _bleAction = bleNotConnect;
            }
            [HBM setBleStatus:YES];
        }
            break;
            
        default:
            break;
    }
}

- (void)centralManager:(CBCentralManager *)central willRestoreState:(NSDictionary *)dict{
    MyLog(@"willRestoreState:%@", dict);
}

- (void)centralManager:(CBCentralManager *)central didRetrievePeripherals:(NSArray *)peripherals{
    MyLog(@"didRetrievePeripherals:%@", peripherals);
}

- (void)centralManager:(CBCentralManager *)central didRetrieveConnectedPeripherals:(NSArray *)peripherals{
    MyLog(@"didRetrieveConnectedPeripherals:%@", peripherals);
}

- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI{
    MyLog(@"didDiscoverPeripheral--peripheral:%@ \n advertisementData%@ \n RSSI:%@ ", peripheral, advertisementData, RSSI);
    __block BOOL peripheralCheck = NO;
    __block BOOL nameCheck = NO;
    
    NSString *peripheralName = nil;
    if ([[advertisementData allKeys] containsObject:@"kCBAdvDataLocalName"]) {
        peripheralName = advertisementData[@"kCBAdvDataLocalName"];
    }else if (peripheral.name && [peripheral.name class] == [NSString class]){
        peripheralName = peripheral.name;
    }
    if (!peripheralName) {
        return;
    }
    
    NSString *uuid = nil;
    if ([peripheral respondsToSelector:@selector(identifier)]) {
        uuid = [peripheral.identifier UUIDString];
    }else{
        uuid = (NSString *)CFBridgingRelease(CFUUIDCreateString(NULL,peripheral.UUID));
    }
    
    [_peripheralDicArr enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        CBPeripheral *tmpPeripheral = (CBPeripheral *)obj[hDevice];
        NSString *tmpUUID = nil;
        if ([peripheral respondsToSelector:@selector(identifier)]) {
            tmpUUID = [tmpPeripheral.identifier UUIDString];
        }else{
            tmpUUID = (NSString *)CFBridgingRelease(CFUUIDCreateString(NULL,tmpPeripheral.UUID));
        }
        if ([tmpUUID isEqualToString:uuid]) {
            NSString *tmpName = obj[hName];
            if (![tmpName isEqualToString:peripheralName]) {
                obj[hName] = peripheralName;
                nameCheck = YES;
            }
            peripheralCheck = YES;
            *stop = YES;
        }
    }];
    
    if (!peripheralCheck || nameCheck) {
        if (!peripheralCheck) {
            NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObjectsAndKeys:peripheral, hDevice, peripheralName, hName, nil];
            [_peripheralDicArr addObject:dic];
        }
        if (_centralStateBlock) {
            _centralStateBlock(_centralManager.state, YES, _peripheralDicArr);
        }
    }
}


- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral{
    MyLog(@"didConnectPeripheral:%@", peripheral);
    _bleAction = bleConnected;
    if (_curPeripheral) {
        [_curPeripheral discoverServices:nil];
    }
    if (_peripheralDoneBlock) {
        _peripheralDoneBlock(peripheral);
    }
    [[self class] cancelPreviousPerformRequestsWithTarget:self selector:@selector(connectingSelectPeripheralLost) object:nil];
}

- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error{
    if (error) {
        MyLog(@"didFailToConnectPeripheral:%@ \n %@  \n %@", peripheral, [error localizedDescription], [error localizedDescription]);
    }else{
        MyLog(@"didFailToConnectPeripheral:%@ \n %@", peripheral, [error localizedDescription]);
    }
    _bleAction = bleNotConnect;
    if (_peripheralDoneBlock) {
        _peripheralDoneBlock(peripheral);
    }
    _curPeripheral = nil;
    _peripheralDoneBlock = nil;
//    _deviceInfoDic = nil;
    [[self class] cancelPreviousPerformRequestsWithTarget:self selector:@selector(connectingSelectPeripheralLost) object:nil];
}

- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error{
    MyLog(@"didDisconnectPeripheral:%@ \n %@", peripheral, [error localizedDescription]);
    if (error) {
        MyLog(@"didDisconnectPeripheral:%@ \n %@", peripheral, [error localizedDescription]);
    }else{
        MyLog(@"didDisconnectPeripheral:%@ \n", peripheral);
    }
    _bleAction = bleNotConnect;
    if (_peripheralDoneBlock) {
        _peripheralDoneBlock(peripheral);
    }
    _curPeripheral = nil;
    _peripheralDoneBlock = nil;
//    _deviceInfoDic = nil;
    [[self class] cancelPreviousPerformRequestsWithTarget:self selector:@selector(connectingSelectPeripheralLost) object:nil];
}

- (void)connectingSelectPeripheralLost{
    _bleAction = bleNotConnect;
    if (_peripheralDoneBlock) {
        _peripheralDoneBlock(nil);
    }
    if (_curPeripheral) {
        [_curPeripheral setDelegate:nil];
        [_centralManager cancelPeripheralConnection:_curPeripheral];
        _curPeripheral = nil;
        _peripheralDoneBlock = nil;
    }
//    _deviceInfoDic = nil;
}

#pragma mark - CBPeripheralDelegate
- (void)peripheralDidUpdateName:(CBPeripheral *)peripheral{
    MyLog(@"peripheralDidUpdateName:%@", peripheral);
}

- (void)peripheralDidInvalidateServices:(CBPeripheral *)peripheral{
    MyLog(@"peripheralDidInvalidateServices:%@", peripheral);
}

- (void)peripheral:(CBPeripheral *)peripheral didModifyServices:(NSArray *)invalidatedServices{
    MyLog(@"didModifyServices:%@ \t %@", peripheral, invalidatedServices);
}

- (void)peripheralDidUpdateRSSI:(CBPeripheral *)peripheral error:(NSError *)error{
    if (error) {
        MyLog(@"%@", [error localizedDescription]);
    }
    MyLog(@"peripheralDidUpdateRSSI:%@", peripheral);
}

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error{
    if (error) {
        MyLog(@"didDiscoverServices:%@", [error localizedDescription]);
    }else{
        MyLog(@"didDiscoverServices:%@", peripheral);
        [peripheral.services enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            CBService *service = (CBService *)obj;
            MyLog(@"service:%@", service);
            MyLog(@"%@", service.UUID.data);
            MyLog(@"%@", service.characteristics);
            Byte *testByte = (Byte *)[service.UUID.data bytes];
            for(int i=0;i<[service.UUID.data length];i++)
                printf("testByte = %d\n",testByte[i]);
            [peripheral discoverCharacteristics:nil forService:service];
        }];
    }
}

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverIncludedServicesForService:(CBService *)service error:(NSError *)error{
    if (error) {
        MyLog(@"didDiscoverIncludedServicesForService::%@", [error localizedDescription]);
    }else{
        MyLog(@"didDiscoverIncludedServicesForService:%@ \t %@", peripheral, service);
    }
}

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error{
    if (error) {
        MyLog(@"%@", [error localizedDescription]);
    }else{
        MyLog(@"didDiscoverCharacteristicsForService:%@ \t %@  %@", peripheral, service, service.characteristics);
        if ([service.UUID isEqual:[self servicesUUID]]) {
            [service.characteristics enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                if ([obj isKindOfClass:[CBCharacteristic class]]) {
                    CBCharacteristic *characteristic = (CBCharacteristic *)obj;
                    NSString *characteristicValue = [[NSString alloc] initWithData:characteristic.value encoding:NSUTF8StringEncoding];
                    MyLog(@"didDiscoverCharacteristicsForService:%@ \t %@   characteristicValue:%@", characteristic, characteristic.value, characteristicValue);
                    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"FFF4"]] && _actualTimeDataBlock) {
                        [_curPeripheral setNotifyValue:YES forCharacteristic:characteristic];
                    } else if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"FFF5"]]) {
                        [self historyTempTimeDataWrite];
                    }
                    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"FFF7"]]) {
                        [_curPeripheral setNotifyValue:YES forCharacteristic:characteristic];
                    }
                }
            }];
        }else if ([service.UUID isEqual:[self deviceInfoUUID]]){
            [self fetchDeviceInformation];
        }
    }
}
#pragma mark -连接设备
- (void)connectPeripheral:(CBPeripheral*)perihperal{
    
    [_centralManager connectPeripheral:perihperal options:nil];
}
- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error{
    if (error) {
        MyLog(@"didUpdateValueForCharacteristic:%@", [error localizedDescription]);
    }else{
        NSString *uuid = [NSString stringWithFormat:@"%@", characteristic.UUID];
        NSString *characteristicValue = [[NSString alloc] initWithData:characteristic.value encoding:NSUTF8StringEncoding];
        MyLog(@"didUpdateValueForCharacteristic:%@   %@ \t %@ \t %@   characteristicValue:%@", uuid, peripheral, characteristic, characteristic.value, characteristicValue);
        
        if (_deviceInfoDic && [[_deviceInfoDic allKeys] containsObject:uuid]) {
            if (characteristicValue) {
                MyLog(@"DeviceInformation: %@====%@", uuid, characteristicValue);
                [_deviceInfoDic setObject:characteristicValue forKey:uuid];
            }else{
                Byte *byte = (Byte *)[characteristic.value bytes];
                NSMutableString *string = [[NSMutableString alloc] init];
                for(int i=0;i<[characteristic.value length];i++){
                    MyLog(@"testByte = %d\n",byte[i]);
                    [string appendFormat:@"%d.",byte[i]];
                }
                [_deviceInfoDic setObject:string forKey:uuid];
                MyLog(@"DeviceInformation: %@====%@", uuid, string);
            }
        }else if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"FFF2"]]){
            if ([characteristic.value length] == 16) {
                NSMutableString *string = [[NSMutableString alloc] init];
                Byte *byte = (Byte *)[characteristic.value bytes];
                for (int i = 0; i < [characteristic.value length]; i++) {
                    [string appendFormat:@"%d＝＝", byte[i]];
                    
                }
                MyLog(@"FFF2----Read: Byte:%@", string);
                //数据长度
                MyLog(@"-=-=-=-=-=-=-=-=-=_writeData:%d ", _writeData);
                if (_writeData == 0xfffe) {
                    _writeData = 0;
                    _maxTime = 0;
                    UInt16 temLenth=0;
                    temLenth = byte[0] + (byte[1] << 8);
                    temLenth = (temLenth >> 3);
                    if (temLenth % 2 == 1) {
                        MyLog(@"-=-=-=-=-=-=");
                    }
                    MyLog(@"-=-=-=-=-=-=-=-=-=_writeData temLenth:%d ", temLenth);
                    
                    _dataLength(temLenth);
                }else{
                    double interval1 = (byte[3] << 24) + (byte[2] << 16) + (byte[1] << 8)+ byte[0];
                    float t1 = (byte[4] + (byte[5] << 8));
                    
                    float tw1 =  0.009876 * ((t1) * 9.40563e-5 - 1) * t1 + 42.39;
                    float rawH = (byte[6] + (byte[7] << 8)) & (~0x0003);
                    float enH1 =  -6.0 + 125.0 / 65536.0 * (float)rawH;
                    
                    double interval2 = (byte[11] << 24)+ (byte[10] << 16)+ (byte[9] << 8) + byte[8];
                    float t2 = (byte[12] + (byte[13] << 8));
                    float tw2 =  0.009876 * ((t2) * 9.40563e-5-1) * t2 + 42.39;
                    
                    float rawH1 = (byte[14] + (byte[15] <<8)) & (~0x0003);
                    float enH2 = -6.0 + 125.0/65536.0 * (float)rawH1;
                    
                    
                    
                    NSDateFormatter *fmt = [[NSDateFormatter alloc]init];
                    [fmt setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                    NSString *time = @"2000-01-01 00:00:00";
                    NSDate *date = [fmt dateFromString:time];
                    
                    MyLog(@"-=-=-=-=-=-=-=-=-=_writeData:%d %@ =========  %@", _writeData, [fmt stringFromDate:[date dateByAddingTimeInterval:interval1]], [fmt stringFromDate:[date dateByAddingTimeInterval:interval2]]);
                
                    if (_maxTime < interval1) {
                        _maxTime = interval2;
                        if (interval1 < interval2 &&  _writeData != 65535 && _writeData + 2 != _writeData) {
                          
                            
                            if (_historyTempAndEnHBlock) {
                                _historyTempAndEnHBlock(@[@{@"interval": [NSNumber numberWithDouble:interval1],
                                                            @"tw":       [NSNumber numberWithFloat:tw1],
                                                            @"enH":      [NSNumber numberWithFloat:enH1]
                                                            },
                                                          @{@"interval": [NSNumber numberWithDouble:interval2],
                                                            @"tw":       [NSNumber numberWithFloat:tw2],
                                                            @"enH":      [NSNumber numberWithFloat:enH2],
                                      
                                                            }]);
                            }
                            _writeData = _writeData + 2;
                            MyLog(@"-=-=-=-=-=-=-=-=-=_writeData:%d  interval1 < interval2", _writeData);
                            [self historyTempTimeDataWrite];
                            
                        } else if (interval1 >= interval2) {
                            _writeData = 65535;//oxffff
                            MyLog(@"-=-=-=-=-=-=-=-=-=_writeData:%d  interval1 >= interval2 ", _writeData);
                            [self historyTempTimeDataWrite];

                            if (_historyTempAndEnHBlock) {
                                _historyTempAndEnHBlock(@[@{@"interval": [NSNumber numberWithDouble:interval1],
                                                            @"tw":       [NSNumber numberWithFloat:tw1],
                                                            @"enH":      [NSNumber numberWithFloat:enH1]
                                                            }]);
                            }
                        }
                    }else {
                        _writeData = 65535;//oxffff
                        MyLog(@"-=-=-=-=-=-=-=-=-=_writeData:%d  historyTempTimeDataWrite", _writeData);
                        [self historyTempTimeDataWrite];
                    }
                }
            }
        }else if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"FFF4"]]){
            MyLog(@"FFF4");

            if ([characteristic.value length] == 10) {
                Byte *byte = (Byte *)[characteristic.value bytes];
                NSMutableString *string = [[NSMutableString alloc] init];
                for(int i=0;i<[characteristic.value length];i++){
                    [string appendFormat:@"testByte[%d] = %d\n",i, byte[i]];
                                        printf("testByte[%d] = %d\n",i, byte[i]);
                }
                double time1 = byte[0]+(byte[1]<<8)+(byte[2]<<16)+(byte[3]<<24);
                NSLog(@"&&&&&&&&&&&&&&&%f-----------",time1);
                 NSLog(@"--------------%@-----------",string);
                float t1 =  byte[4] + (byte[5] << 8);
                float tw =  0.009876*((t1)*9.40563e-5-1)*t1+42.39;
                
                int tmpEnH = byte[6] + (byte[7] << 8);
                tmpEnH &= ~0x0003;
                float enH =  -6.0 + 125.0/65536.0 * (float)tmpEnH;
                
                int tmpEnT = byte[8] + (byte[9] << 8);
                tmpEnT &= ~0x0003;
                float enT = -46.85 + 175.72/65536.0 *(float)tmpEnT;
                float battery = 0;
                
                
                if (_actualTimeDataBlock) {
                    _actualTimeDataBlock(@{@"interval": [NSNumber numberWithInt:time1],
                                           @"tw":       [NSNumber numberWithFloat:tw],
                                           @"enH":      [NSNumber numberWithFloat:enH],
                                           @"enT":      [NSNumber numberWithFloat:enT],
                                           @"battery":  [NSNumber numberWithFloat:battery]});
                }
                
                [_deviceInfoDic setObject:[NSNumber numberWithFloat:battery] forKey:@"battery"];
                
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                NSDate *thunsand = [formatter dateFromString:@"2000-1-1 00:00:00"];
                NSDate *time = [thunsand dateByAddingTimeInterval:time1];
                NSString *dataTime = [NSString stringWithFormat:@"当前样点时钟:%@", [formatter stringFromDate:time]];
                NSString *batteryString = [NSString stringWithFormat:@"电池电量:%.2f%%", battery];
                NSString *temperature = [NSString stringWithFormat:@"体温温度:%.2f℃", tw];
                NSString *environmentHumidity = [NSString stringWithFormat:@"环境湿度:%.2f%%", enH];
                NSString *environmentTemperature = [NSString stringWithFormat:@"环境温度:%.2f℃", enT];
                MyLog(@"FFF4----Read: %@\n%@\n%@\n%@\n%@\n", dataTime, batteryString, temperature, environmentHumidity, environmentTemperature);
            }
            
        }else if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"FFF7"]]){
            if ([characteristic.value length] == 2) {
                Byte *byte = (Byte *)[characteristic.value bytes];
                float t1 =  (byte[0]<<8) + byte[1];
                if (_calculateBatty) {
                    float t2 = (((((float)t1)*0.001774)-2.6)*500.0);
                    _calculateBatty(t2);
                }
                NSMutableString *string = [[NSMutableString alloc] init];
                for(int i=0;i<[characteristic.value length];i++){
                    [string appendFormat:@"testByteFFF7[%d] = %d\n",i, byte[i]];
                }
            }
        }
        
    }
}

- (void)peripheral:(CBPeripheral *)peripheral didWriteValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error{
    if (error) {
        MyLog(@"didWriteValueForCharacteristic:%@", [error localizedDescription]);
        if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"FFF5"]]) {
            [self historyTempTimeDataWrite];
        } else if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"FFF1"]]) {
            if (_deviceNameDoneBlock) {
                _deviceNameDoneBlock(nil);
            }
        }
    }else{
        NSString *uuid = [NSString stringWithFormat:@"%@", characteristic.UUID];
        NSString *characteristicValue = [[NSString alloc] initWithData:characteristic.value encoding:NSUTF8StringEncoding];
        MyLog(@"didWriteValueForCharacteristic:%@   %@ \t %@ \t %@   characteristicValue:%@", uuid, peripheral, characteristic, characteristic.value, characteristicValue);
        if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"FFF5"]]) {
            if(_writeData != 65535){//历史值读取完成
                [self historyTempDataRead];
                
            }
            
        } else if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"FFF1"]]) {
            if (_deviceNameDoneBlock) {
                _deviceNameDoneBlock(@"success");
            }
        }
      
    }
    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"FFF3"]]) {
        if (_timeDone) {
            _timeDone();
        }
        
    }
}
- (void)peripheral:(CBPeripheral *)peripheral didUpdateNotificationStateForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error{
   MyLog(@"characteristic:  %@", characteristic);
    if (error) {
        MyLog(@"didUpdateNotificationStateForCharacteristic:%@", [error localizedDescription]);
    }else{
        NSString *uuid = [NSString stringWithFormat:@"%@", characteristic.UUID];
        NSString *characteristicValue = [[NSString alloc] initWithData:characteristic.value encoding:NSUTF8StringEncoding];
        MyLog(@"didUpdateNotificationStateForCharacteristic:%@   %@ \t %@ \t %@   characteristicValue:%@  isNotifying:%d", uuid, peripheral, characteristic, characteristic.value, characteristicValue, [characteristic isNotifying]);
        if ([characteristic isNotifying]) {
            _bleAction = bleNotify;
        }else{
            _bleAction = bleConnected;
        }
    }
}



@end

//
//  ApplicationManage.m
//  DemoTest
//
//  Created by lixutao on 2019/5/29.
//  Copyright © 2019年 lixutao. All rights reserved.
//

#import "ApplicationManage.h"

@implementation ApplicationManage

+ (void)initVungleSDK{
//    5cda9dc16f69b90011095665 5cee01d0a57f7f00182f1c02
    NSString* appID = @"5cda9dc16f69b90011095665";
    
    VungleSDK *sdk = [VungleSDK sharedSDK];
    // start vungle publisher library
    [sdk startWithAppId:appID error:nil];
}

@end

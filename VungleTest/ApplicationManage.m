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
//    58fe200484fbd5b9670000e3
    NSString* appID = @"58fe200484fbd5b9670000e3";
    
    VungleSDK *sdk = [VungleSDK sharedSDK];
    // start vungle publisher library
    [sdk startWithAppId:appID error:nil];
}

@end

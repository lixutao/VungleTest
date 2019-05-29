//
//  ViewController.m
//  DemoTest
//
//  Created by lixutao on 2019/5/29.
//  Copyright © 2019年 lixutao. All rights reserved.
//

#import "ViewController.h"
#import <VungleSDK/VungleSDK.h>

#define PlACEMENTID @"PLMT01-41570"

@interface ViewController ()<VungleSDKDelegate>

@property(atomic, readonly, getter=isInitialized) BOOL initialized;
@property(nonatomic, strong) VungleSDK *sdk;
@property(nonatomic, copy) void(^passInterstitialLoadSuccessBlock)(void);
@property(nonatomic,strong)UIButton *playButton;
@property(nonatomic,strong)UIButton *loadButton;
@property(nonatomic,strong)UILabel *initlabel;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.sdk = [VungleSDK sharedSDK];
    self.sdk.delegate = self;
    
    self.initlabel = [[UILabel alloc]initWithFrame:CGRectMake(170, 280, 100, 100)];
    [self.initlabel setText:@"初始化中。。。"];
    [self.initlabel setTextColor:[UIColor redColor]];
    [self.view addSubview:self.initlabel];
    
    // make customer view
    self.loadButton = [[UIButton alloc]init];
    self.loadButton.hidden = YES;
    [self.loadButton addTarget:self action:@selector(loadVideo) forControlEvents:UIControlEventTouchUpInside];
    [self.loadButton setFrame:CGRectMake(50, 100, 100, 100)];
    self.loadButton.layer.masksToBounds = YES;
    self.loadButton.layer.cornerRadius = 50;
    [self.loadButton setTitle:@"Load Video" forState:UIControlStateNormal];
    [self.loadButton setBackgroundColor:[UIColor redColor]];
    [self.view addSubview:self.loadButton];
    
    self.playButton = [[UIButton alloc]initWithFrame:CGRectMake(250, 100, 100, 100)];
    [self.playButton setBackgroundColor:[UIColor purpleColor]];
    self.playButton.hidden = YES;
    self.playButton.layer.masksToBounds = YES;
    self.playButton.layer.cornerRadius = 50;
    [self.playButton setTitle:@"Play Video" forState:UIControlStateNormal];
    [self.playButton addTarget:self action:@selector(playVideo) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.playButton];
}

//播放视频 play action
- (void)playVideo{
    if([self.sdk isAdCachedForPlacementID:PlACEMENTID]){
        [self.sdk playAd:self options:nil placementID:PlACEMENTID error:nil];
    }else{
        __weak typeof(self) weakSelf = self;
        self.passInterstitialLoadSuccessBlock= ^{
            __strong typeof(self) strongSelf = weakSelf;
            [strongSelf.sdk playAd:strongSelf options:nil placementID:PlACEMENTID error:nil];
        };
    }
}

//加载视频 load action
- (void)loadVideo{
    [self.sdk loadPlacementWithID:PlACEMENTID error:nil];
}

#pragma VungleSDKDelegate
//一旦初始化成功，以下回调会被调用：
- (void)vungleSDKDidInitialize{
    NSLog(@"初始化成功");
    NSLog(@"%@",[NSThread currentThread]);
    [self.initlabel setText:@"初始化成功"];
    self.loadButton.hidden = NO;
}

//一旦初始化失败，以下回调会被调用
-(void)vungleSDKFailedToInitializeWithError:(NSError *)error{
    NSLog(@"初始化失败");
}

//loadPlacementWithID返回YES，不代表缓存成功，只能代表加载成功，缓存还是需要一定的时间的。
//一旦缓存成功，会回调这个方法：
-(void)vungleAdPlayabilityUpdate:(BOOL)isAdPlayable placementID:(NSString *)placementID error:(NSError *)error{
    if([self.sdk isAdCachedForPlacementID:PlACEMENTID]){
        if (self.passInterstitialLoadSuccessBlock) {
            self.passInterstitialLoadSuccessBlock();
            
        }
        
        //        NSLog(@"%@",[NSThread currentThread]);
        //        dispatch_async(dispatch_get_main_queue(), ^{
        //
        //        });
        if(!self.loadButton.hidden){
            self.playButton.hidden = NO;
        }
        //        NSDictionary *options = @{VunglePlayAdOptionKeyOrientations: @(UIInterfaceOrientationMaskAll),
        //                                  VunglePlayAdOptionKeyUser: @"userGameID",
        //                                  VunglePlayAdOptionKeyIncentivizedAlertBodyText : @"If the video isn't completed you won't get your reward! Are you sure you want to close early?",
        //                                  VunglePlayAdOptionKeyIncentivizedAlertCloseButtonText : @"Close",
        //                                  VunglePlayAdOptionKeyIncentivizedAlertContinueButtonText : @"Keep Watching",
        //                                  VunglePlayAdOptionKeyIncentivizedAlertTitleText : @"Careful!"};
        //        [self.sdk playAd:self options:options placementID:PlACEMENTID error:nil];
        
        NSLog(@"load success");
    }else if(error){
        NSLog(@"load fail");
    }
}
//当 SDK 即将播放视频广告时，会调用以下方法。此时是暂停游戏、声效和动画等内容的最佳时机。
- (void)vungleWillShowAdForPlacementID:(nullable NSString *)placementID{
    
}
//当 SDK 即将关闭广告时，会调用以下方法。此时是奖励式用户并恢复游戏、声效和动画等内容的最佳时机。
- (void)vungleWillCloseAdWithViewInfo:(VungleViewInfo *)info placementID:(NSString *)placementID{
    
}
//当 SDK 关闭广告后，会调用以下方法：
- (void)vungleDidCloseAdWithViewInfo:(VungleViewInfo *)info placementID:(NSString *)placementID{
    
}

@end

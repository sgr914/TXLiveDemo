//
//  LivePusherVC.m
//  TXLiveDemo
//
//  Created by shiguorui on 2017/12/4.
//  Copyright © 2017年 shiguorui. All rights reserved.
//

#import "LivePusherVC.h"
#import "LiveDemoDefine.h"

#import "TXLiteAVSDK_Professional/TXLivePush.h"


@interface LivePusherVC ()<TXLivePushListener>

@property (weak, nonatomic) IBOutlet UISwitch *beautySwitch;
@property (weak, nonatomic) IBOutlet UIButton *startPushButton;
@property (weak, nonatomic) IBOutlet UIButton *stopPushButton;
@property (weak, nonatomic) IBOutlet UIView *pushPreview;

@property (nonatomic, strong) TXLivePush *livePusher;


@end

@implementation LivePusherVC



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"live pusher";
    
    [self.view setBackgroundColor: [UIColor whiteColor]];
    
    
    //start live push
    //    [self startLivePush];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




#pragma mark - Actions

- (IBAction)beautyEffectSwitched: (UISwitch *)beautySwitch
{
    if (beautySwitch.isOn)
        [self setMaxBeautyEffect];
    else
        [self setNoneBeautyEffect];
    
}

- (IBAction)pushButtonPressed:(id)sender
{
    [self startLivePush];
}

- (IBAction)stopButtonPressed:(id)sender
{
    [self stopLivePush];
}




#pragma mark - Live Push

-(void)startLivePush
{
    // 创建 LivePushConfig 对象，该对象默认初始化为基础配置
    TXLivePushConfig* _config = [[TXLivePushConfig alloc] init];
    _config.videoFPS = 16;
    //在 _config中您可以对推流的参数（如：美白，硬件加速，前后置摄像头等）做一些初始化操作，需要注意 _config不能为nil
    self.livePusher = [[TXLivePush alloc] initWithConfig: _config];
    [self.livePusher setDelegate: self];
    NSString* rtmpUrl = @"rtmp://17043.livepush.myqcloud.com/live/17043_af526fb213?bizid=17043&txSecret=e5a2315bce3fe152739512eb6712de8c&txTime=5A2570FF";
    [self.livePusher setVideoQuality: VIDEO_QUALITY_STANDARD_DEFINITION
                       adjustBitrate: NO
                    adjustResolution: NO];
    
    [self.livePusher setZoom: 0.5];
    
    //开启美颜
    [self setMaxBeautyEffect];

    [self.livePusher startPush: rtmpUrl];
    
    //开启预览
    [self.livePusher startPreview: self.pushPreview];
    
}

-(void)stopLivePush
{
    [self.livePusher stopPush];
    
    [self.livePusher stopPreview];
}

#pragma mark - Beauty Functions

-(void)setNoneBeautyEffect
{
    //可设置效果：美颜、美白、红润、大眼、瘦脸、滤镜、下巴伸缩、短脸、瘦鼻
    [self.livePusher setBeautyStyle: BEAUTY_STYLE_SMOOTH
                        beautyLevel: 0
                     whitenessLevel: 0
                     ruddinessLevel: 0];
    
//    //此处无效：特别商用版有效
//    [self.livePusher setEyeScaleLevel: 0];
//    [self.livePusher setFaceScaleLevel: 0];
//    [self.livePusher setFaceVLevel: 0];
//    [self.livePusher setChinLevel: 0];
//    [self.livePusher setFaceShortLevel: 0];
//    [self.livePusher setNoseSlimLevel: 0];
    
}


-(void)setMaxBeautyEffect
{
    //可设置效果：美颜、美白、红润、大眼、瘦脸、滤镜、下巴伸缩、短脸、瘦鼻
    [self.livePusher setBeautyStyle: BEAUTY_STYLE_SMOOTH
                        beautyLevel: 9
                     whitenessLevel: 9
                     ruddinessLevel: 9];
    
//    //此处无效：特别商用版有效
//    [self.livePusher setEyeScaleLevel: 9];
//    [self.livePusher setFaceScaleLevel: 9];
//    [self.livePusher setFaceVLevel: 9];
//    [self.livePusher setChinLevel: 9];
//    [self.livePusher setFaceShortLevel: 9];
//    [self.livePusher setNoseSlimLevel: 9];
    
    
    
}

//    /* setFilter 设置指定素材滤镜特效
//     * 参数：
//     *          image     : 指定素材，即颜色查找表图片。注意：一定要用png格式！！！
//     *          demo用到的滤镜查找表图片位于RTMPiOSDemo/RTMPiOSDemo/resource／FilterResource.bundle中
//     */
//    - (void)setFilter:(UIImage *)image;
//
//    /* setSpecialRatio 设置滤镜效果程度
//     * 参数：
//     *          specialValue     : 从0到1，越大滤镜效果越明显，默认取值0.5
//     */
//    - (void)setSpecialRatio:(float)specialValue;






#pragma mark - TXLivePushListener

-(void)onPushEvent: (int)EvtID withParam: (NSDictionary *)param
{
    NSLog(@"-----EvtID(%d)-----(%@)", EvtID, param);
}

-(void)onNetStatus: (NSDictionary *) param
{
    NSLog(@"-----onNetStatus: -----(%@)", param);
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

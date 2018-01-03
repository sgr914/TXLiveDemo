//
//  LivePlayerVC.m
//  TXLiveDemo
//
//  Created by shiguorui on 2017/12/4.
//  Copyright © 2017年 shiguorui. All rights reserved.
//

#import "LivePlayerVC.h"
#import "LiveDemoDefine.h"

#import "LiveChatCell.h"

#import "TXLiteAVSDK_Professional/TXLivePlayer.h"
#import <TLSSDK/TLSHelper.h>
#import <ImSDK/ImSDK.h>


#define kCurrentUserName @"livedemouser2"
#define kCurrentPassword @"livedemouser2"


@interface LivePlayerVC ()<UITableViewDataSource, UITableViewDelegate, TXLivePlayListener, TLSStrAccountRegListener, TLSPwdLoginListener, TIMGroupListener, TIMMessageListener>

@property (nonatomic, strong) TXLivePlayer *livePlayer;
@property (weak, nonatomic) IBOutlet UIView *playerPanelView;
@property (weak, nonatomic) IBOutlet UILabel *onlineNumLabel;

@property (weak, nonatomic) IBOutlet  UITableView *chatTable;

@property (weak, nonatomic) IBOutlet UIButton *startPlayButton;
@property (weak, nonatomic) IBOutlet UIButton *stopPlayButton;
@property (weak, nonatomic) IBOutlet UIButton *sendMessageButton;

@property (strong, nonatomic) NSMutableArray *messageArray;

@end



@implementation LivePlayerVC

-(void)dealloc
{
    [[TIMManager sharedInstance] removeMessageListener: self];
    
    [self quitAVChatRoom];
    [self stopLivePlayer];
}


#pragma mark - VC Life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.messageArray = [[NSMutableArray alloc] init];
    
    for (NSInteger index = 0; index < 20; ++index)
    {
        NSDictionary *msgDict = [[NSDictionary alloc] initWithObjectsAndKeys:  @"昵称", @"name", @"15:30",@"time", @"这是一条直播聊天这是一条直播聊天这是一条直播聊天这是一条直播聊天", @"text", nil];
        
        
        [self.messageArray addObject: msgDict];
        
    }
    
    self.title = @"live player";
    
    [self.view setBackgroundColor: [UIColor whiteColor]];
    
    [self.chatTable registerNib: [UINib nibWithNibName: @"LiveChatCell" bundle: [NSBundle mainBundle]] forCellReuseIdentifier: @"LiveChatCell"];
//    [self.chatTable registerClass: [LiveChatCell class] forCellReuseIdentifier:  @"LiveChatCell"];
    
    //配置IM SDK
    [self configIMSDK];
    
    //需要用户时：注册demo user
//    [self registerDemoAccount];
    
    //登录demo user：登录成功后加入聊天室群
    [self loginDemoAccount];
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear: animated];
    
    [self quitAVChatRoom];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)configIMSDK
{
    TIMSdkConfig *config = [[TIMSdkConfig alloc] init];
    [config setDisableLogPrint: YES];
    config.sdkAppId = 1400052923;
    config.accountType = @"19801";
    int result = [[TIMManager sharedInstance] initSdk: config];
    
    //配置GroupListener
    TIMUserConfig *userConfig = [[TIMUserConfig alloc] init];
    userConfig.groupInfoOpt.groupCustom = [[NSArray alloc] init];
    userConfig.groupListener = self;
    [[TIMManager sharedInstance] setUserConfig: userConfig];
    
    //消息监听
    [[TIMManager sharedInstance] addMessageListener: self];
    
    
    NSLog(@"(result: %d, success: 0)", result);
    
}


#pragma mark - Actions

- (IBAction)playButtonPressed:(id)sender
{
    [self startLivePlayer];
}

- (IBAction)stopButtonPressed:(id)sender
{
    [self stopLivePlayer];
}

- (IBAction)sendButtonPressed:(id)sender
{
    TIMConversation *conversation = [[TIMManager sharedInstance] getConversation: TIM_GROUP
                                                                        receiver: @"@TGS#a4SSEI7ET"];
    NSLog(@"conversation: %@", conversation);
    
    TIMMessage *imMessage = [[TIMMessage alloc] init];
    TIMTextElem *textElem = [[TIMTextElem alloc] init];
    [textElem setText: @"这是一条测试消息"];
    [imMessage addElem: textElem];
    
    [conversation sendMessage: imMessage succ:^{
        
        NSDictionary *msgDict = @{@"name": kCurrentUserName, @"time": @"15:51", @"text": @"这是一条测试消息"};
        [self.messageArray insertObject: msgDict atIndex: 0];
        
        [self.chatTable reloadData];
        
    } fail:^(int code, NSString *msg) {
        
        NSLog(@"-------sendMessageFail(code: %d, message: %@)", code, msg);
    }];
    
}

#pragma mark - Live Room Setting

-(void)resetRoomInfo
{
    TIMGroupInfoOption *groupInfo = [[TIMManager sharedInstance] getUserConfig].groupInfoOpt;
    
    NSLog(@"groupInfo: %@", groupInfo);
    
    //在线人数，最好从服务端获取
    [self.onlineNumLabel setText: @"在线人数：1"];

    
    
}


#pragma mark - Player

-(void)startLivePlayer
{
    TXLivePlayConfig *config = [[TXLivePlayConfig alloc] init];
    config.cacheTime = 5;
    
    self.livePlayer = [[TXLivePlayer alloc] init];
    [self.livePlayer setConfig: config];
    [self.livePlayer setRenderMode: RENDER_MODE_FILL_EDGE];
    [self.livePlayer showVideoDebugLog: NO];
    [self.livePlayer setDelegate: self];
    [self.livePlayer setupVideoWidget: CGRectMake(0, 64, kScreenWidth, 300)
                          containView: self.playerPanelView
                          insertIndex: 0];
    NSString *rtmpUrl = @"rtmp://17043.liveplay.myqcloud.com/live/17043_af526fb213";
    [self.livePlayer startPlay: rtmpUrl type: PLAY_TYPE_LIVE_RTMP];
    
    [self.livePlayer showVideoDebugLog: YES];
    
    //flv无法正常播放
    //    NSString *flvUrl = @"http://17043.liveplay.myqcloud.com/live/17043_03e3d3ddaa.flv";
    //    [self.livePlayer startPlay: flvUrl type: PLAY_TYPE_LIVE_FLV];
    
}

-(void)stopLivePlayer
{
    [self.livePlayer stopPlay];
    
}



#pragma mark TXLivePlayListener

-(void) onPlayEvent:(int)EvtID withParam:(NSDictionary*)param
{
    NSLog(@"-----EvtID(%d)-----(%@)", EvtID, param);
    
}

-(void)onNetStatus: (NSDictionary *) param
{
    NSLog(@"-----onNetStatus: -----(%@)", param);
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.messageArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *LiveChatCellIdentifier = @"LiveChatCell";
    
    LiveChatCell *cell = [tableView dequeueReusableCellWithIdentifier: LiveChatCellIdentifier];
    
    if (cell == nil) {
        cell = [[LiveChatCell alloc] initWithStyle: UITableViewCellStyleDefault reuseIdentifier: LiveChatCellIdentifier];
        
    }
    
    NSDictionary *msgDict = self.messageArray[indexPath.row];
    
    cell.nameLabel.text = msgDict[@"name"];
    cell.timeLabel.text = msgDict[@"time"];
    cell.chatContentLabel.text = msgDict[@"text"];;

    
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45;
    
}



#pragma mark - IM


-(void)registerDemoAccount
{
    [[TLSHelper getInstance] TLSStrAccountReg: kCurrentUserName
                                  andPassword: kCurrentPassword
                  andTLSStrAccountRegListener: self];
    
    
}

-(void)loginDemoAccount
{
    int result = [[TLSHelper getInstance] TLSPwdLogin: kCurrentUserName
                                          andPassword: kCurrentPassword
                               andTLSPwdLoginListener: self];
    
    NSLog(@"(result: %d, success: 0)", result);

}


#pragma mark TLSStrAccountRegListener

-(void)OnStrAccountRegSuccess:(TLSUserInfo*)userInfo
{
    NSLog(@"-------OnStrAccountRegSuccess: %@", userInfo);

    
}

-(void)OnStrAccountRegFail:(TLSErrInfo *) errInfo
{
    NSLog(@"-------OnStrAccountRegFail: %@", errInfo);

    
}

-(void)OnStrAccountRegTimeout:(TLSErrInfo *) errInfo
{
    NSLog(@"-------OnStrAccountRegTimeout: %@", errInfo);

    
}


#pragma mark TLSPwdLoginListener

-(void)OnPwdLoginSuccess:(TLSUserInfo *)userInfo
{
    
    NSLog(@"-------OnGuestLoginSuccess: %@", userInfo);

    TIMLoginParam *loginParam = [[TIMLoginParam alloc] init];
    loginParam.appidAt3rd = @"1400052923"; // 填写您的SDKAPPID
    loginParam.identifier = userInfo.identifier;
    loginParam.userSig = [[TLSHelper getInstance] getTLSUserSig:userInfo.identifier];

    __weak LivePlayerVC *weakSelf = self;
    [[TIMManager sharedInstance] login:loginParam succ:^{
        // OK, 登录成功，后面就可以发消息了！
        __strong LivePlayerVC *strongSelf = weakSelf;
        
        [strongSelf joinAVChatRoom];
        
    } fail:^(int code, NSString *msg) {
        // im sdk 登录失败，请检查 IMSDK_APPID 是不是搞错了
    }];
    
}

-(void)OnPwdLoginFail:(TLSErrInfo *)errInfo
{
    NSLog(@"-------OnPwdLoginFail: %@", errInfo);
}

-(void)OnPwdLoginTimeout:(TLSErrInfo *)errInfo
{
    NSLog(@"-------OnPwdLoginTimeout: %@", errInfo);
}

#pragma mark Join Group

-(void)joinAVChatRoom
{
    //加入互动聊天室
    [[TIMGroupManager sharedInstance] joinGroup: @"@TGS#a4SSEI7ET" msg: @"进入房间" succ:^{
        
        //获取在线人数等
        NSLog(@"-------joinGroupSuccess");
        [self resetRoomInfo];
        
    } fail:^(int code, NSString *msg) {
        
        NSLog(@"-------joinGroupFail(code: %d, msg: %@)", code, msg);

    }];
    
}

-(void)quitAVChatRoom
{
    //退出互动聊天室
    [[TIMGroupManager sharedInstance] quitGroup: @"@TGS#a4SSEI7ET" succ:^{
        
        NSLog(@"-------quitGroupSuccess");
        
    } fail:^(int code, NSString *msg) {
        
        NSLog(@"-------quitGroupFail(code: %d, msg: %@)", code, msg);

    }];
    
}

#pragma mark Join Group

//---------------------------加群退群须配置服务端回调---------------------------
- (void)onMemberJoin:(NSString*)groupId membersInfo:(NSArray*)membersInfo
{
    NSLog(@"-------onMemberUpdate(有人加入聊天室，此处处理)");
    
}

- (void)onMemberQuit:(NSString*)groupId members:(NSArray*)members
{
    NSLog(@"-------onMemberUpdate(有人退出聊天室，此处处理)");
    
}

- (void)onGroupAdd: (TIMGroupInfo*)groupInfo
{
    NSLog(@"-------onGroupAdd(加入聊天室，此处处理)");

}

#pragma mark - TIMMessageListener

- (void)onNewMessage:(NSArray*)msgs
{
    NSLog(@"---msgs: %@", msgs);
    
    TIMMessage *theMessage = msgs[0];
    
    NSLog(@"%@", [theMessage getElem: 0]);
    
    //过滤文字消息并显示
    if ([[theMessage getElem: 0] isKindOfClass: [TIMTextElem class]])
    {
        
        TIMTextElem *textElem = (TIMTextElem *)[theMessage getElem: 0];
        
        NSDictionary *msgDict = @{@"name": theMessage.sender, @"time": theMessage.timestamp.description, @"text": textElem.text};
        
        [self.messageArray insertObject: msgDict atIndex: 0];
        
        [self.chatTable reloadData];
    }

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


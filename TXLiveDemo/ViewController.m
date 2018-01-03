//
//  ViewController.m
//  TXLiveDemo
//
//  Created by shiguorui on 2017/11/30.
//  Copyright © 2017年 shiguorui. All rights reserved.
//

#import "ViewController.h"

#import "LiveDemoDefine.h"

#import "LivePlayerVC.h"
#import "LivePusherVC.h"

#import "TXLiteAVSDK_Professional/TXLiveBase.h"
#import <ImSDK/ImSDK.h>


@interface ViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@end


@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.title = @"Functions";
    
    NSLog(@"SDK Version = %@", [TXLiveBase getSDKVersionStr]);
    [TXLiveBase setConsoleEnabled:YES];
    [TXLiveBase setLogLevel:LOGLEVEL_DEBUG];
    
    self.tableView = [[UITableView alloc] initWithFrame: CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    [self.tableView setDataSource: self];
    [self.tableView setDelegate: self];
    
    [self.view addSubview: self.tableView];
    
    //start play
//    [self startLivePlayer];

//    TIMSdkConfig *config = [[TIMSdkConfig alloc] init];
//
//    //Config IM
//    BOOL success = [[TIMManager sharedInstance] initSdk: config];
//    
//    NSLog(@"%d", success);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.

}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"liveCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: identifier];
    
    NSArray *titles = @[@"mobile push", @"mobile player"];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle: UITableViewCellStyleDefault reuseIdentifier: identifier];
        [cell.textLabel setText: titles[indexPath.row]];
        
    }
    
    
    return cell;
}


#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0)
    {
        LivePusherVC *pushVC = [[LivePusherVC alloc] init];
        
        [self.navigationController pushViewController: pushVC animated: YES];
    }
    else
    {
        LivePlayerVC *playerVC = [[LivePlayerVC alloc] init];
        
        [self.navigationController pushViewController: playerVC animated: YES];

        
    }
    
    [tableView deselectRowAtIndexPath: indexPath animated: YES];
}




@end

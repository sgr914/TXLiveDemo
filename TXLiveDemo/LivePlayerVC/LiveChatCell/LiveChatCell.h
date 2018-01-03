//
//  LiveChatCell.h
//  TXLiveDemo
//
//  Created by shiguorui on 2017/12/6.
//  Copyright © 2017年 shiguorui. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LiveChatCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *chatContentLabel;

@end

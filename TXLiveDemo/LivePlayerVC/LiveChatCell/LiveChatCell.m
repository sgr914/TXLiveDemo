//
//  LiveChatCell.m
//  TXLiveDemo
//
//  Created by shiguorui on 2017/12/6.
//  Copyright © 2017年 shiguorui. All rights reserved.
//

#import "LiveChatCell.h"
#import "UIColor+Hex.h"

@implementation LiveChatCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [self.nameLabel setTextColor: [UIColor colorWithHex: 0xf6a623]];
    [self.timeLabel setTextColor: [UIColor colorWithHex: 0xc3c3c3]];
    [self.chatContentLabel setTextColor: [UIColor colorWithHex: 0x666666]];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

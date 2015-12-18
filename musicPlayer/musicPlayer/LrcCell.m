//
//  LrcCell.m
//  musicPlayer
//
//  Created by qingyun on 15/12/17.
//  Copyright © 2015年 hutilii. All rights reserved.
//

#import "LrcCell.h"
#import "lrcLine.h"

@implementation LrcCell

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    
    static NSString *ID = @"lrc";
    LrcCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[LrcCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    return cell;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.textLabel.textAlignment = NSTextAlignmentCenter;
        self.textLabel.numberOfLines = 0;
    }
    return self;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.textLabel.frame = self.bounds;
}

- (void)setLrcLine:(lrcLine *)lrcLine {
    _lrcLine = lrcLine;
    self.textLabel.text = lrcLine.word;
}

@end

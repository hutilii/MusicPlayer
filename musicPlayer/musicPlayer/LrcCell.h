//
//  LrcCell.h
//  musicPlayer
//
//  Created by qingyun on 15/12/17.
//  Copyright © 2015年 hutilii. All rights reserved.
//

#import <UIKit/UIKit.h>
@class lrcLine;

@interface LrcCell : UITableViewCell
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@property (nonatomic, strong)lrcLine *lrcLine;
@end

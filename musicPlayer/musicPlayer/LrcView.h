//
//  MusicTableViewCell.m
//  MusicPlayer
//
//  Created by qingyun on 15/12/12.
//  Copyright © 2015年 hutilii. All rights reserved.
//

#import "DRNRealTimeBlurView.h"

@interface LrcView : DRNRealTimeBlurView
/**
 *  歌词的文件名
 */
@property (nonatomic, copy) NSString *lrcname;

@property (nonatomic, assign) NSTimeInterval currentTime;
@end

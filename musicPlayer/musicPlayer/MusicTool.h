//
//  MusicTool.h
//  musicPlayer
//
//  Created by qingyun on 15/12/15.
//  Copyright © 2015年 hutilii. All rights reserved.
//  管理音乐数据（音乐模型）

#import <Foundation/Foundation.h>
@class Music;

@interface MusicTool : NSObject
/**
 *  返回所有的歌曲
 */
+ (NSArray *)musics;

/**
 *  返回正在播放的歌曲
 */
+ (Music *)playingMusic;
+ (void)setPlayingMusic:(Music *)playingMusic;

/**
 *  下一首
 */
+ (Music *)nextMusic;

/**
 *  上一首
 */
+ (Music *)previousMusic;

@end

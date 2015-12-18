//
//  Music.h
//  MusicPlayer
//
//  Created by qingyun on 15/12/12.
//  Copyright © 2015年 hutilii. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Music : NSObject
@property (nonatomic, copy) NSString *name; // 歌曲名
@property (nonatomic, copy) NSString *icon; // 大图
@property (nonatomic, copy) NSString *filename; // 歌曲文件名
@property (nonatomic, copy) NSString *lrcname; // 歌词文件名
@property (nonatomic, copy) NSString *singer; // 歌手
@property (nonatomic, copy) NSString *singerIcon; // 歌手图标

- (instancetype) initWithDictionary:(NSDictionary *)dict;
+ (instancetype) musicWithDictioary:(NSDictionary *)dict;

@end

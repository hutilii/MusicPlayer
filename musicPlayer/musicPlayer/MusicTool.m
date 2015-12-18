//
//  MusicTool.m
//  musicPlayer
//
//  Created by qingyun on 15/12/15.
//  Copyright © 2015年 hutilii. All rights reserved.
//

#import "MusicTool.h"
#import "Music.h"

@implementation MusicTool
static NSMutableArray *_musics;
static Music *_playingMusic;

/**
 *  返回所有的歌曲
 */
+ (NSMutableArray *)musics {
    if (_musics == nil) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"Musics" ofType:@"plist"];
        NSArray *models = [NSArray arrayWithContentsOfFile:path];
        _musics = [NSMutableArray array];
        for (NSDictionary *dict in models) {
            Music *model = [Music musicWithDictioary:dict];
            [_musics addObject:model];
        }
    }
    return _musics;
}

/**
 *  返回正在播放的歌曲
 */
+ (Music *)playingMusic {
    return _playingMusic;
}

+ (void)setPlayingMusic:(Music *)playingMusic {
    if (!playingMusic || ![[self musics] containsObject:playingMusic]) return;
    if (_playingMusic == playingMusic) return;
    _playingMusic = playingMusic;
}
/**
 *  下一首
 */
+ (Music *)nextMusic {
    int nextIndex = 0;
    if (_playingMusic) {
        int playingIndex = [[self musics] indexOfObject:_playingMusic];
        nextIndex = playingIndex + 1;
        if (nextIndex >= [self musics].count) {
            nextIndex = 0;
        }
    }
    return [self musics][nextIndex];
}

/**
 *  上一首
 */
+ (Music *)previousMusic {
    int previousIndex = 0;
    if (_playingMusic) {
        int playingIndex = [[self musics] indexOfObject:_playingMusic];
        previousIndex = playingIndex - 1;
        if (previousIndex < 0) {
            previousIndex = [self musics].count - 1;
        }
    }
    return [self musics][previousIndex];
}

@end















//
//  AudioTool.m
//  musicPlayer
//
//  Created by qingyun on 15/12/15.
//  Copyright © 2015年 hutilii. All rights reserved.
//

#import "AudioTool.h"

@implementation AudioTool
+ (void)initialize {
    
    //音频会话
    AVAudioSession *session = [AVAudioSession sharedInstance];
    //设置会话的类型(播放类型，播放模式，会自动停止其他音乐的播放)
    [session setCategory:AVAudioSessionCategoryAmbient error:nil];
    //激活会话
    [session setActive:YES error:nil];
}
/**
 *  存放所有的音效ID
 */
static NSMutableDictionary *_soundIDs;
+ (NSMutableDictionary *)soundIDs {
    if (!_soundIDs) {
        _soundIDs = [NSMutableDictionary dictionary];
    }
    return _soundIDs;
}

/**
 *  存放所有的音乐播放器
 */
static NSMutableDictionary *_musicPlayers;
+ (NSMutableDictionary *)musicPlayers {
    if (!_musicPlayers) {
        _musicPlayers = [NSMutableDictionary dictionary];
    }
    return _musicPlayers;
}

/**
 *  播放音乐
 *  @param filename 音乐的文件名
 */
+ (AVAudioPlayer *)playMusic:(NSString *)filename {
    if (!filename) return nil;
    
    //1.取出对应的播放器
    AVAudioPlayer *player = [self musicPlayers][filename];
    //2.初始化播放器，创建
    if (!player) {
        // 音频文件的URL
        NSURL *url = [[NSBundle mainBundle] URLForResource:filename withExtension:nil];
        if (!url) return nil;
        
        //创建播放器（一个AVAudioPlayer只能播放一个URl）
        player = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
        //速度
//        player.enableRate = YES;
//        player.rate = 2.0;
        
        //缓冲
        if (![player prepareToPlay]) return nil;
        
        //存入字典
        [self musicPlayers][filename] = player;
    }
    
    //3.播放
    if (!player.isPlaying) {
        [player play];
    }
    
    //正在播放
    return player;
}
/**
 *  暂停音乐
 *  @param filename 音乐的文件名
 */
+ (void)pauseMusic:(NSString *)filename {
    
    if (!filename) return;
    //获取对应的播放器
    AVAudioPlayer *player = [self musicPlayers][filename];
    
    //暂停
    if (player.isPlaying) {
        [player pause];
    }
}

/**
 *  停止音乐
 *  @param filename 音乐的文件名
 */
+ (void)stopMusic:(NSString *)filename {
    
    if (!filename) return;
    //取出播放器
    AVAudioPlayer *player = [self musicPlayers][filename];
    //停止
    [player stop];
    //将播放器移除
    [[self musicPlayers] removeObjectForKey:filename];
}

/**
 *  播放音效
 */
+ (void)playSound:(NSString *)filename {
    
    if (!filename) return;
    
    //取出音效Id
    SystemSoundID soundID = [[self soundIDs][filename]unsignedLongValue];
    //初始化
    if (!soundID) {
        NSURL *url = [[NSBundle mainBundle] URLForResource:filename withExtension:nil];
        if (!url) return;
        
        AudioServicesCreateSystemSoundID((__bridge CFURLRef)(url),&soundID);
        
        //存入字典
        [self soundIDs][filename] = @(soundID);
    }
    
    //播放
    AudioServicesPlaySystemSound(soundID);
}

/**
 *  销毁音效
 */
+ (void)disposeSound:(NSString *)filename {
    if (!filename) return;
    
    //取出对应的音效ID
    SystemSoundID soundID = [[self soundIDs][filename] unsignedLongValue];
    
    //销毁
    if (soundID) {
        AudioServicesDisposeSystemSoundID(soundID);
        
        [[self soundIDs] removeObjectForKey:filename];
    }
}
@end

















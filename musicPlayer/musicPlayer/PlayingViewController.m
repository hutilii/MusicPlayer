//
//  PlayingViewController.m
//  MusicPlayer
//
//  Created by qingyun on 15/12/12.
//  Copyright © 2015年 hutilii. All rights reserved.
//

#import "PlayingViewController.h"
#import "UIView+Extension.h"
#import "MusicTool.h"
#import "Music.h"
#import "AudioTool.h"
#import <AVFoundation/AVFoundation.h>
#import "LrcView.h"

@interface PlayingViewController ()<AVAudioPlayerDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *songLabel;
@property (weak, nonatomic) IBOutlet UILabel *singerLabel;
@property (weak, nonatomic) IBOutlet UILabel *durationLabel;
@property (nonatomic, strong) Music *playingMusic;
//播放器
@property (nonatomic, strong) AVAudioPlayer *player;
//滑块
@property (weak, nonatomic) IBOutlet UIButton *slider;
//进度条
@property (weak, nonatomic) IBOutlet UIView *progerssView;

/**
 *  播放进度定时器
 */
@property (nonatomic, strong) NSTimer *currentTimeTimer;

/**
 *  歌词显示定时器
 */
@property (nonatomic, strong) CADisplayLink *lrcTimer;

@property (weak, nonatomic) IBOutlet UIButton *currentTimeView;
@property (weak, nonatomic) IBOutlet UIButton *playOrPause;
@property (weak, nonatomic) IBOutlet LrcView *lrcView;

@end

@implementation PlayingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.currentTimeView.layer.cornerRadius = 10;
    // Do any additional setup after loading the view from its nib.
}
#pragma mark - 公共方法
/**
 *  显示
 */
- (void)show {
    //禁用整个app的点击事件
    UIWindow *window = [[UIApplication sharedApplication].windows lastObject];
    window.userInteractionEnabled = NO;
    
    //添加播放界面
    self.view.frame = window.bounds;
    self.view.hidden = NO;
    [window addSubview:self.view];
    
    //检测是否换了歌曲
    if (self.playingMusic != [MusicTool playingMusic]) {
        [self resetPlayingMusic];
    }
    
    //动画显示
    self.view.y = self.view.height;
    [UIView animateWithDuration:1.0 animations:^{
        self.view.y = 0;
    } completion:^(BOOL finished) {
        //设置开始音乐播放数据
        [self startPlayingMusic];
    
        window.userInteractionEnabled = YES;
    }];
}

#pragma mark - 定时器处理
- (void)addCurrentTimeTimer {
    
    //拉滑块之后暂停再拉去，会回到原位置，需要
    if (self.player.isPlaying == NO) return;
    [self removeCurrentTimeTimer ];
    
    //保证定时器的工作是及时的
    [self updateCurrentTime];
    
    self.currentTimeTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateCurrentTime) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.currentTimeTimer forMode:NSRunLoopCommonModes];
}

- (void)removeCurrentTimeTimer {
    
    //移除
    [self.currentTimeTimer invalidate];
    self.currentTimeTimer = nil;
}
/**
 *    更新播放进度
 */
- (void)updateCurrentTime {
    
    //1. 计算进度值
    double progress = self.player.currentTime / self.player.duration;
    //2. 计算滑块的最大的X值
    CGFloat sliderMaxX = self.view.width - self.slider.width;
    self.slider.x = sliderMaxX * progress;
    [self.slider setTitle:[self strWithTime:self.player.currentTime] forState:UIControlStateNormal];
    //3. 设置进度条的宽度
    self.progerssView.width = self.slider.center.x;
}
/**
 *  歌词定时器
 */

- (void)addLrcTimer {
    
    //拉滑块之后暂停再拉去，会回到原位置，需要
    if (self.player.isPlaying == NO || self.lrcView.hidden) return;
    [self removeLrcTimer];
    
    //保证定时器的工作是及时的
    [self updateLrc];
    
    self.lrcTimer = [CADisplayLink displayLinkWithTarget:self selector:@selector(updateLrc)];
    
    [self.lrcTimer addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
}

- (void)removeLrcTimer {
    
    //移除
    [self.lrcTimer invalidate];
    self.lrcTimer = nil;
}

/**
 *  更新歌词
 */
- (void)updateLrc {
    
    self.lrcView.currentTime = self.player.currentTime;
}




#pragma mark - 私有方法
/**
 *  重置正在播放的歌曲
 */
- (void)resetPlayingMusic {
    
    //1. 重置界面设置
    self.iconView.image = [UIImage imageNamed:@"play_cover_pic_bg"];
    self.singerLabel.text = nil;
    self.songLabel.text = nil;
    self.durationLabel.text = nil;
    
    //2. 停止播放
    [AudioTool stopMusic:self.playingMusic.filename];
    self.player = nil;
    
    //3. 停止定时器
    [self removeCurrentTimeTimer];
    [self removeLrcTimer];
    
    //4. 设置播放按钮的状态
    self.playOrPause.selected = NO;
}

/**
 *  开始播放音乐
 */
- (void)startPlayingMusic {
    
    if (self.playingMusic == [MusicTool playingMusic]) {
        [self addCurrentTimeTimer];
        [self addLrcTimer];
        return;
    }
    
    //1. 设置界面数据
    self.playingMusic = [MusicTool playingMusic];
    self.iconView.image = [UIImage imageNamed:self.playingMusic.icon];
    self.singerLabel.text = self.playingMusic.singer;
    self.songLabel.text = self.playingMusic.name;
    
    //2. 开始播放
    self.player = [AudioTool playMusic:self.playingMusic.filename];
    self.player.delegate = self;
    //3. 设置时长
    self.durationLabel.text = [self strWithTime:self.player.duration];
    //4. 开始定时器
    [self addCurrentTimeTimer];
    [self addLrcTimer];
    //5. 设置播放按钮的状态
    self.playOrPause.selected = YES;
    //6. 切换歌词（加载新的歌词）
    self.lrcView.lrcname = self.playingMusic.lrcname;
}

#pragma mark - 私有方法
/**
 *  时长长度 -> 时间字符串
 */
- (NSString *)strWithTime:(NSTimeInterval)time {
    int minute = time / 60;
    int second = (int)time % 60;
    return [NSString stringWithFormat:@"%d:%d",minute,second];
}

#pragma mark - 内部控件的监听
/**
 *退出
 */
- (IBAction)exit {
    
    //移除定时器
    [self removeCurrentTimeTimer];
    [self removeLrcTimer];
    //禁用整个app的点击事件
    UIWindow *window = [[UIApplication sharedApplication].windows lastObject];
    window.userInteractionEnabled = NO;
    
    //动画隐藏
    [UIView animateWithDuration:1.0 animations:^{
        self.view.y = self.view.height;
    } completion:^(BOOL finished) {
    self.view.hidden = YES;
    window.userInteractionEnabled = YES;
    }];
}

- (IBAction)lyricOrPic:(UIButton *)sender {
    
    if (self.lrcView.isHidden) { // 显示歌词，盖住图片
        self.lrcView.hidden = NO;
        sender.selected = YES;
        
        [self addLrcTimer];
    } else { // 隐藏歌词，显示图片
        self.lrcView.hidden = YES;
        sender.selected = NO;
        
        [self removeLrcTimer];
    }
}

- (IBAction)playOrPause:(UIButton *)sender {
    
    if (self.playOrPause.isSelected) { //暂停
        self.playOrPause.selected = NO;
        [AudioTool pauseMusic:self.playingMusic.filename];
        [self removeCurrentTimeTimer];
        [self removeLrcTimer];
    }else { //继续播放
        self.playOrPause.selected= YES;
        [AudioTool playMusic:self.playingMusic.filename];
        [self addCurrentTimeTimer];
        [self addLrcTimer];
    }
}

- (IBAction)previous {
    
    UIWindow *window = [[UIApplication sharedApplication].windows lastObject];
    window.userInteractionEnabled = NO;

    //重置
    [self resetPlayingMusic];
    //获取
    [MusicTool setPlayingMusic:[MusicTool previousMusic]];
    //播放
    [self startPlayingMusic];
    
    window.userInteractionEnabled = YES;
}

- (IBAction)next {
    
    UIWindow *window = [[UIApplication sharedApplication].windows lastObject];
    window.userInteractionEnabled = NO;

    
    //1. 重置当前歌曲
    [self resetPlayingMusic];
    //2. 获得下一首
    [MusicTool setPlayingMusic:[MusicTool nextMusic]];
    //3. 播放下一首
    [self startPlayingMusic];
    
    window.userInteractionEnabled = YES;
}

/**
 *  点击了进度条背景
 */
- (IBAction)tapProgressBg:(UITapGestureRecognizer *)sender {
    
    CGPoint point = [sender locationInView:sender.view];
    //切换歌曲的当前播放时间
    self.player.currentTime = (point.x / sender.view.width) * self.player.duration;
    [self updateCurrentTime];
}
/**
 *  拖动滑块
 */
- (IBAction)panSlider:(UIPanGestureRecognizer *)sender {
    
    //获得挪动的距离
    CGPoint t = [sender translationInView:sender.view];
    [sender setTranslation:CGPointZero inView:sender.view];
    
    // 控制滑块和进度条的frame
    CGFloat sliderMaxX = self.view.width - self.slider.width;
    self.slider.x += t.x;
    
    if (self.slider.x < 0) {
        self.slider.x = 0;
    }else if (self.slider.x > sliderMaxX) {
        self.slider.x = sliderMaxX;
    }
    self.progerssView.width = self.slider.center.x;
    
    //设置时间值
    double progress = self.slider.x / sliderMaxX;
    NSTimeInterval time = self.player.duration * progress;
    [self.slider setTitle:[self strWithTime:time] forState:UIControlStateNormal];
    
    //显示指示时间指示器的文字
    [self.currentTimeView setTitle:self.slider.currentTitle forState:UIControlStateNormal];
    self.currentTimeView.x = self.slider.x;
    
    if (sender.state == UIGestureRecognizerStateBegan) {
        //停止定时器
        [self removeCurrentTimeTimer];
        //显示半透明显示器
        self.currentTimeView.hidden = NO;
        self.currentTimeView.y = self.currentTimeView.superview.height - 10 - self.currentTimeView.height;
        
    }else if (sender.state == UIGestureRecognizerStateEnded) { //松手
        //设置播放器的时间
        self.player.currentTime = time;
        if (self.player.isPlaying) {
#warning 如果正在播放，才需要添加定时器
            //开始定时器
            [self addCurrentTimeTimer];
        }
        //隐藏半透明显示指示器
        self.currentTimeView.hidden = YES;
    }
}

#pragma mark - AVAudioPlayerDelegate 

/**
 *  播放器播放完毕后就会调用
 */
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    
    [self next];
}

/**
 *  当播放器遇到中断时（比如来电）
 */
- (void)audioPlayerBeginInterruption:(AVAudioPlayer *)player {
    
    if (self.player.isPlaying) {
        [self playOrPause];
    }
}
/**
 *  中断结束后调用（是否继续的问题）
 */
- (void)audioPlayerEndInterruption:(AVAudioPlayer *)player withOptions:(NSUInteger)flags {
    
}

@end

















//
//  MusicsViewController.m
//  MusicPlayer
//
//  Created by qingyun on 15/12/12.
//  Copyright © 2015年 hutilii. All rights reserved.
//

#import "MusicsViewController.h"
#import "Music.h"
#import "MusicTableViewCell.h"
#import "PlayingViewController.h"
#import "MusicTool.h"

@interface MusicsViewController ()
@property (nonatomic, strong) PlayingViewController *playingVc;

@end

@implementation MusicsViewController

- (PlayingViewController *)playingVc {
    if (_playingVc == nil) {
        self.playingVc = [[PlayingViewController alloc] init];
    }
    return _playingVc;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

#pragma mark - Table view data source

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//
//    return 0;
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return [MusicTool musics].count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MusicTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    Music *model = [MusicTool musics][indexPath.row];
    cell.Model = model;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //1. 取消选中被点击的行数
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    //2. 设置正在播放的歌曲
    [MusicTool setPlayingMusic:[MusicTool musics][indexPath.row]];
    //3. 显示播放界面
    [self.playingVc show];
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

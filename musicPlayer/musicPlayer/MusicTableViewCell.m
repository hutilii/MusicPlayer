//
//  MusicTableViewCell.m
//  MusicPlayer
//
//  Created by qingyun on 15/12/12.
//  Copyright © 2015年 hutilii. All rights reserved.
//

#import "MusicTableViewCell.h"
#import "Music.h"

@interface MusicTableViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *imageview;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *lrcname;


@end

@implementation MusicTableViewCell

- (void) setModel:(Music *)Model {
    _Model = Model;
    
    _imageview.layer.cornerRadius = 33;
//    _imageview.layer.borderWidth = 3;
//    _imageview.layer.borderColor = [UIColor blueColor].CGColor;
    _imageview.image = [UIImage imageNamed:Model.singerIcon];
    _name.text = Model.name;
    _lrcname.text = Model.singer;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

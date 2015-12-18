//
//  Music.m
//  MusicPlayer
//
//  Created by qingyun on 15/12/12.
//  Copyright © 2015年 hutilii. All rights reserved.
//

#import "Music.h"

@implementation Music

- (instancetype) initWithDictionary:(NSDictionary *)dict {
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}

+ (instancetype) musicWithDictioary:(NSDictionary *)dict {
    return [[self alloc] initWithDictionary:dict];
}


@end

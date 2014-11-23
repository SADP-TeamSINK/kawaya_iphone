//
//  ListViewController.m
//  Resty
//
//  Created by Imamori Daichi on 2014/11/21.
//  Copyright (c) 2014年 Kazuma Nagaya. All rights reserved.
//

#import "ListViewController.h"
#import <Foundation/Foundation.h>


@implementation ListViewController : NSObject {
    UIScrollView * listView_;
    NSInteger height_;
    NSInteger width_;
}

- (id) init{
    self = [super init];

    height_ = [[UIScreen mainScreen] bounds].size.height;
    width_ = [[UIScreen mainScreen] bounds].size.width;
    
    // リストの初期化
    listView_ = [[UIScrollView alloc] initWithFrame:CGRectMake(0, height_, width_, height_ * (1 - MAP_RATIO))];
    listView_.backgroundColor = [UIColor cyanColor];
    
    return self;
}

- (void) onScreen{
    listView_.frame = CGRectMake(0, height_ * (MAP_RATIO), width_, height_ * (1 - MAP_RATIO));
}

- (UIView *) getListView{
    return listView_;
}

- (void) listUpToilets:(Building *)building{
    for (NSMutableArray *toiletByFloor in building.toilets) {
        for (Toilet *toilet in toiletByFloor) {
            NSLog(@"floor: %ld, toilet: %@", (long)toilet.floor, toilet.storeName);
            for (Room *room in toilet.rooms) {
                NSLog(@"room: available: %d", room.available);
            }
        }
    }
}


@end

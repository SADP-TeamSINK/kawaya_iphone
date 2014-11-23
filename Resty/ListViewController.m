//
//  ListViewController.m
//  Resty
//
//  Created by Imamori Daichi on 2014/11/21.
//  Copyright (c) 2014年 Kazuma Nagaya. All rights reserved.
//

#import "ListViewController.h"
#import <Foundation/Foundation.h>


@implementation ListViewController{
    UIScrollView * listView_;
    UIView * baseView_;

    NSInteger height_;
    NSInteger width_;

    NSInteger listHeignt_;
    NSInteger listWidth_;
    NSInteger listTopMargin_;
    
    NSInteger baseHeignt_;
    NSInteger baseWidth_;
}

- (id) init{
    self = [super init];

    height_ = [[UIScreen mainScreen] bounds].size.height;
    width_ = [[UIScreen mainScreen] bounds].size.width;
    
    // ベースのサイズを設定
    baseHeignt_ = height_ * (1 - MAP_RATIO);
    baseWidth_ = width_;
    
    // ベースとなるViewを作成
    baseView_ = [[UIView alloc] initWithFrame:CGRectMake(0, height_, baseWidth_, baseHeignt_)];
    baseView_.backgroundColor = [UIColor colorWithRed:100/255.0 green:100/255.0 blue:100/255.0 alpha:1.0];//灰
    
    // リストのマージンを設定
    listTopMargin_ = LIST_TOP_BAR_HEIGHT;
    
    // リストのサイズを設定
    listHeignt_ = height_ * (1 - MAP_RATIO) - BUTTON_BOTTOM_MARGIN - BUTTON_TOP_MARGIN - BUTTON_HEIGHT - LIST_TOP_BAR_HEIGHT;
    listWidth_ = width_;

    // リストの初期化
    listView_ = [[UIScrollView alloc] initWithFrame:CGRectMake(0, listTopMargin_, listWidth_, listHeignt_)];
    listView_.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0];//白
    
    // baseViewにlistViewを追加
    [baseView_ addSubview:listView_];
    
    return self;
}

- (void) onScreen{
    baseView_.frame = CGRectMake(0, height_ * (MAP_RATIO), baseWidth_, baseHeignt_);
}

- (void) offScreen{
    baseView_.frame = CGRectMake(0, height_, baseWidth_, baseHeignt_);
}

- (UIView *) getListView{
    return baseView_;
}

- (void) listUpToilets:(Building *)building{
    double floorMargin = FLOOR_MARGIN_RATIO * height_;
    for (NSMutableArray *toiletByFloor in building.toilets) {
        double margin = (PANE_MARGIN_RATIO * height_) * floorMargin;
        for (Toilet *toilet in toiletByFloor) {
            NSLog(@"floor: %ld, toilet: %@", (long)toilet.floor, toilet.storeName);
            UIView *pane = [toilet getToiletPane];
            pane.transform = CGAffineTransformMakeTranslation(0, margin);
            [listView_ addSubview:pane];

            // マージンを確保
            margin += PANE_HEIGHT_RATIO * height_;
            margin += PANE_MARGIN_RATIO * height_;
        }
        // マージンの確保
        floorMargin += FLOOR_MARGIN_RATIO * height_;
    }
}


@end

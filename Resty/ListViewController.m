//
//  ListViewController.m
//  Resty
//
//  Created by Imamori Daichi on 2014/11/21.
//  Copyright (c) 2014年 Kazuma Nagaya. All rights reserved.
//

#import "ListViewController.h"
#import <Foundation/Foundation.h>


@implementation ListViewController : NSObject
UIScrollView * listView_;
NSInteger height_;
NSInteger width_;


- (id) init{
    self = [super init];

    height_ = [[UIScreen mainScreen] bounds].size.height;
    width_ = [[UIScreen mainScreen] bounds].size.width;
    
    // リストの初期化
    listView_ = [[UIScrollView alloc] initWithFrame:CGRectMake(0, height_ * (MAP_RATIO), width_, height_ * (1 - MAP_RATIO))];
    listView_.backgroundColor = [UIColor cyanColor];
    
    return self;
}

- (UIView *) getListView{
    return listView_;
}

@end

//
//  Toilet.m
//  Resty
//
//  Created by Imamori Daichi on 2014/11/22.
//  Copyright (c) 2014年 Kazuma Nagaya. All rights reserved.
//

#import "Toilet.h"
#import <Foundation/Foundation.h>
#import "Building.h"

@implementation Toilet{
    NSInteger width_;
    NSInteger height_;
    Building *owner_;
}

- (id) initWithSetting:(NSInteger)toiletID floor:(NSInteger)floor storeName:(NSString *)storeName latitude:(NSNumber *)latitude longitude:(NSNumber *)longitude sex:(Sex)sex{
    self = [super init];

    width_ = [[UIScreen mainScreen] bounds].size.width;
    height_ = [[UIScreen mainScreen] bounds].size.height;
    
    self.rooms = [NSMutableArray array];

    self.toiletID   = toiletID;
    self.floor      = floor;
    self.storeName  = storeName;
    self.latitude   = latitude;
    self.longitude  = longitude;
    self.sex        = sex;
    
    self.hasWashlet = false;
    self.hasMultipurpose = false;
    
    return self;
}

- (NSInteger) addRoom:(Room *)room{
    [self.rooms addObject:room];
    return self.rooms.count;
}

// トイレの利用率を計算するメソッド
- (NSNumber *) getUtillization{
    double sizeAllRoom = 0;
    double sizeUnavailableRoom = 0;
    for (Room *room in self.rooms) {
        sizeAllRoom++;
        if(!room.available){
            sizeUnavailableRoom++;
        }
    }
    return [[NSNumber alloc] initWithDouble:(sizeUnavailableRoom / sizeAllRoom)];
}



//---------------------------------------
// トイレリストのViewを生成
//---------------------------------------
- (UIView *) getToiletPane{
    CGRect rect = CGRectMake(0, 0, width_ * PANE_WIDTH_RATIO, height_ * PANE_HEIGHT_RATIO);
    UIView *pane = [[UIView alloc] initWithFrame:rect];
    pane.backgroundColor = [UIColor colorWithRed:255/255.0 green:100/255.0 blue:255/255.0 alpha:1.0];
    
    return pane;
}

- (void) setOwner:(Building *)building{
    owner_ = building;
}

- (Building *) getOwner{
    return owner_;
}

- (void) removeMarkder{
    if(!_marker){
        _marker.map = nil;
        _marker = nil;
    }
}

@end
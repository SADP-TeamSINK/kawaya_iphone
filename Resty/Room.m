//
//  Room.m
//  Resty
//
//  Created by Imamori Daichi on 2014/11/22.
//  Copyright (c) 2014年 Kazuma Nagaya. All rights reserved.
//

#import "Room.h"
#import <Foundation/Foundation.h>

@implementation Room : NSObject

- (id) initWithSetting:(NSInteger)roomID available:(BOOL)available washlet:(BOOL)washlet multipurpose:(BOOL)multipurpose{
    self = [super self];

    self.roomID = roomID;
    self.available = available;
    self.washlet = washlet;
    self.multipurpose = multipurpose;

    return self;
}
@end
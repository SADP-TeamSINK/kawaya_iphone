//
//  Room.h
//  Resty
//
//  Created by Imamori Daichi on 2014/11/22.
//  Copyright (c) 2014年 Kazuma Nagaya. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GoogleMaps/GoogleMaps.h>
#import "Const.m"


@interface Room : NSObject

@property (nonatomic) NSInteger roomID;
@property (nonatomic) BOOL available;
@property (nonatomic) BOOL washlet;
@property (nonatomic) BOOL multipurpose;

- (id) initWithSetting:(NSInteger)roomID available:(BOOL)available washlet:(BOOL)washlet multipurpose:(BOOL)multipurpose;
@end
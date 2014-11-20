//
//  Const.m
//  Resty
//
//  Created by Imamori Daichi on 2014/11/14.
//  Copyright (c) 2014年 Kazuma Nagaya. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM (NSInteger, Sex){
    MAN = 1,
    WOMAN,
    BOTH,
    OTHER
};

static NSString * const API_URL= @"http://apple.com";
static double const MAP_RATIO = 0.4;
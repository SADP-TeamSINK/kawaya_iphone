//
//  Const.m
//  Resty
//
//  Created by Imamori Daichi on 2014/11/14.
//  Copyright (c) 2014年 Kazuma Nagaya. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM (NSInteger, Sex){
    MAN = 0,
    WOMAN,
    BOTH,
    OTHER
};

static NSString * const API_URL= @"http://apple.com";

static double const FLOOR_MARGIN_RATIO = 0.03;

static double const MAP_RATIO = 0.3;
static double const PANE_WIDTH_RATIO = 0.8;
static double const PANE_HEIGHT_RATIO = 0.1;
static double const PANE_MARGIN_RATIO = 0.02;

static NSInteger const BUTTON_WIDTH = 30;
static NSInteger const BUTTON_HEIGHT = 30;
static NSInteger const BUTTON_NUMBER = 4;
static NSInteger const BUTTON_TOP_MARGIN = 10;
static NSInteger const BUTTON_BOTTOM_MARGIN = 10;

static NSInteger const LIST_TOP_BAR_HEIGHT = 25;



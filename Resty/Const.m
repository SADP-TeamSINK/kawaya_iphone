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
static double const PANE_HEIGHT_RATIO = 0.11;
static double const PANE_MARGIN_RATIO = 0.02;
static NSInteger const PANE_TOP_PADDING = 5;
static NSInteger const PANE_BOTTOM_PADDING = 5;
static NSInteger const PANE_LEFT_PADDING = 5;
static NSInteger const PANE_RIGHT_PADDING = 5;
static NSInteger const STORE_NAME_FONT_SIZE = 15;

static NSInteger const BUTTON_WIDTH = 30;
static NSInteger const BUTTON_HEIGHT = 30;
static NSInteger const BUTTON_NUMBER = 4;
static NSInteger const BUTTON_TOP_MARGIN = 10;
static NSInteger const BUTTON_BOTTOM_MARGIN = 10;

static NSInteger const LIST_TOP_BAR_HEIGHT = 25;

static double const GREEN_UTILLIZATION = 0.5;
static double const YELLOW_UTILLIZATION = 0.9;
static double const RED_UTILLIZATION = 1.0;
static NSInteger const UTILIIZATION_MARKER_LEFT_MARGIN = 10;

static NSInteger const WASHLET_MULTIPURPOSE_MARKER_MARGIN = 10;


// paneの内側の設定
static double const INNER_PANE_HEIGHT_RATIO = 0.7; //paneの高さとの比であることに注意
static double const INNER_PANE_WIDTH_RATIO = 0.9; //paneの幅との比であることに注意
static double const INNER_PANE_WIDTH_BIAS = 0.7;

static NSInteger const INNER_PANE_BORDER = 2;

// utillization markerのはみ出し具合の設定
static double const UTILLIZATION_MARKER_TOP_OUT = 0.3;
static double const UTILLIZATION_MARKER_LEFT_OUT = 0.3;

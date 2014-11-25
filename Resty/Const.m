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

static double const FLOOR_MARGIN_RATIO = 0.04;

static double const MAP_RATIO = 0.3;
static double const PANE_WIDTH_RATIO = 1;
static double const PANE_HEIGHT_RATIO = 0.12;
static double const PANE_MARGIN_RATIO = 0.02;
static NSInteger const PANE_TOP_PADDING = 5;
static NSInteger const PANE_BOTTOM_PADDING = 5;
static NSInteger const PANE_LEFT_PADDING = 5;
static NSInteger const PANE_RIGHT_PADDING = 10;
static NSInteger const STORE_NAME_FONT_SIZE = 17;

static NSInteger const BUTTON_SIZE = 50;
static NSInteger const BUTTON_NUMBER = 4;
static NSInteger const BUTTON_TOP_MARGIN = 5;
static NSInteger const BUTTON_BOTTOM_MARGIN = 5;
static double const SEX_BUTTON_WIDTH_HEIGHT_RATIO = 1.665;
static NSInteger const UPDATE_BUTTON_SIZE = 50;
static double const BUTTON_LEFT_MARGIN_RATIO = 1.5;

static NSInteger const LIST_TOP_BAR_HEIGHT = 25;

static double const GREEN_UTILLIZATION = 0.5;
static double const YELLOW_UTILLIZATION = 0.9;
static double const RED_UTILLIZATION = 1.0;



// paneの内側の設定
static double const INNER_PANE_HEIGHT_RATIO = 0.8; //paneの高さとの比であることに注意
static double const INNER_PANE_WIDTH_RATIO = 0.9; //paneの幅との比であることに注意
static double const INNER_PANE_WIDTH_BIAS = 0.7;
static double const INNER_PANE_HEIGHT_BIAS = 0.8;
static NSInteger const INNER_PANE_BORDER = 2;

static double const INNER_PANE_STORE_NAME_LEFT_MARGIN_RATIO = 0.02;//inner paneのwidthとの比であることに注意
static double const INNER_PANE_STORE_NAME_WIDTH_RATIO = 0.5;

// utillization markerのはみ出し具合の設定
static double const UTILLIZATION_MARKER_TOP_OUT = 0.3;
static double const UTILLIZATION_MARKER_LEFT_OUT = 0.3;
static NSInteger const UTILIIZATION_MARKER_LEFT_MARGIN = 10;
static NSInteger const UTILLIZATION_MARKER_SIZE = 35;

static NSInteger const WASHLET_MARKER_SIZE = 25;
static NSInteger const MULTIPURPOSE_MARKER_SIZE = 25;
static NSInteger const WASHLET_MULTIPURPOSE_MARKER_MARGIN = 5;

static NSInteger const HEADER_HEIGHT = 40;
static NSInteger const HEADER_LEFT_MARGIN = 5;
static NSInteger const HEADER_FONT_SIZE = 20;
static double const HEADER_TOP_MARGIN_RATIO = 0.8;

// mapMarkerの設定
static NSInteger const MAP_MARKER_SIZE = 40;

static double const BUILDING_NAME_WIDTH_RATIO = 0.4;
static double const BUILDING_NAME_RIGHT_MARGIN = 10;
static NSInteger const BUILDING_NAME_FONT_SIZE = 10;
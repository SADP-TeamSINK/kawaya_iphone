//
//  Color.m
//  Resty
//
//  Created by Imamori Daichi on 2014/11/24.
//  Copyright (c) 2014年 Kazuma Nagaya. All rights reserved.
//


#import "Color.h"

@implementation Color

- (id) init{
    self = [super init];
    _green = [UIColor colorWithRed:141/255.0 green:191/255.0 blue:156/255.0 alpha:1.0];
    _darkGreen = [UIColor colorWithRed:75/255.0 green:163/255.0 blue:106/255.0 alpha:1.0];
    _yellow = [UIColor colorWithRed:185/255.0 green:195/255.0 blue:148/255.0 alpha:1.0];
    _darkYellow = [UIColor colorWithRed:156/255.0 green:171/255.0 blue:93/255.0 alpha:1.0];
    _red = [UIColor colorWithRed:192/255.0 green:148/255.0 blue:148/255.0 alpha:1.0];
    _darkRed = [UIColor colorWithRed:164/255.0 green:91/255.0 blue:95/255.0 alpha:1.0];
    _gray = [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1.0];
    _white = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0];
    _darkGray = [UIColor colorWithRed:110/255.0 green:110/255.0 blue:110/255.0 alpha:1.0];
    //_darkGray = _gray;
    return self;
}

@end

// 色の設定
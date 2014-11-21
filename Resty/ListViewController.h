//
//  ListViewController.h
//  Resty
//
//  Created by Imamori Daichi on 2014/11/21.
//  Copyright (c) 2014年 Kazuma Nagaya. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GoogleMaps/GoogleMaps.h>
#import "MapViewController.h"
#import "Const.m"


@interface ListViewController : NSObject <GMSMapViewDelegate>

- (id) init;
- (UIView *) getListView;
- (void) onScreen;

@end
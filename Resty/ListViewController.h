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
#import "Building.h"
#import "ToiletTableViewCell.h"
#import "Color.h"

@interface ListViewController : UITableViewController <GMSMapViewDelegate, UITableViewDelegate, UITableViewDataSource>
- (id) init;
- (UIView *) getListView;
- (void) onScreen;
- (void) offScreen;
- (void) listUpToilets:(Building *)building;
@end
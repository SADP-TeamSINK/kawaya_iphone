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
@property (nonatomic) BOOL isOn;
- (id) initWithForState:(Sex)sex washlet:(BOOL)washlet multipurpose:(BOOL)multipurpose;
- (UIView *) getListView;
- (void) onScreen;
- (void) offScreen;
- (void) listUpToilets:(Building *)building;
- (UITableViewCell *) makeCustomCell:(NSString *)cellIdentifier indexPath:(NSIndexPath *)indexPath tableView:(UITableView *)tableView;
- (void) removeToiletsMarker;
- (void) markToilets;

- (void) registerMapView:(GMSMapView *)mapView;

- (void) updateListForState:(Sex)sex washlet:(BOOL)washlet multipurpose:(BOOL)multipurpose;

- (void) filteringToilts;

@end
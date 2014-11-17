//
//  MapController.m
//  Resty
//
//  Created by Imamori Daichi on 2014/11/17.
//  Copyright (c) 2014年 Kazuma Nagaya. All rights reserved.
//

#import "MapController.h"
#import <Foundation/Foundation.h>


@implementation MapController : NSObject
//MapViewController *mapViewController_;
GMSMapView *mapView_;
int height_;
int width_;

- (id) init{
    self = [super self];
    //画面サイズ取得
    height_ = [[UIScreen mainScreen] bounds].size.height;
    width_ = [[UIScreen mainScreen] bounds].size.width;
    return self;
}

- (GMSMapView *) makeMapView{
    
    // カメラ作成
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:35.026111
                                                            longitude:135.780833
                                                                 zoom:17];
    mapView_ = [GMSMapView mapWithFrame:CGRectMake(0, 0, width_, height_) camera:camera];
    mapView_.myLocationEnabled = YES;
    //mapView_.settings.myLocationButton  = YES;
    
    
    // 画面左上の座標を取得
    CGPoint topLeftPoint = CGPointMake(0, 0);
    CLLocationCoordinate2D topLeftLocation =
    [mapView_.projection coordinateForPoint: topLeftPoint];
    
    // 画面右下の座標を取得
    CGPoint bottomRightPoint =
    CGPointMake(mapView_.frame.size.width, mapView_.frame.size.height);
    CLLocationCoordinate2D bottomRightLocation =
    [mapView_.projection coordinateForPoint: bottomRightPoint];
    
    // 画面左上にピンを設置
    GMSMarker *topLeftMarker = [[GMSMarker alloc] init];
    topLeftMarker.position = topLeftLocation;
    topLeftMarker.title = @"Left top";
    topLeftMarker.snippet = @"Japan";
    topLeftMarker.map = mapView_;
    
    // 画面右上にピンを設置
    GMSMarker *bottomRightMarker = [[GMSMarker alloc] init];
    bottomRightMarker.position = bottomRightLocation;
    bottomRightMarker.title = @"Bottom right";
    bottomRightMarker.snippet = @"Japan";
    bottomRightMarker.map = mapView_;
    
    return mapView_;
}
@end


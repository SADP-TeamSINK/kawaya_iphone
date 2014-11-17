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
    
    
    // 京大にピンを設置
    GMSMarker *marker = [[GMSMarker alloc] init];
    marker.position = CLLocationCoordinate2DMake(35.026111, 135.780833);
    marker.title = @"kyoto University";
    marker.snippet = @"Japan";
    marker.map = mapView_;
    

    
    // 画面左上にピンを設置
    GMSMarker *topLeftMarker = [[GMSMarker alloc] init];
    topLeftMarker.position = [self getTopLeftCoordinate];
    topLeftMarker.title = @"Left top";
    topLeftMarker.snippet = @"Japan";
    topLeftMarker.map = mapView_;
    
    // 画面右上にピンを設置
    GMSMarker *bottomRightMarker = [[GMSMarker alloc] init];
    bottomRightMarker.position = [self getBottomRightCoordinate];
    bottomRightMarker.title = @"Bottom right";
    bottomRightMarker.snippet = @"Japan";
    bottomRightMarker.map = mapView_;
    
    // delegateにこのMapControllerを設定
    mapView_.delegate = self;
    
    return mapView_;
}

/**
 * 地図上の特定座標をタップした際に通知される。
 * マーカーをタップした際には通知されない。
 */
- (void)mapView:(GMSMapView *)mapVie didTapAtCoordinate:(CLLocationCoordinate2D)coordinate {
    NSLog(@"didTapAtCoordinate %f,%f", coordinate.latitude, coordinate.longitude);
}


/**
 * 地図の表示領域（カメラ）が変更された際に通知される。
 * アニメーション中は途中の表示領域が通知されたない場合があるが、最終的な位置で通知される。
 */
- (void)mapView:(GMSMapView *)mapView didChangeCameraPosition:(GMSCameraPosition *)position {
    NSLog(@"didChangeCameraPosition %f,%f", position.target.latitude, position.target.longitude);
}


/**
 * 地図上の特定の座標を長押しした際に通知される。
 */
- (void)mapView:(GMSMapView *)mapView didLongPressAtCoordinate:(CLLocationCoordinate2D)coordinate {
    NSLog(@"didLongPressAtCoordinate %f,%f", coordinate.latitude, coordinate.longitude);
}

/**
 * マーカーがタップされた際に通知される。
 * NOを返すと通常の動作であるマーカーウィンドウを表示する。
 * YESを返すとマーカーウィンドウを表示しない。
 */
- (BOOL)mapView:(GMSMapView *)mapView didTapMarker:(id)marker {
    NSLog(@"didTapMarker title:%@, snippet:%@", [marker title], [marker snippet]);
    return NO;
}

/**
 * マーカーのウィンドウをタップした際に通知される。
 */
- (void)mapView:(GMSMapView *)mapView didTapInfoWindowOfMarker:(id)marker {
    NSLog(@"didTapInfoWindowOfMarker title:%@, snippet:%@", [marker title], [marker snippet]);
}

/**
 * マーカーがタップされて、ウィンドウが表示されるタイミングで通知される。
 * 独自のウィンドウを返すことができる。
 */
- (UIView *)mapView:(GMSMapView *)mapView markerInfoWindow:(id)marker {
    UIView *mWindow = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    mWindow.backgroundColor = [UIColor redColor];
    return mWindow;
}


- (CLLocationCoordinate2D)getTopLeftCoordinate{
    // 画面左上の座標を取得
    CGPoint topLeftPoint = CGPointMake(0, 0);
    CLLocationCoordinate2D topLeftLocation =
    [mapView_.projection coordinateForPoint: topLeftPoint];
    
    return topLeftLocation;
}

- (CLLocationCoordinate2D)getBottomRightCoordinate{
    // 画面右下の座標を取得
    CGPoint bottomRightPoint =
    CGPointMake(mapView_.frame.size.width, mapView_.frame.size.height);
    CLLocationCoordinate2D bottomRightLocation =
    [mapView_.projection coordinateForPoint: bottomRightPoint];
    
    return bottomRightLocation;
}


@end


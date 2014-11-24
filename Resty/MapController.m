//
//  MapController.m
//  Resty
//
//  Created by Imamori Daichi on 2014/11/17.
//  Copyright (c) 2014年 Kazuma Nagaya. All rights reserved.
//

#import "MapController.h"
#import <Foundation/Foundation.h>


@implementation MapController {
    GMSMapView *mapView_;
    NSInteger height_;
    NSInteger width_;
    APIController *aPIController_;
    dispatch_queue_t main_queue_;
    dispatch_queue_t sub_queue_;
    CGRect windowRect_;
    ListViewController *listViewContoroller_;
}

- (id) init{
    self = [super init];
    
    aPIController_ = [[APIController alloc] initWithUrl:[NSURL URLWithString:API_URL]];
    //画面サイズ取得
    height_ = [[UIScreen mainScreen] bounds].size.height;
    width_ = [[UIScreen mainScreen] bounds].size.width;

    // ListViewControllerの初期化
    listViewContoroller_ = [[ListViewController alloc] init];
    
    // マルチスレッド処理の準備
    // メインスレッド用で処理を実行するキューを定義する
    main_queue_ = dispatch_get_main_queue();

    // サブスレッドで実行するキューを定義する
    sub_queue_ = dispatch_queue_create("sadp.team.sink.toiletApi", 0);
    
    
    // MapViewの作成
    mapView_ = [self makeMapView];
    
    mapView_.clipsToBounds = NO;
    
    // MapViewにListViewを追加
    [mapView_ addSubview:[listViewContoroller_ getListView]];
    
    
    // ----------------------------------------------------
    // ダミーデータの読み込み
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"dammy" ofType:@"json"];
    NSFileHandle *fileHandle = [NSFileHandle fileHandleForReadingAtPath:filePath];
    NSData *dammyJsonData = [fileHandle readDataToEndOfFile];
    
    NSString *dammyJsonString = [[NSString alloc] initWithData:dammyJsonData encoding:NSUTF8StringEncoding];
    NSMutableArray *buildings = [Building parseBuildingFromJson:dammyJsonString];
    
    // dammy json からパースした建物オブジェクトをマップ上にマーキング
    // TODO: フィルタリングした結果を表示
    [self markBuildings:buildings];

    // ----------------------------------------------------
    
    return self;
}

- (GMSMapView *) makeMapView{
    
    // カメラ作成
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:35.026111
                                                            longitude:135.780833
                                                                 zoom:17];
    mapView_ = [GMSMapView mapWithFrame:CGRectMake(0, 0, width_, height_) camera:camera];
    mapView_.myLocationEnabled = YES;
    
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

- (GMSMapView *) getMapView{
    return mapView_;
}

/**
 * 地図上の特定座標をタップした際に通知される。
 * マーカーをタップした際には通知されない。
 */
- (void)mapView:(GMSMapView *)mapVie didTapAtCoordinate:(CLLocationCoordinate2D)coordinate {
    NSLog(@"didTapAtCoordinate %f,%f", coordinate.latitude, coordinate.longitude);

    // ListViewを収納するアニメーション
    [UIView animateWithDuration:0.1f animations:^{
        [listViewContoroller_ offScreen];
        mapView_.frame = CGRectMake(0, 0, width_, height_);
    } completion:^(BOOL finished){
    }];
    
    // ズームを元に戻す
    [mapView_ animateToZoom:17.0f];


    NSLog(@"タップした場所: lati: %f, long: %f", coordinate.latitude, coordinate.longitude);
}


/**
 * 地図の表示領域（カメラ）が変更された際に通知される。
 * アニメーション中は途中の表示領域が通知されたない場合があるが、最終的な位置で通知される。
 */
- (void)mapView:(GMSMapView *)mapView didChangeCameraPosition:(GMSCameraPosition *)position {
    NSLog(@"didChangeCameraPosition %f,%f", position.target.latitude, position.target.longitude);
    [mapView_ bringSubviewToFront:[listViewContoroller_ getListView]];
    

    // 縮小しすぎている場合はAPIを叩かない
    if (mapView.camera.zoom < 15) return;

    CLLocationCoordinate2D topLeftCoordinate = [self getTopLeftCoordinate];
    CLLocationCoordinate2D bottomRightCoordinate = [self getBottomRightCoordinate];

    // 並列処理開始
    dispatch_async(sub_queue_, ^{
        //ここはサブスレッド
        NSString *json = [aPIController_ callFromCoordinate:topLeftCoordinate  BottomRightCoordinate:bottomRightCoordinate];

        dispatch_async(main_queue_, ^{
            // ここはメインスレッド
            // APIを叩いたあとの処理をここへ記述
            NSLog(@"API responset");
        });
    });
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
    
    // 対応する建物オブジェクト
    Building *building = (Building *)((GMSMarker *)marker).userData;
    
    // TODO: マーカーがすべて入るようにズーム
    float zoomLevel = 18;
    
    // ListViewを下から出すアニメーション
    [UIView animateWithDuration:0.0f animations:^{
        mapView_.frame = CGRectMake(0, 0, width_, height_ * MAP_RATIO);
        [listViewContoroller_ onScreen];
    } completion:^(BOOL finished){
        // mapViewを縮小してから建物にフォーカス
        [mapView_ animateToCameraPosition:[GMSCameraPosition cameraWithLatitude:building.latitude.doubleValue longitude:building.longitude.doubleValue zoom:zoomLevel]];
    }];

    NSLog(@"Utillization: %@", [building getUtillization]);
    
    

    

    // タップされたマーカに対応している建物のもつトイレを，ListViewにリストアップ
    [listViewContoroller_ listUpToilets:building];
    
    
    return YES;
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
    return nil;
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

- (double) getLatitudeGapOnScreen{
    CLLocationCoordinate2D topLeft = [self getTopLeftCoordinate];
    CLLocationCoordinate2D bottomRight = [self getBottomRightCoordinate];
    return topLeft.latitude - bottomRight.latitude;
}

- (void) markBuildings:(NSMutableArray *)buildings{
    for (Building *building in buildings) {
        CLLocationCoordinate2D position = CLLocationCoordinate2DMake(building.latitude.doubleValue, building.longitude.doubleValue);
        GMSMarker *marker = [GMSMarker markerWithPosition:position];
        marker.title = building.name;
        marker.map = mapView_;
        marker.userData = building;
    }
}

@end


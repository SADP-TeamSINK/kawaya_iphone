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
    //ListViewController *_listViewController;
    NSMutableArray *buildings_;
    FilteringButtonController *filteringButtonController_;
    Sex stateOfSex;
    Boolean stateOfWashlet;
    Boolean stateOfMultipurpose;
    UIImageView *utillizationImageView;
    
}

- (id) initWithFilteringButtonController:(FilteringButtonController *)filteringButtonController{
    self = [super init];
    
    filteringButtonController_ = filteringButtonController;

    aPIController_ = [[APIController alloc] initWithUrl:[NSURL URLWithString:API_URL]];
    
    //画面サイズ取得
    height_ = [[UIScreen mainScreen] bounds].size.height;
    width_ = [[UIScreen mainScreen] bounds].size.width;

    // 建物オブジェクト群を格納する配列の確保
    buildings_ = [NSMutableArray array];
    
    
    // ListViewControllerの初期化
    _listViewController = [[ListViewController alloc] initWithForState:filteringButtonController_.stateOfSex washlet:filteringButtonController_.stateOfWashlet multipurpose:filteringButtonController_.stateOfMultipurpose];
    _listViewController.mapController = self;
    
    // マルチスレッド処理の準備
    // メインスレッド用で処理を実行するキューを定義する
    main_queue_ = dispatch_get_main_queue();

    // サブスレッドで実行するキューを定義する
    sub_queue_ = dispatch_queue_create("sadp.team.sink.toiletApi", 0);
    
    
    // MapViewの作成
    mapView_ = [self makeMapView];
    mapView_.frame = CGRectMake(0, 0, width_, height_ - BUTTON_BOTTOM_MARGIN - BUTTON_TOP_MARGIN - BUTTON_SIZE);
    
    mapView_.clipsToBounds = NO;
    
    
    // MapViewにListViewを追加
    [mapView_ addSubview:[_listViewController getListView]];
    [_listViewController registerMapView:mapView_];
    
    
    // 混雑度の説明
    
    UIImage *utillizationImage = [UIImage imageNamed:@"utillization.png"];
    double scale = utillizationImage.size.height / utillizationImage.size.width;
    utillizationImageView = [[UIImageView alloc] initWithImage:utillizationImage];
    utillizationImageView.frame = CGRectMake(UTILLIZATION_EXPLANATION_IMAGE_LEFT_MARGIN,
                                             UTILLIZATION_EXPLANATION_IMAGE_TOP_MARGIN,
                                             UTILLIZATION_EXPLANATION_IMAGE_WIDTH,
                                             UTILLIZATION_EXPLANATION_IMAGE_WIDTH * scale);
    [mapView_ addSubview:utillizationImageView];
    
    /*
    // ----------------------------------------------------
    // ダミーデータの読み込み
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"dammy" ofType:@"json"];
    NSFileHandle *fileHandle = [NSFileHandle fileHandleForReadingAtPath:filePath];
    NSData *dammyJsonData = [fileHandle readDataToEndOfFile];
    
    NSString *dammyJsonString = [[NSString alloc] initWithData:dammyJsonData encoding:NSUTF8StringEncoding];
    NSMutableArray *buildings = [Building parseBuildingFromJson:dammyJsonString];
    
    //フィルタリング
    NSLog(@"buildingsの初期配列:%@",buildings);
    [self markBuildings:buildings];
    [buildings_ addObjectsFromArray:buildings];
    // ----------------------------------------------------
    */
    
    return self;
}

- (GMSMapView *) makeMapView{
    
    // カメラ作成
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:35.026111
                                                            longitude:135.780833
                                                                 zoom:17];
    mapView_ = [GMSMapView mapWithFrame:CGRectMake(0, 0, width_, height_) camera:camera];
    mapView_.myLocationEnabled = YES;

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

    [self offList];
    NSLog(@"タップした場所: lati: %f, long: %f", coordinate.latitude, coordinate.longitude);
}


/**
 * 地図の表示領域（カメラ）が変更された際に通知される。
 * アニメーション中は途中の表示領域が通知されたない場合があるが、最終的な位置で通知される。
 */
- (void)mapView:(GMSMapView *)mapView didChangeCameraPosition:(GMSCameraPosition *)position {
    //NSLog(@"didChangeCameraPosition %f,%f", position.target.latitude, position.target.longitude);
    [mapView_ bringSubviewToFront:[_listViewController getListView]];
    
    [self callApi:mapView_];

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
    
    if([((GMSMarker *)marker).userData isKindOfClass:[Toilet class]]){
        
        return YES;
    }
    
    // 対応する建物オブジェクト
    Building *building = (Building *)((GMSMarker *)marker).userData;
    
    // TODO: マーカーがすべて入るようにズーム
    float zoomLevel = 18;
    
    // マーカーの位置から，中心に来るべき座標を計算する．
    // mapは画面の "縦サイズ * MAP_RATIO" の表示領域になるので，
    // その表示領域の中心にマーカーの座標が来るように計算した．
    [self animateTopScreen:((GMSMarker *)marker).position zoomLevel:zoomLevel];

    [self onList];
    NSLog(@"Utillization: %@", [building getUtillizationWithState:filteringButtonController_.stateOfSex washlet:filteringButtonController_.stateOfWashlet multipurpose:filteringButtonController_.stateOfMultipurpose]);

    // タップされたマーカに対応している建物のもつトイレを，ListViewにリストアップ
    // その際，すべてのマーカを一旦クリア
    [mapView_ clear];
    [self markToilets:building];
    [_listViewController listUpToilets:building];
    [self updateListForState];
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

- (CLLocationCoordinate2D)getBottomLeftCoordinate{
    // 画面右下の座標を取得
    CGPoint bottomLeftPoint =
    CGPointMake(0, mapView_.frame.size.height);
    CLLocationCoordinate2D bottomLeftLocation =
    [mapView_.projection coordinateForPoint: bottomLeftPoint];
    
    return bottomLeftLocation;
}

- (double) getLatitudeGapOnScreen{
    CLLocationCoordinate2D topLeft = [self getTopLeftCoordinate];
    CLLocationCoordinate2D bottomLeft = [self getBottomLeftCoordinate];
    return sqrt(pow(topLeft.latitude - bottomLeft.latitude, 2) + pow(topLeft.longitude - bottomLeft.longitude, 2));
}

- (void) markBuildings:(NSMutableArray *)buildings{
    if(_listViewController.isOn) return;
    for (Building *building in buildings) {
        // 建物がフィルタリングに該当するトイレを持っていない場合はcontinue
        if(![building hasFilteringToilet:filteringButtonController_.stateOfSex washlet:filteringButtonController_.stateOfWashlet multipurpose:filteringButtonController_.stateOfMultipurpose]){ continue; }

        CLLocationCoordinate2D position = CLLocationCoordinate2DMake(building.latitude.doubleValue, building.longitude.doubleValue);
        GMSMarker *marker = [GMSMarker markerWithPosition:position];
        marker.title = building.name;
        marker.map = mapView_;
        marker.userData = building;
        marker.icon = [self getUIImageForMarker:[building getUtillizationWithState:filteringButtonController_.stateOfSex washlet:filteringButtonController_.stateOfWashlet multipurpose:filteringButtonController_.stateOfMultipurpose]];
        marker.zIndex = (int)(1.0 - [building getUtillizationWithState:filteringButtonController_.stateOfSex washlet:filteringButtonController_.stateOfWashlet multipurpose:filteringButtonController_.stateOfMultipurpose].doubleValue);
        building.marker = marker;
    }
}

- (void) markToilets:(Building *)building{
    for (NSMutableArray *toiletsByFloor in building.toilets) {
        for (Toilet *toilet in toiletsByFloor) {
            CLLocationCoordinate2D position = CLLocationCoordinate2DMake(toilet.latitude.doubleValue, toilet.longitude.doubleValue);
            GMSMarker *marker = [GMSMarker markerWithPosition:position];
            marker.title = toilet.storeName;
            //marker.map = mapView_;
            marker.userData = toilet;
            NSNumber *utillization = [toilet getUtillizationWithState:filteringButtonController_.stateOfWashlet multipurpose:filteringButtonController_.stateOfMultipurpose];
            marker.icon = [self getUIImageForMarker:utillization];
            marker.zIndex = (int)(1.0 - utillization.doubleValue);
            toilet.marker = marker;
        }
    }
}

- (void) clearToilets:(Building *)building{
    for (NSMutableArray *toiletsByFloor in building.toilets) {
        for (Toilet *toilet in toiletsByFloor) {
            [toilet removeMarkder];
        }
    }
}

- (UIImage *) getUIImageForMarker:(NSNumber *)utillization{
    UIImage *markerImage;
    
    if(utillization.doubleValue < GREEN_UTILLIZATION){
        markerImage = [UIImage imageNamed:@"greenMarkerSmall.png"];
        
    }else if(utillization.doubleValue < YELLOW_UTILLIZATION){
        markerImage = [UIImage imageNamed:@"yellowMarkerSmall.png"];
        
    }else{
        markerImage = [UIImage imageNamed:@"redMarkerSmall.png"];
    }
    
    CGRect rect = CGRectMake(0, 0, MAP_MARKER_SIZE, MAP_MARKER_SIZE * markerImage.size.height / markerImage.size.width);
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0.0);
    [markerImage drawInRect:rect];
    markerImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    
    return markerImage;
}


- (void) updateAllBuildingMarkerForState{
   for (Building *building in buildings_) {
       GMSMarker *marker = building.marker;
       NSNumber *utillization = [building getUtillizationWithState:filteringButtonController_.stateOfSex washlet:filteringButtonController_.stateOfWashlet multipurpose:filteringButtonController_.stateOfMultipurpose];
       marker.icon = [self getUIImageForMarker:utillization];
       marker.zIndex = (int)(1.0 - utillization.doubleValue);
       building.marker = marker;
    }
    [mapView_ clear];
    [self markBuildings:buildings_];
}

- (void) updateListForState{
    if(_listViewController.isOn){
        [_listViewController updateListForState:filteringButtonController_.stateOfSex washlet:filteringButtonController_.stateOfWashlet multipurpose:filteringButtonController_.stateOfMultipurpose];
    }
}

- (void) updateBuildings{
    if(!_listViewController.isOn){
        [mapView_ clear];
    }
    [buildings_ removeAllObjects];
    [aPIController_ clearMeshCash];
    [self callApi:mapView_];
}

- (void) callApi:(GMSMapView *)mapView{
    // 縮小しすぎている場合はAPIを叩かない
    if (mapView.camera.zoom < ZOOM_LIMIT) return;
    
    CLLocationCoordinate2D topLeftCoordinate = [self getTopLeftCoordinate];
    CLLocationCoordinate2D bottomRightCoordinate = [self getBottomRightCoordinate];
    
    // 並列処理開始
    dispatch_async(sub_queue_, ^{
        //ここはサブスレッド
        NSString *json = [aPIController_ callFromCoordinate:topLeftCoordinate  BottomRightCoordinate:bottomRightCoordinate];
        
        dispatch_async(main_queue_, ^{
            // ここはメインスレッド
            // APIを叩いたあとの処理をここへ記述
            if([json isEqualToString:@"{}"]){ return ;}
            NSLog(@"%@", json);
            NSMutableArray *buildings = [Building parseBuildingFromJson:json];
            [buildings_ addObjectsFromArray:buildings];
            [self markBuildings:buildings];
        });
    });
}

- (void) animateTopScreen:(CLLocationCoordinate2D)location zoomLevel:(double)zoomLevel{
    CLLocationCoordinate2D center;
    center.latitude = location.latitude
    - (([self getLatitudeGapOnScreen]
        * (0.5f - MAP_RATIO/2.0f)) * pow(2, mapView_.camera.zoom - zoomLevel));
    center.longitude = location.longitude;
    [mapView_ animateToCameraPosition: [GMSCameraPosition
                                        cameraWithTarget:center zoom:zoomLevel]];
}

- (void) onList{
    // ListViewを下から出すアニメーション
    [UIView animateWithDuration:0.4f animations:^{
        //mapView_.frame = CGRectMake(0, 0, width_, height_ * MAP_RATIO);
        [_listViewController onScreen];
        self.listHeaderHandle.frame = CGRectMake(0, height_ * (MAP_RATIO), width_, LIST_TOP_BAR_HEIGHT);
    } completion:^(BOOL finished){
    }];
    [utillizationImageView removeFromSuperview];
}

- (void) offList{
    // ListViewを収納するアニメーション
    [UIView animateWithDuration:0.5f animations:^{
        [_listViewController offScreen];
        self.listHeaderHandle.frame = CGRectMake(0, height_, width_, LIST_TOP_BAR_HEIGHT);
    } completion:^(BOOL finished){
    }];
    
    // ズームを元に戻す
    [mapView_ animateToZoom:17.0f];
    
    // 建物をリマーク
    [mapView_ clear];
    [self markBuildings:buildings_];
    
    if(![utillizationImageView isDescendantOfView:mapView_]){
        [mapView_ addSubview:utillizationImageView];
    }
    
}


@end


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
    ListViewController *listViewController_;
    NSMutableArray *buildings_;
    FilteringButtonController *filteringButtonController_;
    Sex stateOfSex;
    Boolean stateOfWashlet;
    Boolean stateOfMultipurpose;
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
    listViewController_ = [[ListViewController alloc] init];
    
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
    [mapView_ addSubview:[listViewController_ getListView]];
    
    
    // ----------------------------------------------------
    // ダミーデータの読み込み
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"dammy" ofType:@"json"];
    NSFileHandle *fileHandle = [NSFileHandle fileHandleForReadingAtPath:filePath];
    NSData *dammyJsonData = [fileHandle readDataToEndOfFile];
    
    NSString *dammyJsonString = [[NSString alloc] initWithData:dammyJsonData encoding:NSUTF8StringEncoding];
    NSMutableArray *buildings = [Building parseBuildingFromJson:dammyJsonString];
    
    // dammy json からパースした建物オブジェクトをマップ上にマーキング
    
    //フィルタリング
    NSLog(@"buildingsの初期配列:%@",buildings);
    buildings = [self filtering:buildings stateOfSex:(Sex)stateOfSex stateOfWashlet:(BOOL)stateOfWashlet stateOfMultipurpose:(BOOL)stateOfMultipurpose]; //filteringメソッドにボタン状態を渡す
    
    //フィルタリングした結果を表示
    [self markBuildings:buildings];
    [buildings_ addObjectsFromArray:buildings];
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
        [listViewController_ offScreen];
    } completion:^(BOOL finished){
    }];
    
    // ズームを元に戻す
    [mapView_ animateToZoom:17.0f];
    
    // 建物をリマーク
    [mapView_ clear];
    [self markBuildings:buildings_];
    NSLog(@"タップした場所: lati: %f, long: %f", coordinate.latitude, coordinate.longitude);
}


/**
 * 地図の表示領域（カメラ）が変更された際に通知される。
 * アニメーション中は途中の表示領域が通知されたない場合があるが、最終的な位置で通知される。
 */
- (void)mapView:(GMSMapView *)mapView didChangeCameraPosition:(GMSCameraPosition *)position {
    NSLog(@"didChangeCameraPosition %f,%f", position.target.latitude, position.target.longitude);
    [mapView_ bringSubviewToFront:[listViewController_ getListView]];
    

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
    CLLocationCoordinate2D center;
    center.latitude = ((GMSMarker *)marker).position.latitude
                      - (([self getLatitudeGapOnScreen]
                      * (0.5f - MAP_RATIO/2.0f)) * pow(2, mapView_.camera.zoom - zoomLevel));
    center.longitude = ((GMSMarker *)marker).position.longitude;
    [mapView_ animateToCameraPosition: [GMSCameraPosition
                                        cameraWithTarget:center zoom:zoomLevel]];

    // ListViewを下から出すアニメーション
    [UIView animateWithDuration:0.1f animations:^{
        //mapView_.frame = CGRectMake(0, 0, width_, height_ * MAP_RATIO);
        [listViewController_ onScreen];
    } completion:^(BOOL finished){
    }];

    NSLog(@"Utillization: %@", [building getUtillization]);

    // タップされたマーカに対応している建物のもつトイレを，ListViewにリストアップ
    // その際，すべてのマーカを一旦クリア
    [mapView_ clear];
    [listViewController_ listUpToilets:building];
    [self markToilets:building];
    
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

//フィルタリングメソッド
- (NSMutableArray *) filtering:(NSMutableArray *)buildings stateOfSex:(Sex)sex stateOfWashlet:(BOOL)washlet stateOfMultipurpose:(BOOL)multipurpose{
    
    //初期状態のチェック
    NSLog(@"stateOfSex初期値:%@", sex==0 ? @"男(0)" : @"女(1)"); //>>男
    NSLog(@"stateOfWash初期値:%@", washlet ? @"true" : @"false"); //>>false
    NSLog(@"stateOfMultipurpose初期値:%@", multipurpose ? @"true" : @"false"); //>>false
    
    //デバッグ用パラメータ
    sex = 0;
    washlet = true;
    multipurpose = false;
    
    //フィルタリング結果の配列を定義
    NSMutableArray *filteringResultBuildings = [NSMutableArray array];
    
    //各々の要素が存在する場合のフラグを定義
    BOOL sexFrag;
    BOOL washletFrag;
    BOOL multipurposeFrag;
    BOOL buildingFrag;
    
    //ボタン状態に分けてフィルタリング
    if(sex==0 && washlet==false && multipurpose==false){//男 ∧ ウ× ∧多×
        for(Building *building in buildings){
            sexFrag=false; //建物ごとに初期化
            buildingFrag=false;
            for (NSMutableArray *toiletByFloor in building.toilets) {
                for (Toilet *toilet in toiletByFloor) {
                    if(toilet.sex==0){ //条件は性別のみ
                        //[filteringResultBuildings addObject:toilet]; //トイレ位置を追加 > Thread1:signal SIGABRT
                        sexFrag=true; //フラグを立てる
                        buildingFrag=true;
                    }
                }
            }
            if(sexFrag==true && buildingFrag==true){ //男性トイレがある場合その建物を追加
                [filteringResultBuildings addObject:building]; //建物位置を追加
            }
        }
    }
    if(sex==1 && washlet==false && multipurpose==false){//女 ∧ ウ× ∧ 多×
        for(Building *building in buildings){
            sexFrag=false;
            buildingFrag=false;
            for (NSMutableArray *toiletByFloor in building.toilets) {
                for (Toilet *toilet in toiletByFloor) {
                    if(toilet.sex==1){
                        //[filteringResultBuildings addObject:toilet];
                        sexFrag=true;
                        buildingFrag=true;
                    }
                }
            }
            if(sexFrag==true && buildingFrag==true){ //女性トイレがある場合その建物を追加
                [filteringResultBuildings addObject:building];
            }
        }
    }
    if(sex==0 && washlet==true){  //男 ∧ ウ◯ ∧ (多◯ or ×)
        for(Building *building in buildings){
            washletFrag=false;
            buildingFrag=false;
            for (NSMutableArray *toiletByFloor in building.toilets) {
                for (Toilet *toilet in toiletByFloor) {
                    if(toilet.sex==0 && toilet.hasWashlet==true){
                        //[filteringResultBuildings addObject:toilet];
                        washletFrag=true; //ウォシュレットフラグを立てる
                        buildingFrag=true;
                    }
                }
            }
            if(washletFrag==true && buildingFrag==true){ //男性トイレかつウォシュレットがある場合その建物を追加
                [filteringResultBuildings addObject:building];
            }
        }
    }
    if(sex==1 && washlet==true){  //女 ∧ ウ◯ ∧ (多◯ or ×)
        for(Building *building in buildings){
            washletFrag=false;
            buildingFrag=false;
            for (NSMutableArray *toiletByFloor in building.toilets) {
                for (Toilet *toilet in toiletByFloor) {
                    if(toilet.sex==1 && toilet.hasWashlet==true){
                        //[filteringResultBuildings addObject:toilet];
                        washletFrag=true;
                        buildingFrag=true;
                    }
                }
            }
            if(washletFrag==true && buildingFrag==true){ //女性トイレかつウォシュレットがある場合その建物を追加
                [filteringResultBuildings addObject:building];
            }
        }
    }
    
    if(sex==0 && washlet==false && multipurpose==true){//男 ∧ ウ× ∧ 多◯)
        for(Building *building in buildings){
            multipurposeFrag=false;
            buildingFrag=false;
            for (NSMutableArray *toiletByFloor in building.toilets) {
                for (Toilet *toilet in toiletByFloor) {
                    if(toilet.sex==0 && toilet.hasMultipurpose==true){
                        //[filteringResultBuildings addObject:toilet];
                        multipurposeFrag=true; //多目的トイレフラグを立てる
                        buildingFrag=true;
                    }
                }
            }
            if(multipurposeFrag==true && buildingFrag==true){ //男性トイレかつ多目的トイレがある場合その建物を追加
                [filteringResultBuildings addObject:building];
            }
        }
    }
    if(sex==1 && washlet==false && multipurpose==true){//女 ∧ ウ× ∧ 多◯)
        for(Building *building in buildings){
            multipurposeFrag=false;
            buildingFrag=false;
            for (NSMutableArray *toiletByFloor in building.toilets) {
                for (Toilet *toilet in toiletByFloor) {
                    if(toilet.sex==1 && toilet.hasMultipurpose==true){
                        //[filteringResultBuildings addObject:toilet];
                        multipurposeFrag=true;
                        buildingFrag=true;
                    }
                }
            }
            if(multipurposeFrag==true && buildingFrag==true){ //女性トイレかつ多目的トイレがある場合その建物を追加
                [filteringResultBuildings addObject:building];
            }
        }
    }
    NSLog(@"フィルタ結果の配列を出力:%@",filteringResultBuildings);
    return filteringResultBuildings; //フィルタリングした配列を返す
}

- (void) markBuildings:(NSMutableArray *)buildings{
    for (Building *building in buildings) {
        CLLocationCoordinate2D position = CLLocationCoordinate2DMake(building.latitude.doubleValue, building.longitude.doubleValue);
        GMSMarker *marker = [GMSMarker markerWithPosition:position];
        marker.title = building.name;
        marker.map = mapView_;
        marker.userData = building;
        marker.icon = [self getUIColorForMarker:[building getUtillization]];
        marker.zIndex = (int)(1.0 - [building getUtillization].doubleValue);
        building.marker = marker;
    }
}

- (void) markToilets:(Building *)building{
    for (NSMutableArray *toiletsByFloor in building.toilets) {
        for (Toilet *toilet in toiletsByFloor) {
            CLLocationCoordinate2D position = CLLocationCoordinate2DMake(toilet.latitude.doubleValue, toilet.longitude.doubleValue);
            GMSMarker *marker = [GMSMarker markerWithPosition:position];
            marker.title = toilet.storeName;
            marker.map = mapView_;
            marker.userData = toilet;
            marker.icon = [self getUIColorForMarker:[toilet getUtillization]];
            marker.zIndex = (int)(1.0 - [toilet getUtillization].doubleValue);
            toilet.markder = marker;
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

- (UIImage *) getUIColorForMarker:(NSNumber *)utillization{
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


@end


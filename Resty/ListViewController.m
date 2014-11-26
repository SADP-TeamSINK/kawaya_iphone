//
//  ListViewController.m
//  Resty
//
//  Created by Imamori Daichi on 2014/11/21.
//  Copyright (c) 2014年 Kazuma Nagaya. All rights reserved.
//

#import "ListViewController.h"
#import <Foundation/Foundation.h>


@implementation ListViewController{
    UIView *baseView_;
    UIView *headerView_;

    NSInteger height_;
    NSInteger width_;

    NSInteger listHeignt_;
    NSInteger listWidth_;
    NSInteger listTopMargin_;
    
    NSInteger baseHeignt_;
    NSInteger baseWidth_;
    Building *building_;
    
    NSMutableArray *floorName_;
    NSMutableArray *floorData_;
    
    UILabel *buildingName_;
    NSIndexPath *selectedIndexPath_;
    Color *color_;
}

- (id) init{
    self = [super initWithStyle:UITableViewStyleGrouped];

    color_ = [[Color alloc] init];
    height_ = [[UIScreen mainScreen] bounds].size.height;
    width_ = [[UIScreen mainScreen] bounds].size.width;
    selectedIndexPath_ = [NSIndexPath indexPathForRow:-1 inSection:-1];
    
    // ベースのサイズを設定
    baseHeignt_ = height_ * (1 - MAP_RATIO);
    baseWidth_ = width_;
    
    // ベースとなるViewを作成
    baseView_ = [[UIView alloc] initWithFrame:CGRectMake(0, height_, baseWidth_, baseHeignt_)];
    baseView_.backgroundColor = color_.white;
    
    // ヘッダを設定
    headerView_ = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width_, LIST_TOP_BAR_HEIGHT)];
    headerView_.backgroundColor = color_.gray;
    headerView_.layer.shadowOpacity = 0.4; // 濃さを指定
    headerView_.layer.shadowRadius = 2.0f;
    headerView_.layer.shadowOffset = CGSizeMake(0.0, 0); // 影までの距離を指定
    [baseView_ addSubview:headerView_];
    
    // buildingNameを準備
    buildingName_ = [[UILabel alloc] initWithFrame:CGRectMake( width_ - BUILDING_NAME_RIGHT_MARGIN - BUILDING_NAME_WIDTH_RATIO * width_, 0, BUILDING_NAME_WIDTH_RATIO * width_, LIST_TOP_BAR_HEIGHT)];
    UIFont *font = [UIFont fontWithName:@"HiraKakuProN-W3"size:BUILDING_NAME_FONT_SIZE];
    [buildingName_ setFont:font];
    [buildingName_ setTextAlignment:NSTextAlignmentRight];
    buildingName_.textColor = color_.darkGray;
    [headerView_ addSubview:buildingName_];
    
    // リストのマージンを設定
    listTopMargin_ = LIST_TOP_BAR_HEIGHT;
    
    // リストのサイズを設定
    listHeignt_ = height_ * (1 - MAP_RATIO) - BUTTON_BOTTOM_MARGIN - BUTTON_TOP_MARGIN - BUTTON_SIZE - LIST_TOP_BAR_HEIGHT;
    listWidth_ = width_;

    // リストの初期化
    self.view.frame = CGRectMake(0, listTopMargin_, listWidth_, listHeignt_);
    self.view.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0];//白
    
    // baseViewにlistViewを追加
    [baseView_ addSubview:self.view];
    
    
    // list情報の初期化
    floorName_ = [NSMutableArray array];
    floorData_ = [NSMutableArray array];
    
    // ToiletTableViewCellをtableViewに登録
    [self.tableView registerClass:[ToiletTableViewCell class] forCellReuseIdentifier:@"Cell"];
    
    // cellの高さを設定
    self.tableView.rowHeight = height_ * PANE_HEIGHT_RATIO;
    
    // 区切り線を消す
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    // tableViewの背景を設定
    self.tableView.backgroundColor = color_.white;
    
    return self;
}

- (void) onScreen{
    baseView_.frame = CGRectMake(0, height_ * (MAP_RATIO), baseWidth_, baseHeignt_);
    [baseView_ bringSubviewToFront:headerView_];
    [self viewDidAppear:YES];
    
}

- (void) offScreen{
    baseView_.frame = CGRectMake(0, height_, baseWidth_, baseHeignt_);
    selectedIndexPath_ = [NSIndexPath indexPathForRow:-1 inSection:-1];
}

- (UIView *) getListView{
    return baseView_;
}

- (void) listUpToilets:(Building *)building{
    [floorName_ removeAllObjects];
    [floorData_ removeAllObjects];
    for (NSMutableArray *toiletByFloor in building.toilets) {
        if ([toiletByFloor count] == 0) continue;
        // その階層にトイレが登録されていない場合は continue
        NSLog(@"floor: %ld, toilet: %@", (long)((Toilet *)toiletByFloor[0]).floor, ((Toilet *)toiletByFloor[0]).storeName);
        [floorName_ addObject:[NSString stringWithFormat:@"%d", (int)((Toilet *)toiletByFloor[0]).floor]];
        [floorData_ addObject:toiletByFloor];
    }
    buildingName_.text = building.name;
    [self.tableView reloadData];
}

// テーブルが表示されるときに，データのリロードと選択業の削除を行う
- (void)viewWillAppear:(BOOL)animated
{
    // Unselect the selected row if any
    NSIndexPath*	selection = [self.tableView indexPathForSelectedRow];
    if (selection)
        [self.tableView deselectRowAtIndexPath:selection animated:YES];
    
    [self.tableView reloadData];
}

// テーブルが表示された後に，スクロールバーの点滅
- (void)viewDidAppear:(BOOL)animated
{
    //	The scrollbars won't flash unless the tableview is long enough.
    [self.tableView flashScrollIndicators];
}

/**
 * テーブルのセルの数を返す
 */
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // セルの内容はNSArray型の「items」にセットされているものとする
    return [floorData_[section] count];
}

/**
 * 指定されたインデックスパスのセルを作成する
 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ToiletTableViewCell *cell;

    if (selectedIndexPath_.row == indexPath.row && selectedIndexPath_.section == indexPath.section) {
        cell = (ToiletTableViewCell *)[self makeCustomCell:@"SelectedCell" indexPath:indexPath tableView:tableView];
        [cell transformSelected];
    }else{
        cell = (ToiletTableViewCell *)[self makeCustomCell:@"NotSelectedCell" indexPath:indexPath tableView:tableView];
        [cell transformNotSelected];
    }
    
    return cell;
}

- (UITableViewCell *) makeCustomCell:(NSString *)cellIdentifier indexPath:(NSIndexPath *)indexPath tableView:(UITableView *)tableView{
    ToiletTableViewCell *cell;
    cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    Toilet *toilet = ((Toilet *)floorData_[indexPath.section][indexPath.row]);
    
    // セルが作成されていないか?
    if (!cell) { // yes
        // セルを作成
        cell = [[ToiletTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    // 店名の設定
    NSString *storeName;
    if([toilet.storeName isEqualToString:@""]){
        storeName = [NSString stringWithFormat:@"%@", [toilet getOwner].name];
    }else{
        storeName = toilet.storeName;
    }
    cell.storeName.text = storeName;
    [cell adjustStoreName];
    
    // ウォシュレットマーク
    if(toilet.hasWashlet){
        [cell setWashletMarker];
    }
    
    // 多目的トイレマーク
    if(toilet.hasMultipurpose){
        [cell setMultipurposeMarker];
    }
    
    // 利用率の設定
    [cell setUtillization:[toilet getUtillization]];
    
    if (selectedIndexPath_.row == indexPath.row && selectedIndexPath_.section == indexPath.section) {
        [(ToiletTableViewCell *)cell transformSelected];
    }else{
        [(ToiletTableViewCell *)cell transformNotSelected];
    }
    
    return cell;
}

/**
 * テーブル全体のセクションの数を返す
 */
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [floorName_ count];
}

/**
 * 指定されたセクションのセクション名を返す
 */
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return floorName_[section];
}

/**
 * セルが選択されたとき
 */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (selectedIndexPath_.row == indexPath.row && selectedIndexPath_.section == indexPath.section) {
        selectedIndexPath_ = [NSIndexPath indexPathForRow:-1 inSection:-1];
    }else{
        selectedIndexPath_ = indexPath;
    }
    [self.tableView reloadData];

    NSLog(@"選択されました");
}

/**
 * ヘッダーの高さを返す
 */
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return HEADER_HEIGHT;
}

/**
 * ヘッダーをカスタマイズ
 */
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    NSInteger floorNumber = [floorName_[section] intValue];
    BOOL isBasement = (floorNumber < 0);
    NSString *floorNameString = [NSString stringWithFormat:@"%d", abs((int)floorNumber)];

    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width_, HEADER_HEIGHT)];
    
    // 地下(B) or 地上(F)
    UILabel *floorNameLabel = [[UILabel alloc]
                  initWithFrame:CGRectMake(
                                           HEADER_LEFT_MARGIN,
                                           (HEADER_HEIGHT - HEADER_FONT_SIZE) * HEADER_TOP_MARGIN_RATIO,
                                           width_,
                                           HEADER_FONT_SIZE)];
    floorNameLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    UIFont *font = [UIFont fontWithName:@"HiraKakuProN-W3"size:HEADER_FONT_SIZE];
    [floorNameLabel setFont:font];
    floorNameLabel.numberOfLines = 1;
    floorNameLabel.textColor = color_.darkGray;
    if(isBasement){
        floorNameLabel.text = [NSString stringWithFormat:@"地下%@階", floorNameString];
    }else{
        floorNameLabel.text = [NSString stringWithFormat:@"%@階", floorNameString];
    }
    [view addSubview:floorNameLabel];
    
    view.backgroundColor = color_.white;
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger height = 0;
    if (selectedIndexPath_.row == indexPath.row && selectedIndexPath_.section == indexPath.section) {
        height = 300;
    }else{
        height = PANE_HEIGHT_RATIO * height_;
    }
    return height;
}

@end

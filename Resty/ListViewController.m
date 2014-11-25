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
    UIView * baseView_;

    NSInteger height_;
    NSInteger width_;

    NSInteger listHeignt_;
    NSInteger listWidth_;
    NSInteger listTopMargin_;
    
    NSInteger baseHeignt_;
    NSInteger baseWidth_;
    Building *building_;
    
    NSMutableArray *floorName;
    NSMutableArray *floorData;
    
    Color *color_;
}

- (id) init{
    self = [super initWithStyle:UITableViewStyleGrouped];

    color_ = [[Color alloc] init];
    height_ = [[UIScreen mainScreen] bounds].size.height;
    width_ = [[UIScreen mainScreen] bounds].size.width;
    
    // ベースのサイズを設定
    baseHeignt_ = height_ * (1 - MAP_RATIO);
    baseWidth_ = width_;
    
    // ベースとなるViewを作成
    baseView_ = [[UIView alloc] initWithFrame:CGRectMake(0, height_, baseWidth_, baseHeignt_)];
    baseView_.backgroundColor = color_.darkGray;
    
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
    floorName = [NSMutableArray array];
    floorData = [NSMutableArray array];
    
    // ToiletTableViewCellをtableViewに登録
    [self.tableView registerClass:[ToiletTableViewCell class] forCellReuseIdentifier:@"Cell"];
    
    // cellの高さを設定
    self.tableView.rowHeight = height_ * PANE_HEIGHT_RATIO;
    
    // 区切り線を消す
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    // tableViewの背景を設定
    self.tableView.backgroundColor = color_.gray;
    
    return self;
}

- (void) onScreen{
    baseView_.frame = CGRectMake(0, height_ * (MAP_RATIO), baseWidth_, baseHeignt_);
    [self.tableView flashScrollIndicators];
}

- (void) offScreen{
    baseView_.frame = CGRectMake(0, height_, baseWidth_, baseHeignt_);
}

- (UIView *) getListView{
    return baseView_;
}

- (void) listUpToilets:(Building *)building{
    [floorName removeAllObjects];
    [floorData removeAllObjects];
    for (NSMutableArray *toiletByFloor in building.toilets) {
        if ([toiletByFloor count] == 0) continue;
        // その階層にトイレが登録されていない場合は continue
        NSLog(@"floor: %ld, toilet: %@", (long)((Toilet *)toiletByFloor[0]).floor, ((Toilet *)toiletByFloor[0]).storeName);
        [floorName addObject:[NSString stringWithFormat:@"%d", (int)((Toilet *)toiletByFloor[0]).floor]];
        [floorData addObject:toiletByFloor];
    }
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
    return [floorData[section] count];
}

/**
 * 指定されたインデックスパスのセルを作成する
 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = @"Cell";
    ToiletTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    Toilet *toilet = ((Toilet *)floorData[indexPath.section][indexPath.row]);
    
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
    
    return cell;
}

/**
 * テーブル全体のセクションの数を返す
 */
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [floorName count];
}

/**
 * 指定されたセクションのセクション名を返す
 */
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return floorName[section];
}

/**
 * セルが選択されたとき
 */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
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
    NSInteger floorNumber = [floorName[section] intValue];
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
        floorNameLabel.text = @"B";
    }else{
        floorNameLabel.text = @"F";
    }
    [view addSubview:floorNameLabel];
    
    // 数字
    UILabel *floorNumberLabel = [[UILabel alloc]
                               initWithFrame:CGRectMake(
                                                        HEADER_LEFT_MARGIN + HEADER_FONT_SIZE * 0.6,
                                                        (HEADER_HEIGHT - HEADER_FONT_SIZE) * HEADER_TOP_MARGIN_RATIO,
                                                        HEADER_FONT_SIZE,
                                                        HEADER_FONT_SIZE)];
    floorNumberLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [floorNumberLabel setFont:font];
    floorNumberLabel.numberOfLines = 1;
    floorNumberLabel.textColor = color_.darkRed;
    floorNumberLabel.text = floorNameString;
    [view addSubview:floorNumberLabel];
    
    view.backgroundColor = color_.gray;
    return view;
}

@end

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
}

- (id) init{
    self = [super init];

    height_ = [[UIScreen mainScreen] bounds].size.height;
    width_ = [[UIScreen mainScreen] bounds].size.width;
    
    // ベースのサイズを設定
    baseHeignt_ = height_ * (1 - MAP_RATIO);
    baseWidth_ = width_;
    
    // ベースとなるViewを作成
    baseView_ = [[UIView alloc] initWithFrame:CGRectMake(0, height_ * 0.6f, baseWidth_, baseHeignt_)];
    baseView_.backgroundColor = [UIColor colorWithRed:100/255.0 green:100/255.0 blue:100/255.0 alpha:1.0];//灰
    
    // リストのマージンを設定
    listTopMargin_ = LIST_TOP_BAR_HEIGHT;
    
    // リストのサイズを設定
    listHeignt_ = height_ * (1 - MAP_RATIO) - BUTTON_BOTTOM_MARGIN - BUTTON_TOP_MARGIN - BUTTON_HEIGHT - LIST_TOP_BAR_HEIGHT;
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
    
    return self;
}

- (void) onScreen{
    baseView_.frame = CGRectMake(0, height_ * (MAP_RATIO), baseWidth_, baseHeignt_);
}

- (void) offScreen{
    baseView_.frame = CGRectMake(0, height_ * 0.6f, baseWidth_, baseHeignt_);
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
        [floorName addObject:[NSString stringWithFormat:@"Floor%d", (int)((Toilet *)toiletByFloor[0]).floor]];
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
    
    // セルが作成されていないか?
    if (!cell) { // yes
        // セルを作成
        cell = [[ToiletTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    // セルの設定
    cell.storeName.text = [NSString stringWithFormat:@"Toilet: %@", ((Toilet *)floorData[indexPath.section][indexPath.row]).storeName];
    
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

@end

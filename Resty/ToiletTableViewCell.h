//
//  ToiletTableViewCell.h
//  Resty
//
//  Created by Imamori Daichi on 2014/11/24.
//  Copyright (c) 2014年 Kazuma Nagaya. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Const.m"
#import "Color.h"

@interface ToiletTableViewCell : UITableViewCell
@property (nonatomic) UILabel *storeName;
@property (nonatomic) UIImageView *toiletImageView;
@property (nonatomic) UIImageView *washletImageView;
@property (nonatomic) UIImageView *multipurposeImageView;
@property (nonatomic) UIImageView *markerImageView;
@property (nonatomic) UIView *backView;

- (void) setUtillization:(NSNumber *)utillization;
- (void) setWashletMarker;
- (void) setMultipurposeMarker;
- (void) adjustStoreName;
- (void) transformSelected;
- (void) transformNotSelected;
@end


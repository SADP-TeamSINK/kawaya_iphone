//
//  ToiletTableViewCell.m
//  Resty
//
//  Created by Imamori Daichi on 2014/11/24.
//  Copyright (c) 2014年 Kazuma Nagaya. All rights reserved.
//

#import "ToiletTableViewCell.h"

@implementation ToiletTableViewCell {
    NSInteger height_;
    NSInteger width_;
    Color *color_;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        color_ = [[Color alloc] init];
        height_ = [[UIScreen mainScreen] bounds].size.height;
        width_ = [[UIScreen mainScreen] bounds].size.width;
        
        self.contentView.frame = CGRectMake(0, 0, width_, height_ * PANE_HEIGHT_RATIO);
        self.contentView.backgroundColor = color_.gray;
        
        // 背景Viewの設定
        CGRect backRect
            = CGRectMake(self.contentView.frame.size.width * (1 - INNER_PANE_WIDTH_RATIO) * INNER_PANE_WIDTH_BIAS,
                         self.contentView.frame.size.height * (1 - INNER_PANE_HEIGHT_RATIO) * 0.5f,
                         self.contentView.frame.size.width * INNER_PANE_WIDTH_RATIO,
                         self.contentView.frame.size.height * INNER_PANE_HEIGHT_RATIO);
        _backView = [[UIView alloc] initWithFrame:backRect];
        _backView.backgroundColor = color_.green;
        // 枠線の設定
        [[_backView layer] setBorderColor:[color_.white CGColor]];
        [[_backView layer] setBorderWidth:INNER_PANE_BORDER];
        [self.contentView addSubview:_backView];
        //はみ出しを許可
        _backView.clipsToBounds = NO;
        
        // StoreNameの設定
        _storeName = [[UILabel alloc] initWithFrame:CGRectMake(PANE_TOP_PADDING, PANE_LEFT_PADDING, width_ * PANE_WIDTH_RATIO, height_ * PANE_HEIGHT_RATIO)];
        _storeName.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        _storeName.font = [UIFont systemFontOfSize:STORE_NAME_FONT_SIZE];
        _storeName.numberOfLines = 2;
        
        [_backView addSubview:_storeName];
        
        // ウォシュレットマークの設定
        _washletImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"washletMark.png"]];
        _washletImageView.frame
            = CGRectMake(
                         self.contentView.frame.size.width - PANE_RIGHT_PADDING - _washletImageView.image.size.width,
                         PANE_TOP_PADDING,
                         _washletImageView.image.size.width,
                         _washletImageView.image.size.height);
        //[self.contentView addSubview:_washletImageView];
        
        // 多目的トイレマークの設定
        _multipurposeImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"multipurposeMark.png"]];
        _multipurposeImageView.frame
            = CGRectMake(
                         self.contentView.frame.size.width - PANE_RIGHT_PADDING - _washletImageView.image.size.width*2 - WASHLET_MULTIPURPOSE_MARKER_MARGIN,
                         PANE_TOP_PADDING,
                         _multipurposeImageView.image.size.width,
                         _multipurposeImageView.image.size.height);
        //[self.contentView addSubview:_multipurposeImageView];
    }
    
    // レイアウトをアップデート
    [self updateConstraints];
    
    return self;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) setUtillizationMarker:(NSNumber *)utillization{

    if(utillization.doubleValue < GREEN_UTILLIZATION){
        _markerImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"greenMarkerSmall.png"]];
    }else if(utillization.doubleValue < YELLOW_UTILLIZATION){
        _markerImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"yellowMarkerSmall.png"]];
    }else{
        _markerImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"redMarkerSmall.png"]];
    }

    _markerImageView.frame = CGRectMake(
                                        _backView.frame.origin.x -_markerImageView.image.size.width * UTILLIZATION_MARKER_LEFT_OUT,
                                        _backView.frame.origin.y -_markerImageView.image.size.height * UTILLIZATION_MARKER_TOP_OUT,
                                        _markerImageView.image.size.width,
                                        _markerImageView.image.size.height);
    [self.contentView addSubview:_markerImageView];
}

- (void) setWashletMarker{
    [_backView addSubview:_washletImageView];
}

- (void) setMultipurposeMarker{
    [_backView addSubview:_multipurposeImageView];
}

@end

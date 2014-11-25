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
        self.contentView.backgroundColor = color_.white;
        
        // 背景Viewの設定
        CGRect backRect
            = CGRectMake(self.contentView.frame.size.width * (1 - INNER_PANE_WIDTH_RATIO) * INNER_PANE_WIDTH_BIAS,
                         self.contentView.frame.size.height * (1 - INNER_PANE_HEIGHT_RATIO) * INNER_PANE_HEIGHT_BIAS,
                         self.contentView.frame.size.width * INNER_PANE_WIDTH_RATIO,
                         self.contentView.frame.size.height * INNER_PANE_HEIGHT_RATIO);
        _backView = [[UIView alloc] initWithFrame:backRect];
        _backView.layer.shadowOpacity = 0.4; // 濃さを指定
        _backView.layer.shadowRadius = 1.0f;
        _backView.layer.shadowOffset = CGSizeMake(0.0, 1); // 影までの距離を指定
        _backView.backgroundColor = color_.green;
        // 枠線の設定
        [[_backView layer] setBorderColor:[color_.white CGColor]];
        [[_backView layer] setBorderWidth:INNER_PANE_BORDER];
        [self.contentView addSubview:_backView];
        //はみ出しを許可
        _backView.clipsToBounds = NO;
        
        // StoreNameの設定
        _storeName = [[UILabel alloc]
                      initWithFrame:CGRectMake(
                                               0,
                                               0,
                                               width_ * PANE_WIDTH_RATIO * INNER_PANE_WIDTH_RATIO,
                                               height_ * PANE_HEIGHT_RATIO * INNER_PANE_HEIGHT_RATIO)];
        _storeName.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        UIFont *hirakakuFont = [UIFont fontWithName:@"HiraKakuProN-W3"size:STORE_NAME_FONT_SIZE];
        [_storeName setFont:hirakakuFont];
        _storeName.numberOfLines = 2;
        _storeName.textColor = color_.white;
        [_backView addSubview:_storeName];
        
        // ウォシュレットマークの設定
        _washletImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"washletMarker.png"]];
        _washletImageView.frame
            = CGRectMake(
                         _backView.frame.size.width - PANE_RIGHT_PADDING - WASHLET_MARKER_SIZE,
                         (_backView.frame.size.height - WASHLET_MARKER_SIZE) * 0.5f,
                         WASHLET_MARKER_SIZE,
                         WASHLET_MARKER_SIZE);
        
        // 多目的トイレマークの設定
        _multipurposeImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"multipurposeMarker.png"]];
        _multipurposeImageView.frame
            = CGRectMake(
                         _backView.frame.size.width - PANE_RIGHT_PADDING - WASHLET_MARKER_SIZE - MULTIPURPOSE_MARKER_SIZE - WASHLET_MULTIPURPOSE_MARKER_MARGIN,
                         (_backView.frame.size.height - MULTIPURPOSE_MARKER_SIZE) * 0.5f,
                         MULTIPURPOSE_MARKER_SIZE,
                         MULTIPURPOSE_MARKER_SIZE);

        // トイレ画像の設定
        UIImage *toiletImage = [UIImage imageNamed:@"toilet.jpg"];
        double scale = (double)_backView.frame.size.height / (double)toiletImage.size.height;
        _toiletImageView = [[UIImageView alloc]
                                  initWithFrame:CGRectMake(
                                                           0,
                                                           0,
                                                           scale * toiletImage.size.width,
                                                           scale * toiletImage.size.height)];
        _toiletImageView.image = toiletImage;
        [_backView addSubview:_toiletImageView];
        
        
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

- (void) setUtillization:(NSNumber *)utillization{

    UIImage *markerImage;
    if(utillization.doubleValue < GREEN_UTILLIZATION){
        _backView.backgroundColor = color_.green;
        markerImage = [UIImage imageNamed:@"greenMarkerSmall.png"];
    }else if(utillization.doubleValue < YELLOW_UTILLIZATION){
        _backView.backgroundColor = color_.yellow;
        markerImage = [UIImage imageNamed:@"yellowMarkerSmall.png"];
    }else{
        _backView.backgroundColor = color_.red;
        markerImage = [UIImage imageNamed:@"redMarkerSmall.png"];
    }

    _markerImageView = [[UIImageView alloc] initWithImage:markerImage];
    _markerImageView.frame = CGRectMake(
                                        _backView.frame.origin.x - UTILLIZATION_MARKER_SIZE * UTILLIZATION_MARKER_LEFT_OUT,
                                        _backView.frame.origin.y - UTILLIZATION_MARKER_SIZE * UTILLIZATION_MARKER_TOP_OUT,
                                        UTILLIZATION_MARKER_SIZE,
                                        UTILLIZATION_MARKER_SIZE);
    [self.contentView addSubview:_markerImageView];
}

- (void) setWashletMarker{
    [_backView addSubview:_washletImageView];
}

- (void) setMultipurposeMarker{
    [_backView addSubview:_multipurposeImageView];
}

- (void) adjustStoreName{
    _storeName.frame = CGRectMake(
                                  _toiletImageView.frame.size.width + _backView.frame.size.width * INNER_PANE_STORE_NAME_LEFT_MARGIN_RATIO,
                                  0,
                                  _backView.frame.size.width * INNER_PANE_STORE_NAME_WIDTH_RATIO,
                                  _storeName.frame.size.height);
}

@end

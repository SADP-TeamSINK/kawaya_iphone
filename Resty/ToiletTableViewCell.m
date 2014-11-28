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
        self.selectionStyle = UITableViewCellSelectionStyleGray;
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
        
        // 利用率マーカの設定
        _markerImageView = [[UIImageView alloc] init];

        
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
        UIImage *toiletImage = [UIImage imageNamed:@"toilet.png"];
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

- (void) setUtillization:(NSNumber *)utillization{

    if(![_markerImageView isDescendantOfView:_backView]){
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
        _markerImageView.image = markerImage;
        _markerImageView.frame = CGRectMake(
                                            _backView.frame.origin.x - UTILLIZATION_MARKER_SIZE * UTILLIZATION_MARKER_LEFT_OUT,
                                            _backView.frame.origin.y - UTILLIZATION_MARKER_SIZE * UTILLIZATION_MARKER_TOP_OUT,
                                            UTILLIZATION_MARKER_SIZE,
                                            UTILLIZATION_MARKER_SIZE);
[self.contentView addSubview:_markerImageView];
    }
}

- (void) setWashletMarker{
    if(![_washletImageView isDescendantOfView:_backView]){
        [_backView addSubview:_washletImageView];
    }
}

- (void) setMultipurposeMarker{
    if(![_multipurposeImageView isDescendantOfView:_backView]){
        [_backView addSubview:_multipurposeImageView];
    }
}

- (void) removeWashletMarker{
    if([_washletImageView isDescendantOfView:_backView]){
        [_washletImageView removeFromSuperview];
    }
}

- (void) removeMultipurposeMarker{
    if([_multipurposeImageView isDescendantOfView:_backView]){
        [_multipurposeImageView removeFromSuperview];
    }
}

- (void) adjustStoreName{
    _storeName.frame = CGRectMake(
                                  _toiletImageView.frame.size.width + _backView.frame.size.width * INNER_PANE_STORE_NAME_LEFT_MARGIN_RATIO,
                                  0,
                                  _backView.frame.size.width * INNER_PANE_STORE_NAME_WIDTH_RATIO,
                                  _storeName.frame.size.height);
}

// セルが選択されている時の状態設定
-(void) setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    if (highlighted)
    {
        //_backView.layer.borderColor = [color_.darkGray CGColor];
    }
    else
    {// 非選択状態
        //_backView.layer.borderColor = [color_.white CGColor];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    //[super setSelected:selected animated:animated];
    if (selected) {

    }else{

    }
}

- (void) transformSelected{
    self.contentView.backgroundColor = color_.gray;
    NSInteger imageWidth = self.contentView.frame.size.width * INNER_PANE_WIDTH_RATIO;
    NSInteger imageHeight = _toiletImageView.image.size.height / _toiletImageView.image.size.width * _backView.frame.size.width;
    // TODO: animation
    _backView.frame = CGRectMake(
                                 _backView.frame.origin.x,
                                 _backView.frame.origin.y,
                                 _backView.frame.size.width,
                                 height_ * PANE_HEIGHT_RATIO * INNER_PANE_HEIGHT_RATIO + imageHeight);
    _toiletImageView.frame = CGRectMake(
                                        _toiletImageView.frame.origin.x,
                                        _toiletImageView.frame.origin.y,
                                        imageWidth,
                                        imageHeight);

    NSInteger markerY = (_backView.frame.size.height + _toiletImageView.frame.size.height) * 0.5f;
    _multipurposeImageView.frame = CGRectMake(
                                              _multipurposeImageView.frame.origin.x,
                                              markerY - _multipurposeImageView.frame.size.height * 0.5,
                                              _multipurposeImageView.frame.size.width,
                                              _multipurposeImageView.frame.size.height);
    _washletImageView.frame = CGRectMake(
                                              _washletImageView.frame.origin.x,
                                              markerY - _washletImageView.frame.size.height * 0.5,
                                              _washletImageView.frame.size.width,
                                              _washletImageView.frame.size.height);

    _storeName.frame = CGRectMake(
                                 INNER_PANE_STORE_NAME_LEFT_MARGIN_RATIO * width_,
                                 markerY - _storeName.frame.size.height * 0.5,
                                 INNER_PANE_STORE_NAME_WIDTH_RATIO_BIG * _backView.frame.size.width,
                                 _storeName.frame.size.height);
}

- (void) transformNotSelected{
    self.contentView.backgroundColor = color_.white;
    _backView.frame = CGRectMake(
                                 _backView.frame.origin.x,
                                 _backView.frame.origin.y,
                                 self.contentView.frame.size.width * INNER_PANE_WIDTH_RATIO,
                                 self.contentView.frame.size.height * INNER_PANE_HEIGHT_RATIO +2);

    double scale = (double)_backView.frame.size.height / (double)_toiletImageView.image.size.height;
    _toiletImageView.frame = CGRectMake(
                                        0,
                                        0,
                                        scale * _toiletImageView.image.size.width,
                                        scale * _toiletImageView.image.size.height);
}


@end

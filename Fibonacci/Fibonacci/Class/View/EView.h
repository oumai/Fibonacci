//
//  EView.h
//  Edemo
//
//  Created by woaiqiu947 on 16/9/20.
//  Copyright © 2016年 woaiqiu947. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, EViewTransformStatus) {
    EViewTransformStatusTop           = 0,
    EViewTransformStatusRight         = 1,
    EViewTransformStatusBottom        = 2,
    EViewTransformStatusLeft          = 3,
};

typedef NS_ENUM(NSInteger, EViewColorType) {
    EViewColorTypeDefault         = 0,
    EViewColorTypeAppFontColor         = 1,
};

@interface EView : UIView
{
    CGPoint viewCenter;
    EViewTransformStatus eViewTransformStatus;
    EViewColorType colorType;
}
- (instancetype)initWithFrame:(CGRect)frame withFillColorType:(EViewColorType)type;
-(void)setEViewTransform:(EViewTransformStatus)status;
-(BOOL)eViewTransformDirection:(EViewTransformStatus)status;
-(void)setHeigthAndWidth:(CGFloat)value center:(CGPoint)center;
@end

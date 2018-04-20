//
//  EyeButton.h
//  Fibonacci
//
//  Created by woaiqiu947 on 16/9/21.
//  Copyright © 2016年 woaiqiu947. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, EyeButtonTransformStatus) {
    EyeButtonTransformStatusTop           = 0,
    EyeButtonTransformStatusLeft          = 1,
    EyeButtonTransformStatusRight         = 2,
    EyeButtonTransformStatusBottom        = 3,
};

@interface EyeButton : UIButton
{
    EyeButtonTransformStatus eyeButtonTransformStatus;
}
-(void)eyeButtonTransform:(EyeButtonTransformStatus)status;
@end

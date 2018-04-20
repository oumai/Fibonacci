//
//  ShapeView.m
//  DrawAnimationLine
//
//  Created by 连喜 邓 on 14-3-25.
//  Copyright (c) 2014年 连喜 邓. All rights reserved.
//

#import "ShapeView.h"


@implementation ShapeView


+ (Class)layerClass
{
    return [CAShapeLayer class];
}

- (CAShapeLayer *)shapeLayer
{
    return (CAShapeLayer *)self.layer;
}

@end

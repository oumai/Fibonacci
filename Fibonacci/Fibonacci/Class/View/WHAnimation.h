//
//  WHAnimation.h
//  Fibonacci
//
//  Created by shipeiyuan on 2016/12/5.
//  Copyright © 2016年 woaiqiu947. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WHAnimation : NSObject

+ (CALayer *)replicatorLayer_Circle;

+ (CALayer *)replicatorLayer_Wave;

+ (CALayer *)replicatorLayer_Triangle:(UIColor*)color;

+ (CALayer *)replicatorLayer_Grid;

@end

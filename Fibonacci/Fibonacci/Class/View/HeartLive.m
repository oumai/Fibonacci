//
//  HeartLive.m
//  HeartRateCurve
//
//  Created by IOS－001 on 14-4-23.
//  Copyright (c) 2014年 N/A. All rights reserved.
//
#import "HeartLive.h"
//static const NSInteger kMaxContainerCapacity = 45;
//static const NSInteger kMaxTranslationContainerCapacity = 300;


@interface PointContainer ()
@property (nonatomic , assign) NSInteger numberOfRefreshElements;
@property (nonatomic , assign) NSInteger numberOfTranslationElements;
@property (nonatomic , assign) CGPoint *refreshPointContainer;
@property (nonatomic , assign) CGPoint *translationPointContainer;

@end

@implementation PointContainer

- (void)dealloc
{
    free(self.refreshPointContainer);
    free(self.translationPointContainer);
    self.refreshPointContainer = self.translationPointContainer =  NULL;
}

+ (PointContainer *)sharedContainer
{
    static PointContainer *container_ptr = NULL;
    static dispatch_once_t onceToken;
    NSNumber *number = [NSNumber numberWithFloat:MainScreenWidth/2];
    NSNumber *translationNumber = [NSNumber numberWithFloat:MainScreenWidth];
    dispatch_once(&onceToken, ^{
        container_ptr = [[self alloc] init];
        [container_ptr initContainerCapacity];
        container_ptr.refreshPointContainer = malloc(sizeof(CGPoint) * [number integerValue]);
        memset(container_ptr.refreshPointContainer, 0, sizeof(CGPoint) * [number integerValue]);
        
        container_ptr.translationPointContainer = malloc(sizeof(CGPoint) * [translationNumber integerValue]);
        memset(container_ptr.translationPointContainer, 0, sizeof(CGPoint) * [translationNumber integerValue]);
    });
    return container_ptr;
}

+ (id)hideAlloc
{
    return [super alloc];
}

- (void)initContainerCapacity
{
    NSNumber *number = [NSNumber numberWithFloat:MainScreenWidth/2];
    NSNumber *translationNumber = [NSNumber numberWithFloat:MainScreenWidth];
    kMaxContainerCapacity = [number integerValue];
    kMaxTranslationContainerCapacity = [translationNumber integerValue];

}
- (void)clearValue
{
    self.numberOfRefreshElements = 0;
    self.numberOfTranslationElements = 0;
    currentPointsCount = 0;
    currentTranslaPointsCounts = 0;
    [PointContainer hideAlloc];
}

- (void)addPointAsRefreshChangeform:(CGPoint)point
{
    if (currentPointsCount < kMaxContainerCapacity) {
        self.numberOfRefreshElements = currentPointsCount + 1;
        self.refreshPointContainer[currentPointsCount] = point;
        currentPointsCount ++;
    } else {
        NSInteger workIndex = 0;
        while (workIndex != kMaxContainerCapacity - 1) {
            self.refreshPointContainer[workIndex] = self.refreshPointContainer[workIndex + 1];
            workIndex ++;
        }
        self.refreshPointContainer[kMaxContainerCapacity - 1] = point;
        self.numberOfRefreshElements = kMaxContainerCapacity;
    }
}

- (void)addPointAsTranslationChangeform:(CGPoint)point
{
    if (currentTranslaPointsCounts < kMaxTranslationContainerCapacity) {
        self.numberOfTranslationElements = currentTranslaPointsCounts + 1;
        self.translationPointContainer[currentTranslaPointsCounts] = point;
        currentTranslaPointsCounts ++;
    } else {
        NSInteger workIndex = 0;
        while (workIndex != kMaxTranslationContainerCapacity - 1) {
            self.translationPointContainer[workIndex] = self.translationPointContainer[workIndex + 1];
            workIndex ++;
        }
        self.translationPointContainer[kMaxTranslationContainerCapacity - 1] = point;
        self.numberOfTranslationElements = kMaxTranslationContainerCapacity;
    }
}

@end

@interface HeartLive ()

@property (nonatomic , assign) CGPoint *points;
@property (nonatomic , assign) NSInteger currentPointsCount;

@end

@implementation HeartLive
- (void)dealloc
{
    [self clearDrawing];
    context = nil;
}

- (void)setPoints:(CGPoint *)points
{
    _points = points;
    [self setNeedsDisplay];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.clearsContextBeforeDrawing = YES;
    }
    return self;
}

- (void)drawGrid
{
    context = UIGraphicsGetCurrentContext();
    CGFloat full_height = self.frame.size.height;
	CGFloat full_width = self.frame.size.width;
	CGFloat cell_square_width = 30;
	
	CGContextSetLineWidth(context, 0.2);
	CGContextSetStrokeColorWithColor(context, [UIColor redColor].CGColor);
	
	int pos_x = 1;
	while (pos_x < full_width) {
		CGContextMoveToPoint(context, pos_x, 1);
		CGContextAddLineToPoint(context, pos_x, full_height);
		pos_x += cell_square_width;
		
		CGContextStrokePath(context);
	}
    
	CGFloat pos_y = 1;
	while (pos_y <= full_height) {
		
		CGContextSetLineWidth(context, 0.2);
        
		CGContextMoveToPoint(context, 1, pos_y);
		CGContextAddLineToPoint(context, full_width, pos_y);
		pos_y += cell_square_width;
		
		CGContextStrokePath(context);
	}
	
    
	CGContextSetLineWidth(context, 0.1);
    
	cell_square_width = cell_square_width / 5;
	pos_x = 1 + cell_square_width;
	while (pos_x < full_width) {
		CGContextMoveToPoint(context, pos_x, 1);
		CGContextAddLineToPoint(context, pos_x, full_height);
		pos_x += cell_square_width;
		
		CGContextStrokePath(context);
	}
	
	pos_y = 1 + cell_square_width;
	while (pos_y <= full_height) {
		CGContextMoveToPoint(context, 1, pos_y);
		CGContextAddLineToPoint(context, full_width, pos_y);
		pos_y += cell_square_width;
		
		CGContextStrokePath(context);
	}
    
}

- (void)fireDrawingWithPoints:(CGPoint *)points pointsCount:(NSInteger)count
{
    _drawType = YES;
    self.currentPointsCount = count;
    self.points = points;
}

- (void)drawCurve
{
    if (self.currentPointsCount == 0) {
        return;
    }
    CGFloat curveLineWidth = 1.0;
    CGContextRef currentContext = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(currentContext, curveLineWidth);
	CGContextSetStrokeColorWithColor(UIGraphicsGetCurrentContext(), AppFontColor.CGColor);
    CGContextMoveToPoint(currentContext, self.points[0].x, self.points[0].y);
//    NSLog(@"0 = %f",self.points[0].y);
    for (int i = 1; i != self.currentPointsCount; ++ i) {
        if (self.points[i - 1].x < self.points[i].x) {
//            NSLog(@"1 %d = %f",i,self.points[i].y);
            CGContextAddLineToPoint(currentContext, self.points[i].x, self.points[i].y);
        } else {
            CGContextMoveToPoint(currentContext, self.points[i].x, self.points[i].y);
//            NSLog(@"2 %d = %f",i,self.points[i].y);
        }
    }
	CGContextStrokePath(UIGraphicsGetCurrentContext());
}

-(void)animateCicleAlongPath
{
    //准备关键帧动画
    CAKeyframeAnimation *pathAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    pathAnimation.calculationMode = kCAAnimationPaced;
    pathAnimation.fillMode = kCAFillModeForwards;
    pathAnimation.removedOnCompletion = NO;
    pathAnimation.duration = 1.0f;
    pathAnimation.repeatCount = 200;
    //pathAnimation.autoreverses = YES; //原路返回，而不是从头再来
    //设置动画路径
    //CGPoint endPoint = CGPointMake(310, 450);
    CGMutablePathRef curvedPath = CGPathCreateMutable();
    CGPathMoveToPoint(curvedPath, NULL, 10, 10);
    CGPathAddQuadCurveToPoint(curvedPath, NULL, 10, 450, 310, 450);
    CGPathAddQuadCurveToPoint(curvedPath, NULL, 310, 10, 10, 10);
    //已经有了路径，我们要告诉动画  路径
    pathAnimation.path = curvedPath;
    CGPathRelease(curvedPath);  //这里要手工释放
    
    [self.layer addAnimation:pathAnimation forKey:nil];
    
}

- (void)clearDrawing {

    self.points= nil;
    self.currentPointsCount = 0;
    [[PointContainer sharedContainer]clearValue];
}

- (void)stopDrawing
{
    clear = YES;
    self.points= nil;
    self.currentPointsCount = 0;
    [[PointContainer sharedContainer]clearValue];
}

- (void)drawRect:(CGRect)rect
{
    // Drawing code
    context = UIGraphicsGetCurrentContext();
    if (_gridType)
    {
        [self drawGrid];
    }
    if (!clear)
    {
        [self drawCurve];
    }
    else
    {
        clear = NO;
    }
}

@end

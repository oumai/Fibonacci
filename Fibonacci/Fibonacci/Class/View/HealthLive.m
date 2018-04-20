//
//  HeartLive.m
//  HeartRateCurve
//
//  Created by IOS－001 on 14-4-23.
//  Copyright (c) 2014年 N/A. All rights reserved.
//

#import "HealthLive.h"

static const NSInteger kMaxContainerCapacity = 35;

@interface KMPointContainer ()
@property (nonatomic , assign) NSInteger numberOfRefreshElements;
@property (nonatomic , assign) NSInteger numberOfTranslationElements;

@property (nonatomic , assign) CGPoint *refreshPointContainer;
@property (nonatomic , assign) CGPoint *topPointContainer;
@property (nonatomic , assign) CGPoint *bomPointContainer;
@property (nonatomic , assign) CGPoint *endPointContainer;

@property (nonatomic , assign) CGPoint *translationPointContainer;

@end

@implementation KMPointContainer

- (void)dealloc
{
    free(self.refreshPointContainer);
    free(self.translationPointContainer);
    self.refreshPointContainer = self.translationPointContainer = NULL;
}

+ (KMPointContainer *)sharedContainer
{
    static KMPointContainer *container_ptr = NULL;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        container_ptr = [[self alloc] init];
        container_ptr.refreshPointContainer = malloc(sizeof(CGPoint) * kMaxContainerCapacity);
        memset(container_ptr.refreshPointContainer, 0, sizeof(CGPoint) * kMaxContainerCapacity);
        
        container_ptr.topPointContainer = malloc(sizeof(CGPoint) * kMaxContainerCapacity);
        memset(container_ptr.topPointContainer, 0, sizeof(CGPoint) * kMaxContainerCapacity);
        
        container_ptr.bomPointContainer = malloc(sizeof(CGPoint) * kMaxContainerCapacity);
        memset(container_ptr.bomPointContainer, 0, sizeof(CGPoint) * kMaxContainerCapacity);
        
        container_ptr.endPointContainer = malloc(sizeof(CGPoint) * kMaxContainerCapacity);
        memset(container_ptr.endPointContainer, 0, sizeof(CGPoint) * kMaxContainerCapacity);
        
        container_ptr.translationPointContainer = malloc(sizeof(CGPoint) * kMaxContainerCapacity);
        memset(container_ptr.translationPointContainer, 0, sizeof(CGPoint) * kMaxContainerCapacity);
    });
    return container_ptr;
}

- (void)addPointAsRefreshChangeformStart:(CGPoint)startPoint Top:(CGPoint)topPoint bottom:(CGPoint)bottomPoint end:(CGPoint)endPoint
{
    static NSInteger currentPointsCount = 0;
    if (currentPointsCount < kMaxContainerCapacity) {
        self.numberOfRefreshElements = currentPointsCount + 1;
        self.refreshPointContainer[currentPointsCount] = startPoint;
        self.topPointContainer[currentPointsCount] = topPoint;
        self.bomPointContainer[currentPointsCount] = bottomPoint;
        self.endPointContainer[currentPointsCount] = endPoint;
        currentPointsCount ++;
    } else {
        NSInteger workIndex = 0;
        while (workIndex != kMaxContainerCapacity - 1) {
            self.refreshPointContainer[workIndex] = self.refreshPointContainer[workIndex + 1];
            self.topPointContainer[workIndex] = self.topPointContainer[workIndex + 1];
            self.bomPointContainer[workIndex] = self.bomPointContainer[workIndex + 1];
            self.endPointContainer[workIndex] = self.endPointContainer[workIndex + 1];

            workIndex ++;
        }
        self.refreshPointContainer[kMaxContainerCapacity - 1] = startPoint;
        self.topPointContainer[kMaxContainerCapacity - 1] = topPoint;
        self.bomPointContainer[kMaxContainerCapacity - 1] = bottomPoint;
        self.endPointContainer[kMaxContainerCapacity - 1] = endPoint;

        self.numberOfRefreshElements = kMaxContainerCapacity;
    }
}

- (void)addPointAsRefreshChangeform:(CGPoint)point
{
    static NSInteger currentPointsCount = 0;
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

- (void)addTopPointAsRefreshChangeform:(CGPoint)point
{
    static NSInteger currentPointsCount = 0;
    if (currentPointsCount < kMaxContainerCapacity) {
        self.numberOfRefreshElements = currentPointsCount + 1;
        self.topPointContainer[currentPointsCount] = point;
        currentPointsCount ++;
    } else {
        NSInteger workIndex = 0;
        while (workIndex != kMaxContainerCapacity - 1) {
            self.topPointContainer[workIndex] = self.topPointContainer[workIndex + 1];
            workIndex ++;
        }
        self.topPointContainer[kMaxContainerCapacity - 1] = point;
        self.numberOfRefreshElements = kMaxContainerCapacity;
    }
}
- (void)addBomPointAsRefreshChangeform:(CGPoint)point
{
    static NSInteger currentPointsCount = 0;
    if (currentPointsCount < kMaxContainerCapacity) {
        self.numberOfRefreshElements = currentPointsCount + 1;
        self.bomPointContainer[currentPointsCount] = point;
        currentPointsCount ++;
    } else {
        NSInteger workIndex = 0;
        while (workIndex != kMaxContainerCapacity - 1) {
            self.bomPointContainer[workIndex] = self.bomPointContainer[workIndex + 1];
            workIndex ++;
        }
        self.bomPointContainer[kMaxContainerCapacity - 1] = point;
        self.numberOfRefreshElements = kMaxContainerCapacity;
    }
}
- (void)addEndPointAsRefreshChangeform:(CGPoint)point
{
    static NSInteger currentPointsCount = 0;
    if (currentPointsCount < kMaxContainerCapacity) {
        self.numberOfRefreshElements = currentPointsCount + 1;
        self.endPointContainer[currentPointsCount] = point;
        currentPointsCount ++;
    } else {
        NSInteger workIndex = 0;
        while (workIndex != kMaxContainerCapacity - 1) {
            self.endPointContainer[workIndex] = self.endPointContainer[workIndex + 1];
            workIndex ++;
        }
        self.endPointContainer[kMaxContainerCapacity - 1] = point;
        self.numberOfRefreshElements = kMaxContainerCapacity;
    }
}

- (void)addPointAsTranslationChangeform:(CGPoint)point
{
    static NSInteger currentPointsCount = 0;
    if (currentPointsCount < kMaxContainerCapacity) {
        self.numberOfTranslationElements = currentPointsCount + 1;
        self.translationPointContainer[currentPointsCount] = point;
        currentPointsCount ++;
    } else {
        NSInteger workIndex = kMaxContainerCapacity - 1;
        while (workIndex != 0) {
            self.translationPointContainer[workIndex].y = self.translationPointContainer[workIndex - 1].y;
            workIndex --;
        }
        self.translationPointContainer[0].x = 0;
        self.translationPointContainer[0].y = point.y;
        self.numberOfTranslationElements = kMaxContainerCapacity;
    }
    
    //    printf("当前元素个数:%2d->",self.numberOfTranslationElements);
    //    for (int k = 0; k != self.numberOfTranslationElements; ++k) {
    //        printf("(%.0f,%.0f)",self.translationPointContainer[k].x,self.translationPointContainer[k].y);
    //    }
    //    putchar('\n');
}

@end

@interface HealthLive ()

@property (nonatomic , assign) CGPoint *points;
@property (nonatomic , assign) CGPoint *toppoints;
@property (nonatomic , assign) CGPoint *bompoints;
@property (nonatomic , assign) CGPoint *endpoints;

@property (nonatomic , assign) NSInteger currentPointsCount;

@end

@implementation HealthLive

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
    CGContextRef context = UIGraphicsGetCurrentContext();
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

- (void)fireDrawingWithPoints:(CGPoint *)points :(CGPoint *)toppoints :(CGPoint *)bompoints :(CGPoint *)endpoints pointsCount:(NSInteger)count
{
    self.currentPointsCount = count;
    self.points = points;
    self.toppoints = toppoints;
    self.bompoints = bompoints;
    self.endpoints = endpoints;
}

- (void)drawCurve
{
    if (self.currentPointsCount == 0) {
        return;
    }
    CGFloat curveLineWidth = 1.0;
    CGContextRef currentContext = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(currentContext, curveLineWidth);
    CGContextSetStrokeColorWithColor(UIGraphicsGetCurrentContext(), AppColor.CGColor);
    
    CGContextMoveToPoint(currentContext, self.points[0].x, self.points[0].y);
    for (int i = 1; i != self.currentPointsCount; ++ i) {
        if (self.points[i - 1].x < self.points[i].x) {
            CGPoint topPoint = {self.toppoints[i].x, self.toppoints[i].y};
            CGPoint bottomPoint = {self.bompoints[i].x, self.bompoints[i].y};
            CGPoint endPoint = {self.endpoints[i].x, self.endpoints[i].y};
            CGContextAddCurveToPoint(currentContext, topPoint.x, topPoint.y, bottomPoint.x, bottomPoint.y, endPoint.x, endPoint.y);
        } else {
            CGContextMoveToPoint(currentContext, self.points[i].x, self.points[i].y);
        }
    }
    CGContextStrokePath(UIGraphicsGetCurrentContext());
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    //    [self drawGrid];
    [self drawCurve];
}

@end
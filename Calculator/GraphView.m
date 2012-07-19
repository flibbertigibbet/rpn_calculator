//
//  GraphView.m
//  Calculator
//
//  Created by Kathryn Killebrew on 7/14/12.
//  Copyright (c) 2012 Banderkat. All rights reserved.
//

#import "GraphView.h"
#import "AxesDrawer.h"

@implementation GraphView
@synthesize dataSource = _dataSource;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        NSLog(@"initWithFrame in GraphView");
    }
    return self;
}


- (void)drawRect:(CGRect)rect
{
    NSLog(@"drawRect in GraphView");
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 2.5);
    
    CGPoint startPoint;
    CGPoint endPoint;
    
    CGRect bounds;
    CGPoint origin;
    CGFloat scale;
    
    bounds = self.bounds;
    scale = [self.dataSource getScale];
    if (!scale) scale = self.contentScaleFactor;
    origin = [self.dataSource getOrigin];
    if (!origin.x) origin = self.center;
    
    CGContextBeginPath(context);
    
    [AxesDrawer drawAxesInRect:bounds originAtPoint:origin scale:scale];
    
    CGFloat xOffeset = origin.x;
    CGFloat yOffset = origin.y;
    CGFloat myWidth = (bounds.size.width + xOffeset) * scale;
    
    endPoint.x = -xOffeset/scale;
    endPoint.y = yOffset-scale*[[self.dataSource getY:endPoint.x - xOffeset] floatValue];
    
    CGFloat pixelIncrement = 1.0/self.contentScaleFactor;
    
    for (CGFloat x=-myWidth; x <= myWidth; x += pixelIncrement) {
        startPoint.x = endPoint.x;
        startPoint.y = endPoint.y;
        endPoint.x = (x - xOffeset) / scale;
        endPoint.y = yOffset-scale*[[self.dataSource getY:endPoint.x - xOffeset] floatValue];
    
        CGContextMoveToPoint(context, startPoint.x, startPoint.y);
        CGContextAddLineToPoint(context, endPoint.x, endPoint.y);
    }
    
    CGContextStrokePath(context);
}

@end

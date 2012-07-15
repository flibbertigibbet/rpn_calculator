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
    origin = self.center;
    scale = self.contentScaleFactor;
    
    CGContextBeginPath(context);
    
    [AxesDrawer drawAxesInRect:bounds originAtPoint:origin scale:scale];
    
    CGFloat myWidth = bounds.size.width;
    CGFloat myHeight = bounds.size.height;
    CGFloat xOffeset = myWidth / 2;
    CGFloat yOffset = myHeight / 2;
    
    endPoint.x = 0;
    endPoint.y = [[self.dataSource getY:endPoint.x] floatValue];
    
    for (CGFloat x=0; x <= myWidth; x++) {
        startPoint.x = endPoint.x;
        startPoint.y = endPoint.y;
        endPoint.x = x;
        endPoint.y = -[[self.dataSource getY:endPoint.x - xOffeset] floatValue] + yOffset;
    
        CGContextMoveToPoint(context, startPoint.x, startPoint.y);
        CGContextAddLineToPoint(context, endPoint.x, endPoint.y);
    }
    
    CGContextStrokePath(context);
}

@end

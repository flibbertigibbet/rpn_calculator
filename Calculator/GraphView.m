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
    
    NSLog(@"%@%g", @"scale ", scale);
    
    CGContextBeginPath(context);
    
    [AxesDrawer drawAxesInRect:bounds originAtPoint:origin scale:scale];
    
    CGFloat xOffeset = origin.x;
    CGFloat yOffset = origin.y;
    CGFloat myWidth = bounds.size.width;
    
    CGFloat pixelIncrement = 1.0/self.contentScaleFactor;
    
    /*
    NSLog(@"%@%g%@%g", @"graph origin x ", endPoint.x, 
          @"  graph origin y ", endPoint.y);
    NSLog(@"%@%g%@%g", @"start x ", -xOffeset / scale, @"  start y ", [[self.dataSource getY:(-xOffeset / scale)] floatValue]);
    CGPoint graphEnd;
    graphEnd.x = (myWidth - xOffeset) / scale;
    graphEnd.y = [[self.dataSource getY:graphEnd.x] floatValue];
    NSLog(@"%@%g%@%g", @"end graph x ", graphEnd.x, 
          @" end graph y ", graphEnd.y);
    */
    
    endPoint.x = 0;
    endPoint.y = [[self.dataSource getY:(-xOffeset / scale)] floatValue];
    
    for (CGFloat x=0; x <= myWidth; x+=pixelIncrement) {
        startPoint.x = endPoint.x;
        startPoint.y = endPoint.y;
        
        //graphPoint.x = (x - xOffeset) / scale;
        //graphPoint.y = [[self.dataSource getY:graphPoint.x] floatValue];
        //NSLog(@"%@%g%@%g", @"graph x ", graphPoint.x, @"  graph y ", graphPoint.y);
        //endPoint.y = yOffset - (graphPoint.y * scale);
        
        endPoint.x = x;
        endPoint.y = yOffset - ([[self.dataSource getY:(x - xOffeset) / scale] floatValue] * scale);
        
    
        CGContextMoveToPoint(context, startPoint.x, startPoint.y);
        CGContextAddLineToPoint(context, endPoint.x, endPoint.y);
    }

       
    CGContextStrokePath(context);
    CGContextStrokePath(context);
}

@end

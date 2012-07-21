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
@synthesize scale = _scale;
@synthesize origin = _origin;

-(CGPoint) origin {
    if (!_origin.x) _origin = CGPointMake(self.center.x, self.center.y);
    return _origin;
}

-(CGFloat) scale {
    if (!_scale) _scale = self.contentScaleFactor;
    return _scale;
}

-(void) setScale:(CGFloat)scale {
    _scale = scale;
    if (!_scale) _scale = self.contentScaleFactor;
    [self setNeedsDisplay];
}

-(void) setOrigin:(CGPoint)origin {
    _origin = origin;
    [self setNeedsDisplay];
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) self.contentMode = UIViewContentModeRedraw;
    return self;
}

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 2.5);
    CGPoint startPoint;
    CGPoint endPoint;
    CGRect bounds;
    
    bounds = self.bounds;
    CGContextBeginPath(context);
    [AxesDrawer drawAxesInRect:bounds originAtPoint:self.origin 
                         scale:self.scale];
    
    CGContextSetLineWidth(context, 2.0);
    CGContextSetStrokeColorWithColor(context, [UIColor blueColor].CGColor);
    
    CGFloat xOffeset = self.origin.x;
    CGFloat yOffset = self.origin.y;
    CGFloat myWidth = bounds.size.width;
    CGFloat pixelIncrement = 1.0 / self.contentScaleFactor;
    endPoint.x = 0;
    endPoint.y = [[self.dataSource getY:( -xOffeset / self.scale)] floatValue];
    
    for (CGFloat x=0; x <= myWidth; x+=pixelIncrement) {
        startPoint.x = endPoint.x;
        startPoint.y = endPoint.y;
        endPoint.x = x;
        endPoint.y = yOffset - ([[self.dataSource getY:(x - xOffeset) / 
                                  self.scale] floatValue] * self.scale);
        CGContextMoveToPoint(context, startPoint.x, startPoint.y);
        CGContextAddLineToPoint(context, endPoint.x, endPoint.y);
    }
    CGContextStrokePath(context);
    CGContextStrokePath(context);
}

@end

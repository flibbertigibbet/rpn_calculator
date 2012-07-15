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

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


- (void)drawRect:(CGRect)rect
{
    // Drawing code
    CGRect bounds;
    CGPoint origin;
    CGFloat scale;
    
    bounds = self.bounds;
    origin = self.center;
    scale = 1.0;
    
    [AxesDrawer drawAxesInRect:bounds originAtPoint:origin scale:scale];
}

@end

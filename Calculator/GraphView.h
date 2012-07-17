//
//  GraphView.h
//  Calculator
//
//  Created by Kathryn Killebrew on 7/14/12.
//  Copyright (c) 2012 Banderkat. All rights reserved.
//

#import <UIKit/UIKit.h>
@class GraphView;
@protocol GraphDataSource
- (id) getY:(CGFloat) x;
@optional
- (CGFloat) getScale;
- (CGPoint) getOrigin;
@end
@interface GraphView : UIView
@property (nonatomic, weak) IBOutlet id <GraphDataSource> dataSource;
@end

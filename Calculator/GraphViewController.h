//
//  GraphViewController.h
//  Calculator
//
//  Created by Kathryn Killebrew on 7/14/12.
//  Copyright (c) 2012 Banderkat. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GraphView.h"
#import "CalculatorViewController.h"
@class GraphViewController;

@interface GraphViewController : UIViewController <UISplitViewControllerDelegate>
-(id) getY : (CGFloat) x;
-(CGFloat) getScale;
-(CGPoint) getOrigin;
@property (weak, nonatomic) IBOutlet UILabel *programDescription;
@property (strong, nonatomic) IBOutlet UIPinchGestureRecognizer *pinched;
@property (strong, nonatomic) IBOutlet UIPanGestureRecognizer *panned;
@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *tapped;
@end

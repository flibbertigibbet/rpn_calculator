//
//  CalculatorViewController.h
//  Calculator
//
//  Created by Kathryn Killebrew on 6/30/12.
//  Copyright (c) 2012 Kathryn Killebrew. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GraphViewController.h"
@class CalculatorViewController;
@protocol RunProtocol <NSObject>
-(void) setProgram:(id) p;
@end
@interface CalculatorViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *display;
@property (weak, nonatomic) IBOutlet UILabel *sentToBrain;
@property (weak, nonatomic) id <RunProtocol> delegate;
-(void)setDelegate:(id<RunProtocol>)delegate;
@end

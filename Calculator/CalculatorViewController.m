//
//  CalculatorViewController.m
//  Calculator
//
//  Created by kat on 6/30/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CalculatorViewController.h"

@interface CalculatorViewController ()
@property (nonatomic) BOOL userIsInTheMiddleOfEnteringANumber;
@end

@implementation CalculatorViewController
@synthesize display;
@synthesize userIsInTheMiddleOfEnteringANumber;

- (IBAction)digitPressed:(UIButton *)sender {
    NSString *digit = sender.currentTitle;
    
    NSLog(@"user touched %@", digit);       // DEBUG PRINT
    
    if (self.userIsInTheMiddleOfEnteringANumber) {
        self.display.text = [self.display.text stringByAppendingString:digit];
    } else {
        self.display.text = digit;
        self.userIsInTheMiddleOfEnteringANumber = YES;
    }
}
- (IBAction)enterPressed {
}

- (IBAction)operationPressed:(UIButton *)sender {
}

@end

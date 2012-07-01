//
//  CalculatorViewController.m
//  Calculator
//
//  Created by kat on 6/30/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CalculatorViewController.h"
#import "CalculatorBrain.h"

@interface CalculatorViewController ()
@property (nonatomic) BOOL userIsInTheMiddleOfEnteringANumber;
@property (nonatomic) BOOL userHasAlreadyPressedDecimalPoint;
@property (nonatomic, strong) CalculatorBrain *brain;
@end

@implementation CalculatorViewController
@synthesize display = _display;
@synthesize sentToBrain = _sentToBrain;
@synthesize userIsInTheMiddleOfEnteringANumber = \
        _userIsInTheMiddleOfEnteringANumber;
@synthesize userHasAlreadyPressedDecimalPoint = \
        _userHasAlreadyPressedDecimalPoint;
@synthesize brain = _brain;

- (CalculatorBrain *)brain
{
    if (!_brain) _brain = [[CalculatorBrain alloc] init];
    return _brain;
}

- (IBAction)digitPressed:(UIButton *)sender 
{
    NSString *digit = sender.currentTitle;
    
    if (self.userIsInTheMiddleOfEnteringANumber) {
        self.display.text = [self.display.text stringByAppendingString:digit];
    } else {
        self.display.text = digit;
        self.userIsInTheMiddleOfEnteringANumber = YES;
    }
}

- (IBAction)decimalPointPressed 
{
    if (!self.userHasAlreadyPressedDecimalPoint) {
        if (self.userIsInTheMiddleOfEnteringANumber) {
            self.display.text = \
            [self.display.text stringByAppendingString:@"."];
        } else {
            // in case the decimal point is first 
            self.display.text = @"0.";
            self.userIsInTheMiddleOfEnteringANumber = YES;
        }
        self.userHasAlreadyPressedDecimalPoint = YES;
    }
}

- (IBAction)enterPressed
{
    [self.brain pushOperand:[self.display.text doubleValue]];
    
    // append value followed by space to label of all entries
    self.sentToBrain.text = [NSString stringWithFormat:@"%@%@%@", \
                             self.sentToBrain.text, self.display.text, @" "];
    
    self.userIsInTheMiddleOfEnteringANumber = NO;
    self.userHasAlreadyPressedDecimalPoint = NO;
}

- (IBAction)operationPressed:(UIButton *)sender
{
    if (self.userIsInTheMiddleOfEnteringANumber) {
        [self enterPressed];
    }
    
    NSString *operation = sender.currentTitle;
    
    // append operation followed by space to label of all entries
    self.sentToBrain.text = [NSString stringWithFormat:@"%@%@%@", \
                             self.sentToBrain.text, operation, @" "];
    
    double result = [self.brain performOperation:operation];
    self.display.text = [NSString stringWithFormat:@"%g", result];
}

- (IBAction)clearPressed {
    [self.brain clear]; // empty stack in model
    self.display.text = @"0";
    self.sentToBrain.text = @"";
}

@end

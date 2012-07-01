//
//  CalculatorViewController.m
//  Calculator
//
//  Created by Kathryn Killebrew on 6/30/12.
//  Copyright (c) 2012 Kathryn Killebrew. All rights reserved.
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

- (CalculatorBrain *)brain {
    if (!_brain) _brain = [[CalculatorBrain alloc] init];
    return _brain;
}

- (IBAction)digitPressed:(UIButton *)sender {
    NSString *digit = sender.currentTitle;
    
    if (_userIsInTheMiddleOfEnteringANumber) {
        _display.text = [_display.text stringByAppendingString:digit];
    } else {
        _display.text = digit;
        _userIsInTheMiddleOfEnteringANumber = YES;
    }
}

- (IBAction)decimalPointPressed {
    if (!self.userHasAlreadyPressedDecimalPoint) {
        if (_userIsInTheMiddleOfEnteringANumber) {
            _display.text = \
            [_display.text stringByAppendingString:@"."];
        } else {
            // in case the decimal point is first 
            _display.text = @"0.";
            _userIsInTheMiddleOfEnteringANumber = YES;
        }
        self.userHasAlreadyPressedDecimalPoint = YES;
    }
}

- (IBAction)backspacePressed {
    // remove last digit entered from display
    _display.text = \
    [_display.text substringToIndex:[_display.text length] - 1];
    
    if (![_display.text length]) {
        // display a zero if no digits left to display
        _display.text = @"0";
    }
}

- (IBAction)enterPressed {
    [self.brain pushOperand:[_display.text doubleValue]];
    
    // append value followed by space to label of all entries
    _sentToBrain.text = [NSString stringWithFormat:@"%@%@%@", \
                             _sentToBrain.text, _display.text, @" "];
    
    _userIsInTheMiddleOfEnteringANumber = NO;
    self.userHasAlreadyPressedDecimalPoint = NO;
}

- (IBAction)operationPressed:(UIButton *)sender {
    if (_userIsInTheMiddleOfEnteringANumber) {
        [self enterPressed];
    }
    
    NSString *operation = sender.currentTitle;
    
    // append operation followed by space to label of all entries
    _sentToBrain.text = [NSString stringWithFormat:@"%@%@%@", \
                             _sentToBrain.text, operation, @" "];
    
    double result = [self.brain performOperation:operation];
    _display.text = [NSString stringWithFormat:@"%g", result];
}

- (IBAction)clearPressed {
    [self.brain clear]; // empty stack in model
    _display.text = @"0";
    _sentToBrain.text = @"";
}

@end

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
    
    if (self.userIsInTheMiddleOfEnteringANumber) {
        self.display.text = [self.display.text stringByAppendingString:digit];
    } else {
        self.display.text = digit;
        self.userIsInTheMiddleOfEnteringANumber = YES;
    }
}

- (IBAction)decimalPointPressed {
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

- (IBAction)backspacePressed {
    // remove last digit entered from display
    self.display.text = \
    [self.display.text substringToIndex:[self.display.text length] - 1];
    
    if (![self.display.text length]) {
        // display a zero if no digits left to display
        self.display.text = @"0";
    }
}

- (IBAction)plusMinusPressed {
    // switch sign on display
    self.display.text = [NSString stringWithFormat:@"%g", 
                     -[self.display.text doubleValue]];
    
    // if user not currently entering a number, enter value
    if (!self.userIsInTheMiddleOfEnteringANumber) {
        [self enterPressed];
    }
}

- (IBAction)enterPressed {
    [self.brain pushOperand:[self.display.text doubleValue]];
    
    // append value followed by space to label of all entries
    [self appendToHistory:self.display.text:NO];
    
    self.userIsInTheMiddleOfEnteringANumber = NO;
    self.userHasAlreadyPressedDecimalPoint = NO;
}

- (IBAction)operationPressed:(UIButton *)sender {
    if (self.userIsInTheMiddleOfEnteringANumber) {
        [self enterPressed];
    }
    
    NSString *operation = sender.currentTitle;
    
    // append operation followed by " =" to label of all entries
    [self appendToHistory:operation:YES];
    
    double result = [self.brain performOperation:operation];
    self.display.text = [NSString stringWithFormat:@"%g", result];
}

- (IBAction)clearPressed {
    [self.brain clear]; // empty stack in model
    self.display.text = @"0";
    self.sentToBrain.text = @"";
}

- (void)appendToHistory:(NSString *)value:(BOOL)isOperation {
    // append value to sentToBrain label
    // put = at end of label, if value is an operation
    NSString *history = self.sentToBrain.text;
    int histlen = [history length];
    
    // shave off = from current label value, if there
    if (histlen > 0) {
        if ([[history substringFromIndex:histlen - 1] \
            isEqualToString:@"="]) {
            
            history = [history substringToIndex:histlen - 1];
        }
    }
    
    if (isOperation) {
        history = [NSString stringWithFormat:@"%@%@%@", history,
                   value, @" ="];
    } else {
    history = [NSString stringWithFormat:@"%@%@%@", history,
               value, @" "];
    }
    
    // display new history
    self.sentToBrain.text = history;
}

@end

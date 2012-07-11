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
@property (nonatomic) BOOL inTheMiddleOfEnteringANumber;
@property (nonatomic) BOOL alreadyPressedDecimalPoint;
@property (nonatomic, strong) CalculatorBrain *brain;
@end

@implementation CalculatorViewController
@synthesize display = _display;
@synthesize sentToBrain = _sentToBrain;
@synthesize inTheMiddleOfEnteringANumber = _inTheMiddleOfEnteringANumber;
@synthesize alreadyPressedDecimalPoint = _alreadyPressedDecimalPoint;
@synthesize brain = _brain;

- (CalculatorBrain *)brain {
    if (!_brain) _brain = [[CalculatorBrain alloc] init];
    return _brain;
}

- (IBAction)digitPressed:(UIButton *)sender {
    NSString *digit = sender.currentTitle;
    
    if (self.inTheMiddleOfEnteringANumber) {
        self.display.text = [self.display.text stringByAppendingString:digit];
    } else {
        self.display.text = digit;
        self.inTheMiddleOfEnteringANumber = YES;
    }
}

- (IBAction)decimalPointPressed {
    if (!self.alreadyPressedDecimalPoint) {
        if (self.inTheMiddleOfEnteringANumber) {
            self.display.text = \
            [self.display.text stringByAppendingString:@"."];
        } else {
            // in case the decimal point is first 
            self.display.text = @"0.";
            self.inTheMiddleOfEnteringANumber = YES;
        }
        self.alreadyPressedDecimalPoint = YES;
    }
}

- (IBAction)backspacePressed {
    // remove last digit entered from display
    self.display.text = \
    [self.display.text substringToIndex:[self.display.text length] - 1];
    
    if (![self.display.text length]) {
        // TODO: change to show results of current program
        // TODO: update brain's history
        self.display.text = @"0";
        //self.display.text = [self.brain
    }
}

- (IBAction)plusMinusPressed {
    // switch sign on display
    self.display.text = [NSString stringWithFormat:@"%g", 
                     -[self.display.text doubleValue]];
    
    // if user not currently entering a number, enter value
    if (!self.inTheMiddleOfEnteringANumber) {
        [self enterPressed];
    }
}

- (IBAction)enterPressed {
    [self.brain pushOperand:[self.display.text doubleValue]];
    
    // append value followed by space to label of all entries
    [self refreshHistory];
    
    self.inTheMiddleOfEnteringANumber = NO;
    self.alreadyPressedDecimalPoint = NO;
}

- (IBAction)operationPressed:(UIButton *)sender {
    
    if (self.inTheMiddleOfEnteringANumber) {
        [self enterPressed];
    }
    
    NSString *operation = sender.currentTitle;  
    
    double result = [self.brain performOperation:operation];
    self.display.text = [NSString stringWithFormat:@"%g", result];
    [self refreshHistory];
    
    // append operation followed by " =" to label of all entries
    // [self appendToHistory:operation];

}

- (IBAction)clearPressed {
    [self.brain clearStack]; // empty stack in model
    self.display.text = @"0";
    self.sentToBrain.text = @"";
}

- (void)refreshHistory {
    NSString *history = [[self.brain class] descriptionOfProgram:[self.brain program]];
    self.sentToBrain.text = history;
}

@end

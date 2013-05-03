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
@property (nonatomic) NSMutableDictionary *enteredVariables;
@end

@implementation CalculatorViewController
@synthesize display = _display;
@synthesize sentToBrain = _sentToBrain;
@synthesize inTheMiddleOfEnteringANumber = _inTheMiddleOfEnteringANumber;
@synthesize alreadyPressedDecimalPoint = _alreadyPressedDecimalPoint;
@synthesize brain = _brain;
@synthesize enteredVariables = _enteredVariables;
@synthesize delegate = _delegate;

-(NSDictionary *)enteredVariables {
    if (!_enteredVariables) {
        _enteredVariables = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
            [NSNumber numberWithDouble: 0.0], @"x", nil];
    }
    return _enteredVariables;
}

- (CalculatorBrain *)brain {
    if (!_brain) _brain = [[CalculatorBrain alloc] init];
    return _brain;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"GraphSegue"]) {
        // set program to graph
        [segue.destinationViewController setProgram:self.brain.program];
    }
}

- (IBAction)graphPressed {
    // TODO
    NSLog(@"graphPressed");
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        NSLog(@"on iPad");
        
        //TODO        
        [self.delegate setProgram:self.brain.program];
    }
}

-(void)setVariable:(NSString *)varName toValue:(double)toValue {
    if (toValue) [self.enteredVariables setValue:
                  [NSNumber numberWithDouble:toValue] forKey:varName];
}

- (IBAction)variablePressed:(UIButton *)sender {
    if (self.inTheMiddleOfEnteringANumber) [self enterPressed];
    [self.brain pushVariableOperand:sender.currentTitle];
    id myval = [self.enteredVariables valueForKey:sender.currentTitle];
    if (myval) {
        self.display.text = [NSString  stringWithFormat:@"%@",myval];
    } else {
        self.display.text = @"0"; 
    }
    [self refreshHistory];
    self.inTheMiddleOfEnteringANumber = NO;
    self.alreadyPressedDecimalPoint = NO;
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
    self.display.text = \
    [self.display.text substringToIndex:[self.display.text length] - 1];
    
    if (![self.display.text length]) {
        self.inTheMiddleOfEnteringANumber = NO;
        self.alreadyPressedDecimalPoint = NO;
        self.display.text = [NSString stringWithFormat:@"%g", 
            [[self.brain class] runProgram:[self.brain program] 
            usingVariableValues:[self.enteredVariables copy]]];
        [self refreshHistory];
    }
}

- (IBAction)plusMinusPressed {
    // switch sign on display
    self.display.text = [NSString stringWithFormat:@"%g", 
                 -[self.display.text doubleValue]];
    if (!self.inTheMiddleOfEnteringANumber) [self enterPressed];
}

- (IBAction)enterPressed {
    [self.brain pushOperand:[self.display.text doubleValue]];
    [self refreshHistory];
    self.inTheMiddleOfEnteringANumber = NO;
    self.alreadyPressedDecimalPoint = NO;
}

- (IBAction)operationPressed:(UIButton *)sender {
    if (self.inTheMiddleOfEnteringANumber) [self enterPressed];
    NSString *operation = sender.currentTitle;  
    double result = [self.brain performOperation:operation 
                                       usingVars:[self.enteredVariables copy]];
    if (isnan(result)) {
        // change history display text to red when 0 substituting for NaN
        // (change back on clear)
        self.sentToBrain.textColor = [UIColor redColor];
        result = 0;
    }

    self.display.text = [NSString stringWithFormat:@"%g", result];
    [self refreshHistory];
}

- (IBAction)clearPressed {
    [self.brain clearStack]; // empty stack in model
    [self.enteredVariables removeAllObjects];
    self.display.text = @"0";
    self.sentToBrain.text = @"";
    self.sentToBrain.textColor = [UIColor blackColor];
    self.inTheMiddleOfEnteringANumber = NO;
    self.alreadyPressedDecimalPoint = NO;
}

- (void)refreshHistory {
    NSString *history = [[self.brain class] 
                         descriptionOfProgram:[self.brain program]];
    self.sentToBrain.text = history;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:
                        (UIInterfaceOrientation)interfaceOrientation {
    return (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) ? 
        UIInterfaceOrientationPortrait : YES;
}

- (void)awakeFromNib
{
    self.contentSizeForViewInPopover = CGSizeMake(320.0, 600.0);
    [super awakeFromNib];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    self.delegate = nil;
}

@end

//
//  CalculatorBrain.m
//  Calculator
//
//  Created by Kathryn Killebrew on 6/30/12.
//  Copyright (c) 2012 Kathryn Killebrew. All rights reserved.
//

#import "CalculatorBrain.h"

@interface CalculatorBrain()
@property (nonatomic, strong) NSMutableArray *operandStack;
@end

@implementation CalculatorBrain

@synthesize operandStack = _operandStack;

- (NSMutableArray *)operandStack {
    if (!_operandStack) {
        _operandStack = [[NSMutableArray alloc] init];
    }
    return _operandStack;
}

- (void) pushOperand:(double)operand {
    NSNumber *operandObject = [NSNumber numberWithDouble:operand];
    [self.operandStack addObject:operandObject];
}

- (double) popOperand {
    NSNumber *operandObject = [self.operandStack lastObject];
    if (operandObject) [self.operandStack removeLastObject];
    return [operandObject doubleValue];
}

- (double) performOperation:(NSString *)operation {    
    double result = 0;
    
    // perform operation and store answer in result
    if ([operation isEqualToString:@"+"]) {
        // add
        result = [self popOperand] + [self popOperand];
    } else if ([operation isEqualToString:@"×"]) {
        // multiply
        result = [self popOperand] * [self popOperand];
    } else if ([operation isEqualToString:@"-"]) {
        // subtract
        double subtrahend = [self popOperand];
        result = [self popOperand] - subtrahend;
    } else if ([operation isEqualToString:@"÷"]) {
        // divide
        double divisor = [self popOperand];
        if (divisor) result = [self popOperand] / divisor;
    } else if ([operation isEqualToString:@"sin"]) {
        // sine
        result = sin([self popOperand]);
        
    } else if ([operation isEqualToString:@"cos"]) {
        // cosine
        result = cos([self popOperand]);
    
    } else if ([operation isEqualToString:@"√"]) {
        // square root
        result = sqrt([self popOperand]);
        
    } else if ([operation isEqualToString:@"π"]) {
        // pi
        result = M_PI;
    }
    
    // protect against propogating NaN by changing NaN results to zero
    if (isnan(result)) {
        result = 0;
    }
    
    [self pushOperand:result];
    return result;
}

- (void) clear
{
    // empty stack
    [self.operandStack removeAllObjects];
}

@end

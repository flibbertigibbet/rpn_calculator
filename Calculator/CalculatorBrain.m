//
//  CalculatorBrain.m
//  Calculator
//
//  Created by Kathryn Killebrew on 6/30/12.
//  Copyright (c) 2012 Kathryn Killebrew. All rights reserved.
//

#import "CalculatorBrain.h"

@interface CalculatorBrain()
@property (nonatomic, strong) NSMutableArray *programStack;
@end

@implementation CalculatorBrain

@synthesize programStack = _programStack;

- (NSMutableArray *)programStack {
    if (!_programStack) {
        _programStack = [[NSMutableArray alloc] init];
    }
    return _programStack;
}

- (id)program
{
    return [self.programStack copy];
}

+ (NSString *)descriptionOfProgram:(id)program
{
    return @"Implement this in Homework #2";
}


- (void) pushOperand:(double)operand {
    [self.programStack addObject:[NSNumber numberWithDouble:operand]];
}

- (double) popOperand {
    NSNumber *operandObject = [self.programStack lastObject];
    if (operandObject) [self.programStack removeLastObject];
    return [operandObject doubleValue];
}

- (double)performOperation:(NSString *)operation
{
    [self.programStack addObject:operation];
    return [[self class] runProgram:self.program];
}

+ (double)popOperandOffProgramStack:(NSMutableArray *)stack
{
    double result = 0;
    id topOfStack = [stack lastObject];
    if (topOfStack) [stack removeLastObject];
    
    if ([topOfStack isKindOfClass:[NSNumber class]])
    {
        result = [topOfStack doubleValue];
    }
    else if ([topOfStack isKindOfClass:[NSString class]])
    {
        NSString *operation = topOfStack;
    
        if ([operation isEqualToString:@"+"]) {
            // add
            result = [self popOperandOffProgramStack:stack] + [self popOperandOffProgramStack:stack];
        } else if ([operation isEqualToString:@"×"]) {
            // multiply
            result = [self popOperandOffProgramStack:stack] * [self popOperandOffProgramStack:stack];
        } else if ([operation isEqualToString:@"-"]) {
            // subtract
            double subtrahend = [self popOperandOffProgramStack:stack];
            result = [self popOperandOffProgramStack:stack] - subtrahend;
        } else if ([operation isEqualToString:@"÷"]) {
            // divide
            double divisor = [self popOperandOffProgramStack:stack];
            if (divisor) result = [self popOperandOffProgramStack:stack] / divisor;
        } else if ([operation isEqualToString:@"sin"]) {
            // sine
            result = sin([self popOperandOffProgramStack:stack]);
            
        } else if ([operation isEqualToString:@"cos"]) {
            // cosine
            result = cos([self popOperandOffProgramStack:stack]);
            
        } else if ([operation isEqualToString:@"√"]) {
            // square root
            result = sqrt([self popOperandOffProgramStack:stack]);
            
        } else if ([operation isEqualToString:@"π"]) {
            // pi
            result = M_PI;
        }
    }
    
    if (isnan(result)) {
        result = 0;
    }
    
    return result;
}

- (void) clear
{
    [self.programStack removeAllObjects];
}

+ (double)runProgram:(id)program
{
    NSMutableArray *stack;
    if ([program isKindOfClass:[NSArray class]]) {
        stack = [program mutableCopy];
    }
    return [self popOperandOffProgramStack:stack];
}

@end

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

- (id)program {
    return [self.programStack copy];
}

+ (NSString *)descriptionOfProgram:(id)program {
    // TODO:
    return @"Implement this in Homework #2";
}

- (void)pushVariableOperand:(NSString *)var {
    if (![[self class] isOperation:var]) {
        [self.programStack addObject:var];
    }
}

- (void) pushOperand:(double)operand {
    [self.programStack addObject:[NSNumber numberWithDouble:operand]];
}

- (double)popOperand {
    NSNumber *operandObject = [self.programStack lastObject];
    if (operandObject) [self.programStack removeLastObject];
    return [operandObject doubleValue];
}

- (double)performOperation:(NSString *)operation {
    [self.programStack addObject:operation];
    return [[self class] runProgram:self.program];
}

- (void)clearStack {
    [self.programStack removeAllObjects];
}


+ (double)popOperandOffProgramStack:(NSMutableArray *)stack {
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
            result = [self popOperandOffProgramStack:stack] + [self popOperandOffProgramStack:stack];
        } else if ([operation isEqualToString:@"×"]) {
            result = [self popOperandOffProgramStack:stack] * [self popOperandOffProgramStack:stack];
        } else if ([operation isEqualToString:@"-"]) {
            double subtrahend = [self popOperandOffProgramStack:stack];
            result = [self popOperandOffProgramStack:stack] - subtrahend;
        } else if ([operation isEqualToString:@"÷"]) {
            double divisor = [self popOperandOffProgramStack:stack];
            if (divisor) result = [self popOperandOffProgramStack:stack] / divisor;
        } else if ([operation isEqualToString:@"sin"]) {
            result = sin([self popOperandOffProgramStack:stack]);
            
        } else if ([operation isEqualToString:@"cos"]) {
            result = cos([self popOperandOffProgramStack:stack]);
            
        } else if ([operation isEqualToString:@"√"]) {
            result = sqrt([self popOperandOffProgramStack:stack]);
            
        } else if ([operation isEqualToString:@"π"]) {
            result = M_PI;
        }
    }
    
    if (isnan(result)) {
        result = 0;
    }
    
    return result;
}

+ (BOOL)isOperation:(NSString *)myOp {
    return [[NSSet setWithObjects:@"+", @"×", @"-", @"÷", @"sin", @"cos", 
             @"√", @"π", nil] containsObject:myOp];
}

+ (double)runProgram:(id)program
 usingVariableValues:(NSDictionary *)variableValues {
    NSMutableArray *stack;
    if ([program isKindOfClass:[NSArray class]]) {
        stack = [program mutableCopy];
    }
    
    NSSet *myVars = [self variablesUsedInProgram:stack];
    id newVal;
        
    for (id item in stack) {
        if ([myVars member:item]) {
            NSUInteger myOffset = [stack indexOfObject:item];
            newVal = [variableValues objectForKey:item];
            if (!newVal || ![newVal isKindOfClass:[NSNumber class]]) {
                newVal = 0;
            }
            [stack replaceObjectAtIndex:myOffset withObject:newVal];
        }
    }
    return [self popOperandOffProgramStack:stack];
}

+ (NSSet *)variablesUsedInProgram:(id)program {
    NSMutableSet *variables = [[NSMutableSet alloc] init];
    NSArray *stack;
    if ([program isKindOfClass:[NSArray class]]) {
        stack = [program copy];
    }

    for (id item in stack) {
        if ([item isKindOfClass:[NSString class]]) {
            NSString *str = item;
            if (![self isOperation:str]) {
                [variables addObject:str];
            }
        }
    }
    
    if ([variables count] < 1) {
        variables = nil;
    }
    return variables;
}

+ (double)runProgram:(id)program {
    return [self runProgram:program usingVariableValues:nil];
}

@end

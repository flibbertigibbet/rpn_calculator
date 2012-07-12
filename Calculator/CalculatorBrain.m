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
    NSMutableArray *statements = [[NSMutableArray alloc] init];
    NSArray *stack;
    NSString *desc;
    if ([program isKindOfClass:[NSArray class]]) stack = [program mutableCopy];
    while (stack.count) [statements addObject:[self 
                                        descriptionOfTopOfStack:stack:nil]];
    desc = [statements componentsJoinedByString:@", "];
    return desc;
}

+(NSString *)descriptionOfTopOfStack:(id)stack:(NSString *)parent {
    NSString *desc = @"0";
    int numops;
    id holdArg;
    id thisArg;
    bool wrap = true;
    id obj = [stack lastObject];
    if (obj) [stack removeLastObject];
    
    if (!parent) wrap = false; // no parens around top level
        
    if ([obj isKindOfClass:[NSNumber class]]) {
        wrap = false;
        desc = [NSString stringWithFormat:@"%g", [obj doubleValue]];
    } else if ([obj isKindOfClass:[NSString class]]) {
        if ([[self class] isOperation:obj]) {
            numops = [self numberOfOperands:obj];
            
            // no parens if parent stmt is same kind (except division)
            if (![obj isEqual:@"÷"]) if ([obj isEqual:parent]) wrap = false;
            // no parens if parent stmt takes 0 or 1 operand
            if ([self numberOfOperands:parent] != 2) wrap = false;
            
            switch (numops) {
                case 2:
                    holdArg = [self descriptionOfTopOfStack:stack:obj];
                    desc = [NSString stringWithFormat:@"%@%@%@",
                            [self descriptionOfTopOfStack:stack:obj], 
                            obj, holdArg];
                    break;
                case 1:
                    wrap = false;
                    thisArg = [self descriptionOfTopOfStack:stack:obj];
                    desc = [NSString stringWithFormat:@"%@%@%@%@", obj, @"(",
                        thisArg, @")"];
                    break;
                default:
                    wrap = false;
                    desc = obj;
                    break;
            }
        } else {
            wrap = false;
            desc = obj; // a variable
        }
    }
    
    if (wrap) desc = [NSString stringWithFormat:@"%@%@%@", @"(", desc, @")"];
    return desc;
}

+(int)numberOfOperands:(NSString *)opName {
    NSArray *oneOperand = [[NSArray alloc] initWithObjects:@"sin", @"cos", 
        @"√", nil];
    NSArray *twoOperands = [[NSArray alloc] initWithObjects:@"+", @"-",
        @"×", @"÷", nil];
    
    if ([twoOperands containsObject:opName]) {
        return 2;
    } else if ([oneOperand containsObject:opName]) {
        return 1;
    } else {
        return 0;
    }
}

- (void)pushVariableOperand:(NSString *)var {
    if (![[self class] isOperation:var]) {
        [self.programStack addObject:var];
    }
}

- (void) pushOperand:(double)operand {
    [self.programStack addObject:[NSNumber numberWithDouble:operand]];
}

- (double)performOperation:(NSString *)operation usingVars:(NSDictionary *)withVals {
    [self.programStack addObject:operation];
    return [[self class] runProgram:self.program usingVariableValues:withVals];
}

- (void)clearStack {
    [self.programStack removeAllObjects];
}


+ (double)popOperandOffProgramStack:(NSMutableArray *)stack {
    double result = 0;
    id topOfStack = [stack lastObject];
    if (topOfStack) [stack removeLastObject];
    
    if ([topOfStack isKindOfClass:[NSNumber class]]) {
        result = [topOfStack doubleValue];
    } else if ([topOfStack isKindOfClass:[NSString class]]) {
        NSString *operation = topOfStack;
        
        if ([operation isEqualToString:@"+"]) {
            result = [self popOperandOffProgramStack:stack] + 
            [self popOperandOffProgramStack:stack];
        } else if ([operation isEqualToString:@"×"]) {
            result = [self popOperandOffProgramStack:stack] * 
            [self popOperandOffProgramStack:stack];
        } else if ([operation isEqualToString:@"-"]) {
            double subtrahend = [self popOperandOffProgramStack:stack];
            result = [self popOperandOffProgramStack:stack] - subtrahend;
        } else if ([operation isEqualToString:@"÷"]) {
            double divisor = [self popOperandOffProgramStack:stack];
            if (divisor)result = [self popOperandOffProgramStack:stack]/divisor;
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
    
    if (isnan(result)) result = 0;
    return result;
}

+ (BOOL)isOperation:(NSString *)myOp {
    return [[NSSet setWithObjects:@"+", @"×", @"-", @"÷", @"sin", 
             @"cos", @"√", @"π", nil] containsObject:myOp];
}

+ (double)runProgram:(id)program usingVariableValues:(NSDictionary *)vars {
    NSMutableArray *stack;
    if ([program isKindOfClass:[NSArray class]]) stack = [program mutableCopy];
    NSSet *myVars = [self variablesUsedInProgram:stack];
    id newVal = [NSNumber numberWithDouble:0.0];
    
    for (int i=0; i<[stack count]; i++) {
        id item = [stack objectAtIndex:i];
        if ([myVars member:item]) {
            NSUInteger myOffset = [stack indexOfObject:item];
            newVal = [vars objectForKey:item];
            if (!newVal || ![newVal isKindOfClass:[NSNumber class]]) {
                newVal = [NSNumber numberWithDouble:0.0];
            }
            [stack replaceObjectAtIndex:myOffset withObject:newVal];
        }
    }
    return [self popOperandOffProgramStack:stack];
}

+ (double)runProgram:(id)program {
    return [self runProgram:program usingVariableValues:nil];
}

+ (NSSet *)variablesUsedInProgram:(id)program {
    NSMutableSet *variables = [[NSMutableSet alloc] init];
    NSArray *stack;
    if ([program isKindOfClass:[NSArray class]]) stack = [program copy];
    
    for (id item in stack) {
        if ([item isKindOfClass:[NSString class]]) {
            NSString *str = item;
            if (![self isOperation:str]) {
                [variables addObject:str];
            }
        }
    }
    
    if ([variables count] < 1) variables = nil;
    return variables;
}

@end

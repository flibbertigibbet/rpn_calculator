//
//  CalculatorBrain.h
//  Calculator
//
//  Created by Kathryn Killebrew on 6/30/12.
//  Copyright (c) 2012 Kathryn Killebrew. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CalculatorBrain : NSObject

- (void)pushOperand:(double)operand;
- (double)performOperation:(NSString *)op;
- (void)clear;

@property (nonatomic, readonly) id program;

+ (NSString *)descriptionOfProgram:(id)program;
+ (double)runProgram:(id)program;

@end

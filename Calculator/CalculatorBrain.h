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
- (void)pushVariableOperand:(NSString *)var;
- (double)performOperation:(NSString *)op usingVars:(NSDictionary *)vars;
- (void)clearStack;

@property (nonatomic, readonly) id program;

+ (NSString *)descriptionOfProgram:(id)program;
+ (double)runProgram:(id)program;
+ (double)runProgram:(id)program usingVariableValues:(NSDictionary *)vars;
+ (NSSet *)variablesUsedInProgram:(id)program;
@end

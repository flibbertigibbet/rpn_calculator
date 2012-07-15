//
//  GraphViewController.m
//  Calculator
//
//  Created by Kathryn Killebrew on 7/14/12.
//  Copyright (c) 2012 Banderkat. All rights reserved.
//

#import "GraphViewController.h"
#import "CalculatorBrain.h"

@interface GraphViewController () <GraphDataSource>
@property (nonatomic) id myProgram;
@property (weak, nonatomic) IBOutlet GraphView *myGraph;
@end

@implementation GraphViewController
@synthesize myProgram = _myProgram;
@synthesize myGraph = _myGraph;

- (void) setProgram : (id) program {
    self.myProgram = program;
    NSLog(@"set my program");
}

-(id) getY: (CGFloat) x {
    NSLog(@"getting y");
    NSDictionary *myVars = [[NSDictionary alloc] initWithObjectsAndKeys:
                            [NSNumber numberWithFloat:x], @"x", nil];
    CGFloat y = [CalculatorBrain runProgram:self.myProgram usingVariableValues:myVars];
    NSLog(@"%@%g", @"y: ", y);
    return [NSNumber numberWithFloat:y];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        
    }
    return self;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

@end

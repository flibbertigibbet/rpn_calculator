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
@property (weak, nonatomic) IBOutlet GraphView *graph;
@property (nonatomic) NSUserDefaults *defaults;
@end

@implementation GraphViewController
@synthesize programDescription = _programDescription;
@synthesize defaults = _defaults;
@synthesize pinched = _pinched;
@synthesize panned = _panned;
@synthesize tapped = _tapped;
@synthesize myProgram = _myProgram;
@synthesize graph = _myGraph;

-(NSUserDefaults *) defaults {
    if (!_defaults) {
        _defaults = [NSUserDefaults standardUserDefaults];
    }
    return _defaults;
}

-(CGFloat) getScale {
    id scale = [self.defaults valueForKey:@"scale"];
    if (scale) {
        return [scale floatValue];
    } else {
        return self.view.contentScaleFactor;
    }
}

-(CGPoint) getOrigin {
    id origin_x = [self.defaults valueForKey:@"origin_x"];
    id origin_y = [self.defaults valueForKey:@"origin_y"];
    CGPoint newOrigin;
    if (origin_x && origin_y) {
        newOrigin = CGPointMake([origin_x floatValue], [origin_y floatValue]);
    }
    if (!newOrigin.x) newOrigin = self.view.center;
    return newOrigin;
}

- (void) setProgram : (id) program {
    self.myProgram = program;
    NSString *progText = [CalculatorBrain descriptionOfProgram:program];
    [self.programDescription setText:progText];
}

- (IBAction)didPinch:(UIPinchGestureRecognizer *)sender
{
    [self.defaults setObject:[NSNumber numberWithFloat:sender.scale] 
                      forKey:@"scale"];
    [self.defaults synchronize];
    [self.graph setScale:[self getScale]];
}

- (IBAction)didPan:(UIPanGestureRecognizer *)sender {
    // add current origin to offset
    CGPoint newOrigin = [sender translationInView:self.graph];
    CGPoint currentOrigin = self.getOrigin;
    newOrigin.x += currentOrigin.x;
    newOrigin.y += currentOrigin.y;
    
    [self setNewOrigin:newOrigin];
    [sender setTranslation:CGPointZero inView:self.graph];
}

- (IBAction)didTap:(UITapGestureRecognizer *)sender {
    NSLog(@"didTripleTap");
    CGPoint tapPoint = [sender locationInView:self.graph];
    NSLog(@"%@%g%@%g", @"tap x ", tapPoint.x, @" tap y ", tapPoint.y);
    
    [self setNewOrigin:[sender locationInView:self.graph]];
}

-(void) setNewOrigin:(CGPoint)newOrigin {
    [self.defaults setObject:[NSNumber numberWithFloat:newOrigin.x] 
                      forKey:@"origin_x"];
    [self.defaults setObject:[NSNumber numberWithFloat:newOrigin.y] 
                      forKey:@"origin_y"];
    [self.defaults synchronize];
    [self getOrigin];
    [self.graph setOrigin:newOrigin];
}

-(id) getY: (CGFloat) x {
    NSDictionary *myVars = [[NSDictionary alloc] initWithObjectsAndKeys:
                            [NSNumber numberWithFloat:x], @"x", nil];
    CGFloat y = [CalculatorBrain runProgram:self.myProgram 
                            usingVariableValues:myVars];
    return [NSNumber numberWithFloat:y];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)
            interfaceOrientation {
    return YES;
}

-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)   
            fromInterfaceOrientation {
    [self.graph setNeedsDisplay]; // tell graph to redraw on rotate
}

-(void)viewDidLoad {
    self.programDescription.text = [CalculatorBrain 
                                    descriptionOfProgram:self.myProgram];
}

- (void)viewDidUnload {
    [self setProgramDescription:nil];
    [self setPinched:nil];
    [self setPanned:nil];
    [self setTapped:nil];
    [super viewDidUnload];
}
@end

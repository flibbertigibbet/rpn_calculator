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
    //
    //return self.view.center;
    //TODO:
    id origin_x = [self.defaults valueForKey:@"origin_x"];
    id origin_y = [self.defaults valueForKey:@"origin_y"];
    CGPoint newOrigin;
    if (origin_x && origin_y) {
        
        NSLog(@"%@%@%@%@", @"origin x: ", origin_x, @" origin y: ", origin_y);
        
        newOrigin = CGPointMake([origin_x floatValue], [origin_y floatValue]);
    }
    if (!newOrigin.x) newOrigin = self.view.center;
    
    return newOrigin;
}

- (void) setProgram : (id) program {
    self.myProgram = program;
    NSLog(@"set my program");
    NSString *progText = [CalculatorBrain descriptionOfProgram:program];
    NSLog(@"%@%@", @"prog text is: ", progText);
    [self.programDescription setText:progText];
    //self.programDescription.text = progText;
}

- (IBAction)didPinch:(UIPinchGestureRecognizer *)sender
{
    // TODO: set graph scale to sender's scale
    
    [self.defaults setObject:[NSNumber numberWithFloat:sender.scale] forKey:@"scale"];
    [self.defaults synchronize];
    
    //[self.graph setNeedsDisplay];
    [self getScale];
    
    NSLog(@"%@%g%@%g", @"scale: ", sender.scale,
          @" velocity: ", sender.velocity);
    [self.graph setNeedsDisplay];
}

- (IBAction)didPan:(UIPanGestureRecognizer *)sender {
    CGPoint panPoint = [sender translationInView:self.graph];
    NSLog(@"%@%g%@%g", @"pan to x: ", panPoint.x, @" y: ", panPoint.y);
    
    CGPoint currentOrigin = self.getOrigin;
    
    // add current origin to offset
    
    [self.defaults setObject:[NSNumber numberWithFloat:(panPoint.x + currentOrigin.x)] forKey:@"origin_x"];
    
    [self.defaults setObject:[NSNumber numberWithFloat:(panPoint.y + currentOrigin.y)] forKey:@"origin_y"];
    
    [self.defaults synchronize];
    
    //[self.graph setNeedsDisplay];
    [self getOrigin];
    
    [sender setTranslation:CGPointZero inView:self.graph];
    [self.graph setNeedsDisplay];
    
}

- (IBAction)didTap:(UITapGestureRecognizer *)sender {
    NSLog(@"didTripleTap");
    
    
    
}

-(id) getY: (CGFloat) x {
    //NSLog(@"getting y");
    NSDictionary *myVars = [[NSDictionary alloc] initWithObjectsAndKeys:
                            [NSNumber numberWithFloat:x], @"x", nil];
    CGFloat y = [CalculatorBrain runProgram:self.myProgram usingVariableValues:myVars];
    //NSLog(@"%@%g", @"y: ", y);
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

-(void)viewDidLoad {
    self.programDescription.text = [CalculatorBrain descriptionOfProgram:self.myProgram];
}

- (void)viewDidUnload {
    [self setProgramDescription:nil];
    [self setPinched:nil];
    [self setPanned:nil];
    [self setTapped:nil];
    [super viewDidUnload];
}
@end

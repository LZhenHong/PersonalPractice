//
//  ViewController.m
//  FPSDisplay
//
//  Created by LZhenHong on 2020/9/15.
//

#import "ViewController.h"
#import "FPSLabel.h"

@interface ViewController ()
@property (nonatomic, strong) FPSLabel *fpsLabel;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.fpsLabel = [[FPSLabel alloc] init];
    self.fpsLabel.center = CGPointMake(self.view.bounds.size.width * 0.5, self.view.bounds.size.height * 0.5);
    [self.view addSubview:self.fpsLabel];
}

@end

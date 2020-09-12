//
//  ValueTestViewController.m
//  NSUndoManagerTest
//
//  Created by LZhenHong on 2020/9/12.
//

#import "ValueTestViewController.h"

@interface ValueTestViewController ()
@property (nonatomic, strong) NSUndoManager *testUndoMgr;
@property (nonatomic, assign) NSInteger value;
@property (nonatomic, assign) NSInteger currentVal;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *undoBarButtonItem;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *redoBarButtonItem;
@property (weak, nonatomic) IBOutlet UILabel *displayValueLabel;
@end

@implementation ValueTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.value = 0;
    self.currentVal = self.value;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.displayValueLabel setText:[NSString stringWithFormat:@"%zd", self.currentVal]];
    [self _updateBarItemButtonStatus];
}

- (IBAction)redoHandle:(UIBarButtonItem *)sender {
    [self.testUndoMgr redo];
    [self _updateBarItemButtonStatus];
}

- (IBAction)undoHandle:(UIBarButtonItem *)sender {
    [self.testUndoMgr undo];
    [self _updateBarItemButtonStatus];
}

- (IBAction)plusValueOneHandle {
    ++self.value;
    [self changeDisplayValue:@(self.value)];
}

- (NSUndoManager *)testUndoMgr {
    if (!_testUndoMgr) {
        _testUndoMgr = [[NSUndoManager alloc] init];
    }
    return _testUndoMgr;
}

- (void)registerTestUndoHandle:(NSInteger)value {
    [self.testUndoMgr registerUndoWithTarget:self selector:@selector(changeDisplayValue:) object:@(value)];
    
    [self _updateBarItemButtonStatus];
}

- (void)_updateBarItemButtonStatus {
    self.redoBarButtonItem.enabled = self.testUndoMgr.canRedo;
    self.undoBarButtonItem.enabled = self.testUndoMgr.canUndo;
}

- (void)changeDisplayValue:(NSNumber *)value {
    [self registerTestUndoHandle:self.currentVal];
    
    [self.displayValueLabel setText:[NSString stringWithFormat:@"%zd", value.integerValue]];
    self.currentVal = value.integerValue;
}

@end

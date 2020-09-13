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

- (void)_updateBarItemButtonStatus {
    self.redoBarButtonItem.enabled = self.testUndoMgr.canRedo;
    self.undoBarButtonItem.enabled = self.testUndoMgr.canUndo;
}

- (void)changeDisplayValue:(NSNumber *)value {
    // 这个方法默认会把 selector 加到 Undo Stack，但是如果这个时候正在 Undoing，这个方法就会把 selector 加到 Redo Stack 中
    // 有新的 selector 加到 Undo Stack 中，Redo Stack 会被清空
    // Stack 是链表结构
    [self.testUndoMgr registerUndoWithTarget:self selector:@selector(changeDisplayValue:) object:@(self.currentVal)];
//    [self testUndoManagerStackLog];
    
    [self.displayValueLabel setText:[NSString stringWithFormat:@"%zd", value.integerValue]];
    self.currentVal = value.integerValue;
    
    [self _updateBarItemButtonStatus];
}

- (void)testUndoManagerStackLog {
    if (self.testUndoMgr.isUndoing) {
        id redoStack = [self.testUndoMgr valueForKey:@"_redoStack"];
        NSLog(@"undoing redo stack: %@", [redoStack valueForKey:@"_count"]);
        id undoStack = [self.testUndoMgr valueForKey:@"_undoStack"];
        NSLog(@"undoing undo stack: %@", [undoStack valueForKey:@"_count"]);
    } else if (self.testUndoMgr.isRedoing) {
        id redoStack = [self.testUndoMgr valueForKey:@"_redoStack"];
        NSLog(@"redoing redo stack: %@", [redoStack valueForKey:@"_count"]);
        id undoStack = [self.testUndoMgr valueForKey:@"_undoStack"];
        NSLog(@"redoing undo stack: %@", [undoStack valueForKey:@"_count"]);
    } else {
        id redoStack = [self.testUndoMgr valueForKey:@"_redoStack"];
        NSLog(@"redo stack: %@", [redoStack valueForKey:@"_count"]);
        id undoStack = [self.testUndoMgr valueForKey:@"_undoStack"];
        NSLog(@"undo stack: %@", [undoStack valueForKey:@"_count"]);
    }
}

@end

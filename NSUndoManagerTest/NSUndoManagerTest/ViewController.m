//
//  ViewController.m
//  NSUndoManagerTest
//
//  Created by LZhenHong on 2020/9/11.
//

#import "ViewController.h"

@interface ViewController ()
@property (nonatomic, strong) NSMutableArray<NSString *> *datas;
@property (nonatomic, assign) NSInteger index;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *undoBarItemButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *redoBarItemButton;
@end

@implementation ViewController {
    NSUndoManager *_undoManager;
}

- (NSUndoManager *)undoManager {
    if (!_undoManager) {
        _undoManager = [[NSUndoManager alloc] init];
    }
    return _undoManager;
}

- (NSMutableArray<NSString *> *)datas {
    if (!_datas) {
        _datas = [@[@"1", @"2", @"3", @"4", @"5"] mutableCopy];
    }
    return _datas;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.index = self.datas.count;
    [self.undoBarItemButton setTitle:self.undoManager.undoMenuItemTitle];
    [self.redoBarItemButton setTitle:self.undoManager.redoMenuItemTitle];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:NSStringFromClass([ViewController class])];
    
    [self _updateBarItemButtonStatus];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self becomeFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self resignFirstResponder];
    [self.undoManager removeAllActionsWithTarget:self];
}

- (BOOL)canBecomeFirstResponder {
    return YES;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.datas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ViewController class])];
    if (!cell) {
        cell = [[UITableViewCell alloc] init];
    }
    
    NSString *data = self.datas[indexPath.row];
    [cell.textLabel setText:data];
    
    return cell;
}

- (UISwipeActionsConfiguration *)tableView:(UITableView *)tableView trailingSwipeActionsConfigurationForRowAtIndexPath:(NSIndexPath *)indexPath {
    UIContextualAction *deleteAction = [UIContextualAction contextualActionWithStyle:UIContextualActionStyleDestructive title:@"DELETE" handler:^(UIContextualAction * _Nonnull action, __kindof UIView * _Nonnull sourceView, void (^ _Nonnull completionHandler)(BOOL)) {
        NSString *data = self.datas[indexPath.row];
        [self registerUndoHandler:data];
        
        [tableView beginUpdates];
        [self.datas removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
        [tableView endUpdates];
        
        completionHandler(YES);
    }];
    return [UISwipeActionsConfiguration configurationWithActions:@[deleteAction]];
}

- (IBAction)addTableViewRow {
    ++self.index;
    [self.datas addObject:[NSString stringWithFormat:@"%zd", self.index]];
    
    [self.tableView beginUpdates];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.datas.count - 1 inSection:0];
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    [self.tableView endUpdates];
}

- (void)registerUndoHandler:(NSString *)data {
    [self.undoManager registerUndoWithTarget:self selector:@selector(recoverDataToTableView:) object:data];
    
//    [[self.undoManager prepareWithInvocationTarget:self] recoverDataToTableView:data];
    
    [self _updateBarItemButtonStatus];
}

- (void)recoverDataToTableView:(NSString *)data {
    [self.datas addObject:data];
    
    [self.tableView beginUpdates];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.datas.count - 1 inSection:0];
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    [self.tableView endUpdates];
    
}

- (IBAction)undoHandle:(UIBarButtonItem *)sender {
    [self.undoManager undo];
    [self _updateBarItemButtonStatus];
}

- (IBAction)redoHandle:(UIBarButtonItem *)sender {
    [self.undoManager redo];
    [self _updateBarItemButtonStatus];
}

- (void)_updateBarItemButtonStatus {
    self.redoBarItemButton.enabled = self.undoManager.canRedo;
    self.undoBarItemButton.enabled = self.undoManager.canUndo;
}

@end

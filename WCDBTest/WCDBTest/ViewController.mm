//
//  ViewController.mm
//  WCDBTest
//
//  Created by LZhenHong on 2020/9/17.
//

#import "ViewController.h"
#import "Message.h"

@interface ViewController ()
@property (nonatomic, strong) WCTDatabase *database;
@end

@implementation ViewController

- (WCTDatabase *)database {
    if (!_database) {
        NSString *documentPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
        NSString *path = [documentPath stringByAppendingPathComponent:@"/database/message"];
        _database = [[WCTDatabase alloc] initWithPath:path];
    }
    return _database;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (IBAction)createDatabase {
    BOOL result = [self.database createTableAndIndexesOfName:@"message" withClass:Message.class];
    NSLog(@"Create database result: %d", result);
}

- (IBAction)insertOneLineToDB {
    Message *msg = [[Message alloc] init];
    msg.localID = 1;
    msg.content = @"Hello, WCDB!";
    msg.createTime = [NSDate date];
    msg.modifiedTime = [NSDate date];
    
    BOOL result = [self.database insertObject:msg into:@"message"];
    NSLog(@"Insert one line to database result: %d", result);
}

- (IBAction)updateOneLineInDB {
    Message *newMsg = [[Message alloc] init];
    newMsg.content = @"Hello, WeChat!";
    BOOL result = [self.database updateAllRowsInTable:@"message" onProperties:Message.content withObject:newMsg];
    NSLog(@"Update one line in database result: %d", result);
}

- (IBAction)queryOneLineInDB {
    NSArray<Message *> *results = [self.database getObjectsOfClass:Message.class fromTable:@"message" where:Message.localID == 1];
    NSLog(@"Query one line in database: %@", results);
    
    WCTTable *table = [self.database getTableOfName:@"message" withClass:Message.class];
    results = [table getObjectsWhere:Message.localID == 1];
    NSLog(@"Table query one line in database: %@", results);
}

- (IBAction)deleteOneLineFromDB {
    BOOL result = [self.database deleteObjectsFromTable:@"message" where:Message.localID == 1];
    NSLog(@"Delete one line from database result: %d", result);
}

- (IBAction)testTransaction {
    Message *msg = [[Message alloc] init];
    msg.localID = 2;
    msg.content = @"Test Transaction";
    msg.createTime = [NSDate date];
    msg.modifiedTime = [NSDate date];
    __weak __typeof(self) weakSelf = self;
    BOOL commited = [self.database runTransaction:^BOOL{
        __strong __typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf.database insertObject:msg into:@"message"];
        return YES;
    }];
    NSLog(@"Run Transaction commited: %d", commited);
}

- (IBAction)testTransactionObject {
    Message *msg = [[Message alloc] init];
    msg.localID = 3;
    msg.content = @"Test Transaction Object";
    msg.createTime = [NSDate date];
    msg.modifiedTime = [NSDate date];
    
    WCTTransaction *transaction = [self.database getTransaction];
    BOOL commited = [transaction begin];
    [transaction insertObject:msg into:@"message"];
    commited = [transaction commit];
    if (!commited) {
        [transaction rollback];
        NSLog(@"Run Transaction Object error: %@", transaction.error.localizedDescription);
    }
}

- (IBAction)testWINQ {
    [self.database getObjectsOnResults:{Message.createTime.max(), Message.createTime.min()}
                             fromTable:@"messsage"
                                 where:Message.localID > 0 && Message.content.isNotNull()];
    
    [self.database getObjectsOnResults:Message.localID.distinct()
                             fromTable:@"message"
                               orderBy:Message.modifiedTime.order(WCTOrderedAscending)
                                 limit:10];
}

@end

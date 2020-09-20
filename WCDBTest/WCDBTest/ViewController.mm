//
//  ViewController.mm
//  WCDBTest
//
//  Created by LZhenHong on 2020/9/17.
//

#import "ViewController.h"
#import "Message.h"

static NSString *kMessageTable = @"message";

@interface ViewController ()
@property (nonatomic, strong) WCTDatabase *database;
@end

@implementation ViewController

- (WCTDatabase *)database {
    if (!_database) {
        NSString *documentPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
        NSString *path = [documentPath stringByAppendingPathComponent:@"/database/message"];
        _database = [[WCTDatabase alloc] initWithPath:path];
        
        // 数据库加密
//        NSData *password = [@"Password" dataUsingEncoding:NSASCIIStringEncoding];
//        [_database setCipherKey:password];
    }
    return _database;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (IBAction)createDatabase {
    BOOL result = [self.database createTableAndIndexesOfName:kMessageTable withClass:Message.class];
    NSLog(@"Create database result: %d", result);
}

- (IBAction)insertOneLineToDB {
    Message *msg = [[Message alloc] init];
    msg.localID = 1;
    msg.content = @"Hello, WCDB!";
    msg.createTime = [NSDate date];
    msg.modifiedTime = [NSDate date];
    
    BOOL result = [self.database insertObject:msg into:kMessageTable];
    NSLog(@"Insert one line to database result: %d", result);
}

- (IBAction)updateOneLineInDB {
    Message *newMsg = [[Message alloc] init];
    newMsg.content = @"Hello, WeChat!";
    BOOL result = [self.database updateAllRowsInTable:kMessageTable onProperties:Message.content withObject:newMsg];
    NSLog(@"Update one line in database result: %d", result);
}

- (IBAction)queryOneLineInDB {
    NSArray<Message *> *results = [self.database getObjectsOfClass:Message.class fromTable:kMessageTable where:Message.localID == 1];
    NSLog(@"Query one line in database: %@", results);
    
    WCTTable *table = [self.database getTableOfName:kMessageTable withClass:Message.class];
    results = [table getObjectsWhere:Message.localID == 1];
    NSLog(@"Table query one line in database: %@", results);
}

- (IBAction)deleteOneLineFromDB {
    BOOL result = [self.database deleteObjectsFromTable:kMessageTable where:Message.localID == 1];
    NSLog(@"Delete one line from database result: %d", result);
}

- (IBAction)testTransaction {
    Message *msg = [[Message alloc] init];
    msg.localID = 2;
    msg.content = @"Test Transaction";
    msg.createTime = [NSDate date];
    msg.modifiedTime = [NSDate date];
    __weak __typeof(self) weakSelf = self;
    BOOL committed = [self.database runTransaction:^BOOL{
        __strong __typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf.database insertObject:msg into:kMessageTable];
        return YES;
    }];
    NSLog(@"Run Transaction commited: %d", committed);
}

- (IBAction)testTransactionObject {
    Message *msg = [[Message alloc] init];
    msg.localID = 3;
    msg.content = @"Test Transaction Object";
    msg.createTime = [NSDate date];
    msg.modifiedTime = [NSDate date];
    
    WCTTransaction *transaction = [self.database getTransaction];
    BOOL commited = [transaction begin];
    [transaction insertObject:msg into:kMessageTable];
    commited = [transaction commit];
    if (!commited) {
        [transaction rollback];
        NSLog(@"Run Transaction Object error: %@", transaction.error.localizedDescription);
    }
}

/*
 一元操作符：+、-、! 等
 二元操作符：||、&&、+、-、*、/、|、&、<<、>>、<、<=、==、!=、>、>= 等
 范围比较：IN、BETWEEN 等
 字符串匹配：LIKE、GLOB、MATCH、REGEXP 等
 聚合函数：AVG、COUNT、MAX、MIN、SUM 等
 */
- (IBAction)testWINQ {
    /*
     SELECT MAX(createTime), MIN(createTime)
     FROM message
     WHERE localID > 0 AND content IS NOT NULL
     */
    NSArray *result1 = [self.database getOneRowOnResults:{Message.createTime.max(), Message.createTime.min()}
                                               fromTable:kMessageTable
                                                   where:Message.localID > 0 && Message.content.isNotNull()];
    NSLog(@"Result 1: %@", result1);
    
    /*
     SELECT DISTINCT localID
     FROM message
     ORDER BY modifiedTime ASC
     LIMIT 10
     */
    NSArray *result2 = [self.database getObjectsOnResults:Message.localID.distinct()
                                                fromTable:kMessageTable
                                                  orderBy:Message.modifiedTime.order(WCTOrderedAscending)
                                                    limit:10];
    NSLog(@"Result 2: %@", result2);
    
    /*
     DELETE FROM message
     WHERE localID BETWEEN 10 AND 20 OR content LIKE 'Hello%'
     */
    BOOL result3 = [self.database deleteObjectsFromTable:kMessageTable
                                                   where:Message.localID.between(10, 20) || Message.content.like(@"Hello%")];
    NSLog(@"Result 3: %d", result3);
    
    /*
     SELECT localID, content
     FROM message
     */
    NSArray *result4 = [self.database getAllObjectsOnResults:{Message.localID, Message.content}
                                                   fromTable:kMessageTable];
    NSLog(@"Result 4: %@", result4);
    
    /*
     SELECT *
     FROM message
     ORDER BY createTime ASC, localID DESC
     */
    NSArray *result5 = [self.database getObjectsOfClass:Message.class
                                              fromTable:kMessageTable
                                                orderBy:{Message.createTime.order(WCTOrderedAscending), Message.localID.order(WCTOrderedDescending)}];
    NSLog(@"Result 5: %@", result5);
    
    /*
     SELECT localID, content, createTime, modifiedTime
     FROM message
    */
    NSArray *result6 = [self.database getAllObjectsOnResults:Message.AllProperties
                                                   fromTable:kMessageTable];
    NSLog(@"Result 6: %@", result6);
    
    /*
     SELECT count(*)
     FROM message
     */
    id result7 = [self.database getOneValueOnResult:Message.AnyProperty.count() fromTable:kMessageTable];
    NSLog(@"Result 7: %@", result7);
}

- (IBAction)testMintor {
    // Error Monitor
    [WCTStatistics SetGlobalErrorReport:^(WCTError *error) {
        NSLog(@"[WCDB] error happened: %@", error);
    }];
    
    // Performance Monitor
    [WCTStatistics SetGlobalPerformanceTrace:^(WCTTag tag, NSDictionary<NSString *, NSNumber *> *sqls, NSInteger cost) {
        NSLog(@"Database with tag: %d", tag);
        NSLog(@"Run :");
        [sqls enumerateKeysAndObjectsUsingBlock:^(NSString *sqls, NSNumber *count, BOOL *) {
            NSLog(@"SQL %@ %@ times", sqls, count);
        }];
        NSLog(@"Total cost %zd nanoseconds", cost);
    }];
    
    // SQL Execution Monitor
    [WCTStatistics SetGlobalSQLTrace:^(NSString *sql) {
        NSLog(@"SQL: %@", sql);
    }];
}

// 开发者需要在数据库未损坏时，对数据库元信息定时进行备份
- (IBAction)testBackUp {
    NSData *backupPassword = [@"BackupPassword" dataUsingEncoding:NSASCIIStringEncoding];
    [self.database backupWithCipher:backupPassword];
}

// 当检测到数据库损坏，即 WCTError 的 type 为 WCTErrorTypeSQLite，code 为 11 或 26（SQLITE_CORRUPT 或 SQLITE_NOTADB）时，可以进行修复。
- (IBAction)testRecover {
    NSString *documentPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        NSString *recoverPath = [documentPath stringByAppendingPathComponent:@"/database/recover_message"];
        WCTDatabase *recoverDatabase = [[WCTDatabase alloc] initWithPath:recoverPath];
        NSData *password = [@"Password" dataUsingEncoding:NSASCIIStringEncoding];
        NSData *backupPassword = [@"BackupPassword" dataUsingEncoding:NSASCIIStringEncoding];
        int pageSize = 4096; // Default to 4096 on iOS and 1024 on macOS.
        [self.database close:^{
            NSString *path = [documentPath stringByAppendingPathComponent:@"/database/message"];
            [recoverDatabase recoverFromPath:path
                                withPageSize:pageSize
                                backupCipher:backupPassword
                              databaseCipher:password];
        }];
    });
}

- (IBAction)testAutoIncrement {
    Message *msg = [[Message alloc] init];
    msg.isAutoIncrement = YES;
    msg.localID = 5;
    msg.content = @"Test auto increment";
    msg.createTime = [NSDate date];
    msg.modifiedTime = [NSDate date];
    
    [self.database insertObject:msg into:kMessageTable];
}

@end

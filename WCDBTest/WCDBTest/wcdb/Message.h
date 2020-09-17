//
//  Message.h
//  WCDBTest
//
//  Created by LZhenHong on 2020/9/17.
//

#import <Foundation/Foundation.h>
#import <WCDB/WCDB.h>

NS_ASSUME_NONNULL_BEGIN

@interface Message : NSObject

// database property
@property (nonatomic, assign) int localID;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, strong) NSDate *createTime;
@property (nonatomic, strong) NSDate *modifiedTime;

@property (nonatomic, assign) int unused;

@end

@interface Message (WCTTableCoding) <WCTTableCoding>

// 使用 WCDB_PROPERTY 宏在头文件声明需要绑定到数据库表的字段
WCDB_PROPERTY(localID)
WCDB_PROPERTY(content)
WCDB_PROPERTY(createTime)
WCDB_PROPERTY(modifiedTime)

@end

NS_ASSUME_NONNULL_END

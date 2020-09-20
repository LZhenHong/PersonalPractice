//
//  Message.mm
//  WCDBTest
//
//  Created by LZhenHong on 2020/9/17.
//

#import "Message.h"

@implementation Message

// 使用 WCDB_IMPLEMENTATION 宏在类文件定义绑定到数据库表的类
WCDB_IMPLEMENTATION(Message)

// 使用 WCDB_SYNTHESIZE 宏在类文件定义需要绑定到数据库表的字段
WCDB_SYNTHESIZE(Message, localID)
WCDB_SYNTHESIZE_DEFAULT(Message, content, @"")
WCDB_SYNTHESIZE(Message, createTime)
WCDB_SYNTHESIZE(Message, modifiedTime)

// WCDB_PRIMARY 用于定义主键
WCDB_PRIMARY(Message, localID)

/*
 在关系数据库中，如果有上万甚至上亿条记录，在查找记录的时候，想要获得非常快的速度，就需要使用索引。
 
 索引是关系数据库中对某一列或多个列的值进行预排序的数据结构。通过使用索引，可以让数据库系统不必扫描整个表，而是直接定位到符合条件的记录，这样就大大加快了查询速度。
 
 索引的效率取决于索引列的值是否散列，即该列的值如果越互不相同，那么索引效率越高。
 
 可以对一张表创建多个索引。索引的优点是提高了查询效率，缺点是在插入、更新和删除记录时，需要同时修改索引，因此，索引越多，插入、更新和删除记录的速度就越慢。
 
 通过创建唯一索引，可以保证某一列的值具有唯一性。
 
 不管以任何方式查询表，最终都会利用主键通过聚集索引来定位到数据，聚集索引（主键）是通往真实数据所在的唯一路径。
 */
// WCDB_INDEX 用于定义索引
WCDB_INDEX(Message, "_index", createTime)

- (NSString *)description {
    return [NSString stringWithFormat:@"localID: %d, content: %@, createTime: %f, modifiedTime %f", self.localID, self.content, self.createTime.timeIntervalSince1970, self.modifiedTime.timeIntervalSince1970];
}

- (NSString *)debugDescription {
    return self.description;
}

@end

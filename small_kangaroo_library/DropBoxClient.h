#import <Foundation/Foundation.h>

@class Book;

@interface DropBoxClient : NSObject
+ (DropBoxClient *)sharedApiClient;

- (void)insert:(Book *)book;

- (void)deleteAllRecords;
@end
#import <Foundation/Foundation.h>

@class Book;

@interface DoubanClient : NSObject

- (void)retrieveBookBy:(NSString *)isbn success:(void (^)(Book *book))success failure:(void (^)(NSString *failureMessage))failure;
@end
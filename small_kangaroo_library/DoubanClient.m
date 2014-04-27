#import "DoubanClient.h"
#import "Book.h"

#define DOUBAN_ISBN_URL @"http://api.douban.com/v2/book/isbn/"

@interface DoubanClient ()

@property(nonatomic, retain) NSOperationQueue *queue;

@end

@implementation DoubanClient {

}

- (id)init {
  self = [super init];
  if (self) {
    self.queue = [[NSOperationQueue alloc] init];
  }
  return self;
}

- (void)retrieveBookBy:(NSString *)isbn success:(void (^)(Book *book))success failure:(void (^)(NSString *failureMessage))failure {
  NSURL *bookUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", DOUBAN_ISBN_URL, isbn]];
  NSLog(@"Started to get book details: %@ ", bookUrl);
  NSURLRequest *request = [NSURLRequest requestWithURL:bookUrl cachePolicy:NSURLCacheStorageNotAllowed timeoutInterval:7.0f];

  [NSURLConnection sendAsynchronousRequest:request queue:self.queue completionHandler:^(NSURLResponse *res, NSData *data, NSError *error) {
    dispatch_async(dispatch_get_main_queue(), ^{
      [self getBookDetailCallback:error withData:data isbn:isbn success:success failure:failure];
    });
  }];
}

- (void)getBookDetailCallback:(NSError *)error withData:(NSData *)data isbn:(NSString *)isbn
                      success:(void (^)(Book *book))success
                      failure:(void (^)(NSString *failureMessage))failure {
  if (data == nil || error != nil) {
    failure(@"连接网络失败了");
  } else {
    NSLog(@"Get data from douban");
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    if ([json valueForKey:@"msg"] == nil) {
      Book *book = [Book newFromJson:json andIsbn:isbn];
      success(book);
    } else {
      failure(@"没有找到这本书");
    }
  }
}
@end
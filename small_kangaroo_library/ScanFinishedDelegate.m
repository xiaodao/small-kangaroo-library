#import "ScanFinishedDelegate.h"
#import "Book.h"

#define DOUBAN_ISBN_URL @"http://api.douban.com/v2/book/isbn/"

@interface ScanFinishedDelegate ()

@property(nonatomic, retain) NSOperationQueue *queue;

@end

@implementation ScanFinishedDelegate {

}

- (id)init {
  self = [super init];
  if (self) {
    self.queue=[[NSOperationQueue alloc] init];
  }
  return self;
}

- (void)scanFinished:(NSString *)isbn {
  NSURL *bookUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", DOUBAN_ISBN_URL, isbn]];
  NSLog(@"Started to get book details: %@ ", bookUrl);

  NSURLRequest *request = [NSURLRequest requestWithURL:bookUrl cachePolicy:NSURLCacheStorageNotAllowed timeoutInterval:7.0f];

  [NSURLConnection sendAsynchronousRequest:request queue:self.queue completionHandler:^(NSURLResponse *res, NSData *data, NSError *error) {
    dispatch_async(dispatch_get_main_queue(), ^{
      [self getBookDetailCallback:error withData:data isbn:isbn];
    });
  }];
}

- (void)getBookDetailCallback:(NSError *)error withData:(NSData *)data isbn:(NSString *)isbn {
  if (data == nil || error != nil) {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"错误" message:@"连接网络失败了" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
  } else {
    NSLog(@"Get data from douban");
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    if ([json valueForKey:@"msg"] == nil) {
      NSLog(@"%@", json);
      Book *book = [Book newFromJson:json andIsbn:isbn];
      NSLog(@"%@", book);
    } else {
      NSLog(@"%@", json);
      UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"错误" message:@"没有找到这本书" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
      [alert show];
    }
  }
}
@end
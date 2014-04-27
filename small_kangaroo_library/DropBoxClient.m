#import <Dropbox/Dropbox.h>
#import "DropBoxClient.h"
#import "Book.h"

@interface DropBoxClient ()
@property(strong, nonatomic) DBDatastore *store;
@property(strong, nonatomic) DBTable *table;
@property(strong, nonatomic) DBError *error;
@end

@implementation DropBoxClient {

}

static DropBoxClient *_sharedInstance;

+ (DropBoxClient *)sharedApiClient {
  static dispatch_once_t onceToken;

  dispatch_once(&onceToken, ^{
    _sharedInstance = [[DropBoxClient alloc] init];
  });

  return _sharedInstance;
}

- (id)init {
  self = [super init];
  if (self) {
    DBAccount *account = [[DBAccountManager sharedManager] linkedAccount];
    self.store = [DBDatastore openDefaultStoreForAccount:account error:nil];
    self.table = [self.store getTable:@"books"];
  }

  return self;
}

- (void)insert:(Book *)book {
  [self.table insert:@{
          @"isbn" : book.isbn,
          @"title" : book.title,
          @"author" : book.author,
          @"authoerIntro" : book.authorIntro,
          @"publisher" : book.publisher,
          @"rating" : book.rating,
          @"summary" : book.summary,
          @"donor" : book.donor
  }];
  [self.store sync:nil];
}
@end
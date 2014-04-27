#import "BookAddViewController.h"
#import "Book.h"

@interface BookAddViewController ()
@property(strong, nonatomic) Book *book;
@end

@implementation BookAddViewController {

}
- (id)initWithBook:(Book *)book {
  self = [super init];
  if (self) {
    self.book = book;
  }
  return self;
}

@end
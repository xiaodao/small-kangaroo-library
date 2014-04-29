#import "BookAddViewController.h"
#import "Book.h"
#import "BookAddView.h"

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

- (void)loadView {
  [super loadView];
  self.view = [[BookAddView alloc]initWithBook:self.book];
}

@end
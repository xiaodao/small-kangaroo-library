#import "BookAddViewController.h"
#import "Book.h"
#import "BookAddView.h"

@interface BookAddViewController ()
@property(strong, nonatomic) Book *book;
@property(nonatomic, strong) BookAddView *bookAddView;
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
  self.bookAddView = [[BookAddView alloc]initWithBook:self.book];
  self.view = self.bookAddView;
}

- (void)viewDidAppear:(BOOL)animated {
  [self.bookAddView registerForKeyboardNotifications];
}

- (void)viewDidDisappear:(BOOL)animated {
  [[NSNotificationCenter defaultCenter] removeObserver:self.bookAddView];
}
@end
#import "BookAddViewController.h"
#import "Book.h"
#import "BookAddView.h"
#import "DropBoxClient.h"

@interface BookAddViewController ()<UIAlertViewDelegate>
@property(strong, nonatomic) Book *book;
@property(nonatomic, strong) BookAddView *bookAddView;
@end

@implementation BookAddViewController {

}
- (id)initWithBook:(Book *)book {
  self = [super init];
  if (self) {
    self.book = book;
    UIBarButtonItem *addBookButton = [[UIBarButtonItem alloc] initWithTitle:@"图书入库"
                                                               style:UIBarButtonItemStylePlain
                                                              target:self
                                                              action:@selector(addBook)];
    self.navigationItem.rightBarButtonItem = addBookButton;

    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"取消"
                                                               style:UIBarButtonItemStylePlain
                                                              target:self
                                                              action:@selector(cancel)];
    self.navigationItem.leftBarButtonItem = cancelButton;
  }
  return self;
}

- (void)cancel {
  [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)addBook {
  UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"图书入库" message:@"图书信息即将入库，你已经填写完整了么？" delegate:self cancelButtonTitle:@"否" otherButtonTitles:@"是",nil];
  [alertView setDelegate:self];
  [alertView show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
  if(buttonIndex == 1){
    [self.book setDonor:[self.bookAddView.donorField text]];
    [[DropBoxClient sharedApiClient] insert:self.book];
    [self.navigationController popToRootViewControllerAnimated:YES];
  }
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
#import "BookAddView.h"
#import "Book.h"
#import "Masonry.h"

#define VERTICAL_OFFSET 15
#define HORIZONTAL_OFFSET 20

@interface BookAddView () <UITextFieldDelegate, UIScrollViewDelegate>
@property(nonatomic, strong) Book *book;
@property(nonatomic, strong) UIScrollView *contentView;
@property(nonatomic, strong) UILabel *bookNameLabel;
@property(nonatomic, strong) UITextView *bookNameView;
@property(nonatomic, strong) UILabel *isbnLabel;
@property(nonatomic, strong) UITextView *isbnView;
@property(nonatomic, strong) UILabel *authorLabel;
@property(nonatomic, strong) UITextView *authorView;
@property(nonatomic, strong) UILabel *authorIntroLabel;
@property(nonatomic, strong) UITextView *authorIntroView;
@property(nonatomic, strong) UILabel *publisherLabel;
@property(nonatomic, strong) UITextView *publisherView;
@property(nonatomic, strong) UILabel *bookSummaryLabel;
@property(nonatomic, strong) UITextView *bookSummaryView;
@property(nonatomic, strong) UILabel *donorLabel;
@property(nonatomic, strong) UITextField *activeField;
@property(nonatomic) CGFloat scrollBufferTop;
@property(nonatomic) CGSize kbSize;
@property(nonatomic) BOOL alreadyUsedChinese;
@end

@implementation BookAddView {

}

- (id)initWithBook:(Book *)book {
  self = [super init];
  if (!self) return nil;
  self.book = book;
  self.backgroundColor = [UIColor whiteColor];
  self.scrollBufferTop = 30;
  [self createElements];
  [self setupConstraints];
  [self layoutSubviews];
  return self;
}

- (void)setupConstraints {
  [self.contentView mas_makeConstraints:^(MASConstraintMaker *maker) {
    maker.edges.equalTo(self);
  }];

  [self.bookNameLabel mas_makeConstraints:^(MASConstraintMaker *maker) {
    maker.top.equalTo(self.contentView).with.offset(20);
    maker.left.equalTo(self).with.offset(HORIZONTAL_OFFSET);
  }];

  [self.bookNameView mas_makeConstraints:^(MASConstraintMaker *maker) {
    maker.top.equalTo(self.bookNameLabel.mas_bottom).with.offset(VERTICAL_OFFSET);
    maker.left.equalTo(self).with.offset(HORIZONTAL_OFFSET);
    maker.right.equalTo(self.mas_right).with.offset(-HORIZONTAL_OFFSET);
  }];

  [self.isbnLabel mas_makeConstraints:^(MASConstraintMaker *maker) {
    maker.top.equalTo(self.bookNameView.mas_bottom).with.offset(VERTICAL_OFFSET);
    maker.left.equalTo(self).with.offset(HORIZONTAL_OFFSET);
  }];

  [self.isbnView mas_makeConstraints:^(MASConstraintMaker *maker) {
    maker.top.equalTo(self.isbnLabel.mas_bottom).with.offset(VERTICAL_OFFSET);
    maker.left.equalTo(self).with.offset(HORIZONTAL_OFFSET);
    maker.right.equalTo(self.mas_right).with.offset(-HORIZONTAL_OFFSET);
  }];

  [self.authorLabel mas_makeConstraints:^(MASConstraintMaker *maker) {
    maker.top.equalTo(self.isbnView.mas_bottom).with.offset(VERTICAL_OFFSET);
    maker.left.equalTo(self).with.offset(HORIZONTAL_OFFSET);
  }];

  [self.authorView mas_makeConstraints:^(MASConstraintMaker *maker) {
    maker.top.equalTo(self.authorLabel.mas_bottom).with.offset(VERTICAL_OFFSET);
    maker.left.equalTo(self).with.offset(HORIZONTAL_OFFSET);
    maker.right.equalTo(self.mas_right).with.offset(-HORIZONTAL_OFFSET);
  }];

  [self.authorIntroLabel mas_makeConstraints:^(MASConstraintMaker *maker) {
    maker.top.equalTo(self.authorView.mas_bottom).with.offset(VERTICAL_OFFSET);
    maker.left.equalTo(self).with.offset(HORIZONTAL_OFFSET);
  }];

  [self.authorIntroView mas_makeConstraints:^(MASConstraintMaker *maker) {
    maker.top.equalTo(self.authorIntroLabel.mas_bottom).with.offset(VERTICAL_OFFSET);
    maker.left.equalTo(self).with.offset(HORIZONTAL_OFFSET);
    maker.right.equalTo(self.mas_right).with.offset(-HORIZONTAL_OFFSET);
  }];

  [self.publisherLabel mas_makeConstraints:^(MASConstraintMaker *maker) {
    maker.top.equalTo(self.authorIntroView.mas_bottom).with.offset(VERTICAL_OFFSET);
    maker.left.equalTo(self).with.offset(HORIZONTAL_OFFSET);
  }];

  [self.publisherView mas_makeConstraints:^(MASConstraintMaker *maker) {
    maker.top.equalTo(self.publisherLabel.mas_bottom).with.offset(VERTICAL_OFFSET);
    maker.left.equalTo(self).with.offset(HORIZONTAL_OFFSET);
    maker.right.equalTo(self.mas_right).with.offset(-HORIZONTAL_OFFSET);
  }];

  [self.bookSummaryLabel mas_makeConstraints:^(MASConstraintMaker *maker) {
    maker.top.equalTo(self.publisherView.mas_bottom).with.offset(VERTICAL_OFFSET);
    maker.left.equalTo(self).with.offset(HORIZONTAL_OFFSET);
  }];

  [self.bookSummaryView mas_makeConstraints:^(MASConstraintMaker *maker) {
    maker.top.equalTo(self.bookSummaryLabel.mas_bottom).with.offset(VERTICAL_OFFSET);
    maker.left.equalTo(self).with.offset(HORIZONTAL_OFFSET);
    maker.right.equalTo(self.mas_right).with.offset(-HORIZONTAL_OFFSET);
    maker.height.equalTo(@150);
  }];

  [self.donorLabel mas_makeConstraints:^(MASConstraintMaker *maker) {
    maker.top.equalTo(self.bookSummaryView.mas_bottom).with.offset(VERTICAL_OFFSET);
    maker.left.equalTo(self).with.offset(HORIZONTAL_OFFSET);
  }];

  [self.donorField mas_makeConstraints:^(MASConstraintMaker *maker) {
    maker.top.equalTo(self.donorLabel.mas_bottom).with.offset(VERTICAL_OFFSET);
    maker.left.equalTo(self).with.offset(HORIZONTAL_OFFSET);
    maker.right.equalTo(self.mas_right).with.offset(-HORIZONTAL_OFFSET);
    maker.height.equalTo(@40);
  }];
}

- (void)updateConstraints {
  [super updateConstraints];

  [self.bookNameView mas_updateConstraints:^(MASConstraintMaker *maker) {
    maker.height.equalTo(@([self intrinsicContentSize:self.bookNameView].height));
  }];

  [self.isbnView mas_updateConstraints:^(MASConstraintMaker *maker) {
    maker.height.equalTo(@([self intrinsicContentSize:self.isbnView].height));
  }];

  [self.authorView mas_updateConstraints:^(MASConstraintMaker *maker) {
    maker.height.equalTo(@([self intrinsicContentSize:self.authorView].height));
  }];

  [self.authorIntroView mas_updateConstraints:^(MASConstraintMaker *maker) {
    maker.height.equalTo(@([self intrinsicContentSize:self.authorIntroView].height));
  }];

  [self.publisherView mas_updateConstraints:^(MASConstraintMaker *maker) {
    maker.height.equalTo(@([self intrinsicContentSize:self.publisherView].height));
  }];

  [self.donorField mas_updateConstraints:^(MASConstraintMaker *maker) {
    maker.bottom.equalTo(self.contentView.mas_bottom).with.offset(-VERTICAL_OFFSET);
  }];

}

- (CGSize)intrinsicContentSize:(UITextView *)textView {
  CGSize intrinsicContentSize = textView.contentSize;

  intrinsicContentSize.width += (textView.textContainerInset.left + textView.textContainerInset.right) / 2.0f;
  intrinsicContentSize.height += (textView.textContainerInset.top + textView.textContainerInset.bottom) / 2.0f;

  return intrinsicContentSize;
}

- (void)createElements {
  self.contentView = [[UIScrollView alloc] init];
  [self.contentView setDelegate:self];
  [self addSubview:self.contentView];

  self.bookNameLabel = [self labelWithTitle:@"书名"];
  [self.contentView addSubview:self.bookNameLabel];

  self.bookNameView = [self textViewWithText:[self.book title]];
  [self.contentView addSubview:self.bookNameView];

  self.isbnLabel = [self labelWithTitle:@"ISBN"];
  [self.contentView addSubview:self.isbnLabel];

  self.isbnView = [self textViewWithText:[self.book isbn]];
  [self.contentView addSubview:self.isbnView];

  self.authorLabel = [self labelWithTitle:@"作者"];
  [self.contentView addSubview:self.authorLabel];

  self.authorView = [self textViewWithText:[self.book author]];
  [self.contentView addSubview:self.authorView];

  self.authorIntroLabel = [self labelWithTitle:@"作者简介"];
  [self.contentView addSubview:self.authorIntroLabel];

  self.authorIntroView = [self textViewWithText:[self.book authorIntro]];
  [self.contentView addSubview:self.authorIntroView];

  self.publisherLabel = [self labelWithTitle:@"出版社"];
  [self.contentView addSubview:self.publisherLabel];

  self.publisherView = [self textViewWithText:[self.book publisher]];
  [self.contentView addSubview:self.publisherView];

  self.bookSummaryLabel = [self labelWithTitle:@"摘要"];
  [self.contentView addSubview:self.bookSummaryLabel];

  self.bookSummaryView = [self textViewWithText:[self.book summary]];
  [self.contentView addSubview:self.bookSummaryView];

  self.donorLabel = [self labelWithTitle:@"捐赠者"];
  [self.contentView addSubview:self.donorLabel];

  self.donorField = [self textFieldWithText:[[NSUserDefaults standardUserDefaults] objectForKey:@"donorName"]];
  [self.contentView addSubview:self.donorField];
}

- (void)registerForKeyboardNotifications {
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(keyboardWasShown:)
                                               name:UIKeyboardDidShowNotification object:nil];

  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(keyboardWillBeHidden:)
                                               name:UIKeyboardWillHideNotification object:nil];

  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(inputMethodChanged) name:UITextInputCurrentInputModeDidChangeNotification object:nil];
}

- (void)inputMethodChanged {
  self.alreadyUsedChinese = [[self.activeField textInputMode].primaryLanguage isEqualToString:@"zhHans"];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
  self.activeField = textField;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
  [textField resignFirstResponder];
  self.activeField = nil;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
  [textField resignFirstResponder];
  return NO;
}

- (void) scrollViewWillBeginDragging: (UIScrollView *)scrollView{
  [self.activeField resignFirstResponder];
}

- (void)keyboardWasShown:(NSNotification *)aNotification {
  NSDictionary *info = [aNotification userInfo];
  self.kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
  if ([[self.activeField textInputMode].primaryLanguage isEqualToString:@"zh-Hans"] && !self.alreadyUsedChinese) {
    self.alreadyUsedChinese = YES;
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, self.kbSize.height + 36, 0.0);
    self.contentView.contentInset = contentInsets;
    self.contentView.scrollIndicatorInsets = contentInsets;
  } else {
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, self.kbSize.height, 0.0);
    self.contentView.contentInset = contentInsets;
    self.contentView.scrollIndicatorInsets = contentInsets;
  }
  [self scrollToVisible:self.activeField];
}

- (void)scrollToVisible:(UITextField *)editingField {
  CGFloat topOfField = editingField.frame.origin.y - self.contentView.contentOffset.y;
  CGFloat __block distanceToScroll = -1;
  if (topOfField < self.scrollBufferTop) {
    distanceToScroll = topOfField - self.scrollBufferTop;
  }
  else {
    // check if it's off the bottom
    CGFloat bottomOfField = editingField.frame.origin.y + editingField.frame.size.height - self.contentView.contentOffset.y;
    CGFloat bottomOfView = self.contentView.frame.size.height - self.contentView.contentInset.bottom - 5;
    if (bottomOfField > bottomOfView) {
      // if it's too big for the screen, align to top
      CGFloat fieldHeight = editingField.frame.size.height + 30 + 5;
      CGFloat viewableArea = self.contentView.frame.size.height - self.contentView.contentInset.bottom;
      if (fieldHeight > viewableArea) {
        distanceToScroll = topOfField - self.scrollBufferTop;
      }
      else {
        // otherwise just scroll until bottom is visible
        distanceToScroll = bottomOfField - bottomOfView;
      }
    }
  }
  if (distanceToScroll != -1) {
    [UIView animateWithDuration:0.4 animations:^{
      self.contentView.contentOffset = CGPointMake(0, self.contentView.contentOffset.y + distanceToScroll);
    }];
  }
}

- (void)keyboardWillBeHidden:(NSNotification *)aNotification {
  UIEdgeInsets contentInsets = UIEdgeInsetsZero;
  self.contentView.contentInset = contentInsets;
  self.contentView.scrollIndicatorInsets = contentInsets;
}

- (UILabel *)labelWithTitle:(NSString *)title {
  UILabel *label = [[UILabel alloc] init];
  [label setText:title];
  [label setFont:[UIFont fontWithName:@"HelveticaNeue" size:18]];
  [label setTextColor:[UIColor blackColor]];
  return label;
}

- (UITextView *)textViewWithText:(NSString *)text {
  UITextView *view = [[UITextView alloc] init];
  [[view layer] setBorderColor:[UIColor blackColor].CGColor];
  [[view layer] setBorderWidth:0.6f];
  [view setTextColor:[UIColor blackColor]];
  [view setFont:[UIFont fontWithName:@"HelveticaNeue" size:16]];
  [view setBackgroundColor:[UIColor grayColor]];
  [view setText:text];
  [view setEditable:NO];
  return view;
}

- (UITextField *)textFieldWithText:(NSString *)text {
  UITextField *textField = [[UITextField alloc] init];
  [[textField layer] setBorderColor:[UIColor blackColor].CGColor];
  [[textField layer] setBorderWidth:0.6f];
  [textField setTextColor:[UIColor blackColor]];
  [textField setFont:[UIFont fontWithName:@"HelveticaNeue" size:16]];
  [textField setText:text];
  [textField setDelegate:self];
  UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 20)];
  paddingView.userInteractionEnabled = NO;
  textField.leftView = paddingView;
  textField.leftViewMode = UITextFieldViewModeAlways;
  return textField;
}

@end
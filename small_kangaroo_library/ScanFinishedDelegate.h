#import <Foundation/Foundation.h>

@interface ScanFinishedDelegate : NSObject

- (void)scanFinished: (NSString *)isbn;
@end
//
//  NSString+SBValidation.h
//  Spikeball
//
//  Created by Sam Goldstein on 7/8/14.
//

#import <Foundation/Foundation.h>

@interface NSString (SBValidation)

- (BOOL)isValidPassword;
- (BOOL)isValidEmailAddress;
- (BOOL)isValidPhoneNumber;

@end

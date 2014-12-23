//
//  NSString+SBValidation.m
//  Spikeball
//
//  Created by Sam Goldstein on 7/8/14.
//

#import "NSString+SBValidation.h"

@implementation NSString (SBalidation)

- (BOOL)isValidEmailAddress {
    if ([self length] < 6) { //minimum is a@b.c
        return NO;
    }
    
    if ([self rangeOfString:@" "].location != NSNotFound) { // no spaces
        return NO;
    }
    
    if ([self rangeOfString:@"."].location == NSNotFound) { // must be 1 "."
        return NO;
    }
    
    if ([self rangeOfString:@"@"].location == NSNotFound) { // must be 1 "@"
        return NO;
    }
    
    BOOL valid = [[self componentsSeparatedByString:@"@"] count] == 2 && [[self componentsSeparatedByString:@"."] count] >= 2 && [[[self componentsSeparatedByString:@"."] lastObject] length] > 1;
    
    return valid;
}

- (BOOL)isValidPassword {
    BOOL valid = self.length > 4;
    return valid;
}

- (BOOL)isValidPhoneNumber {
    //TODO: international numbers, etc
    NSString *phoneRegex = @"^\[0-9]{3}\[0-9]{3}[0-9]{4}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneRegex];
    
    return [phoneTest evaluateWithObject:self];
}

@end
//
//  MMGravatarHelper.m
//


#import "MMGravatarHelper.h"
#import <CommonCrypto/CommonDigest.h>

@implementation MMGravatarHelper

+ (NSURL*)URLForGravatarWithEmail:(NSString*)email imageSize:(NSString*)imageSize defaultImage:(NSString*)defaultImage
{
  if (email)
  {
    if(!imageSize) {
      imageSize = @"80";
    }

    if(!defaultImage) {
      defaultImage = @"mm";
    }

    NSString *cleanEmail = [[email stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] lowercaseString];
    NSString *emailDiggest = [MMGravatarHelper md5HexDigest:cleanEmail];
    NSString *gravatarURL = [NSString stringWithFormat:@"http://www.gravatar.com/avatar/%@?s=%@&d=%@", emailDiggest, imageSize, defaultImage];
    return [NSURL URLWithString:gravatarURL];
  }

  return nil;
}

+ (NSString*)md5HexDigest:(NSString*)string
{
  const char *original_str = [string UTF8String];
  unsigned char result[CC_MD5_DIGEST_LENGTH];
  CC_MD5(original_str, (unsigned)strlen(original_str), result);
  NSMutableString *hash = [NSMutableString string];
  for (int i = 0; i < 16; i++)
    [hash appendFormat:@"%02X", result[i]];
  return [hash lowercaseString];
}

@end

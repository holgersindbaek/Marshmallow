//
//  MMGravatarHelper.h
//



@interface MMGravatarHelper : NSObject

+ (NSURL*)URLForGravatarWithEmail:(NSString*)aEmail imageSize:(NSString*)imageSize defaultImage:(NSString*)defaultImage;

@end


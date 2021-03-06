// Copyright (c) 2014-present, Facebook, Inc. All rights reserved.
//
// You are hereby granted a non-exclusive, worldwide, royalty-free license to use,
// copy, modify, and distribute this software in source code or binary form for use
// in connection with the web services and APIs provided by Facebook.
//
// As with any software that integrates with the Facebook platform, your use of
// this software is subject to the Facebook Developer Principles and Policies
// [http://developers.facebook.com/policy/]. This copyright notice shall be
// included in all copies or substantial portions of the software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
// FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
// COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
// IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
// CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

#import "FBSDKShareVideoContent.h"

#import "FBSDKCoreKit+Internal.h"
#import "FBSDKShareUtility.h"

#define FBSDK_SHARE_VIDEO_CONTENT_CONTENT_URL_KEY @"contentURL"
#define FBSDK_SHARE_VIDEO_CONTENT_PEOPLE_IDS_KEY @"peopleIDs"
#define FBSDK_SHARE_VIDEO_CONTENT_PLACE_ID_KEY @"placeID"
#define FBSDK_SHARE_VIDEO_CONTENT_PREVIEW_PHOTO_KEY @"previewPhoto"
#define FBSDK_SHARE_VIDEO_CONTENT_REF_KEY @"ref"
#define FBSDK_SHARE_VIDEO_CONTENT_VIDEO_KEY @"video"

@implementation FBSDKShareVideoContent

#pragma mark - Properties

@synthesize contentURL = _contentURL;
@synthesize peopleIDs = _peopleIDs;
@synthesize placeID = _placeID;
@synthesize ref = _ref;

- (void)setPeopleIDs:(NSArray *)peopleIDs
{
  [FBSDKShareUtility assertCollection:peopleIDs ofClass:[NSString class] name:@"peopleIDs"];
  if (![FBSDKInternalUtility object:_peopleIDs isEqualToObject:peopleIDs]) {
    _peopleIDs = [peopleIDs copy];
  }
}

#pragma mark - Equality

- (NSUInteger)hash
{
  NSUInteger subhashes[] = {
    [_contentURL hash],
    [_peopleIDs hash],
    [_placeID hash],
    [_previewPhoto hash],
    [_ref hash],
    [_video hash],
  };
  return [FBSDKMath hashWithIntegerArray:subhashes count:sizeof(subhashes) / sizeof(subhashes[0])];
}

- (BOOL)isEqual:(id)object
{
  if (self == object) {
    return YES;
  }
  if (![object isKindOfClass:[FBSDKShareVideoContent class]]) {
    return NO;
  }
  return [self isEqualToShareVideoContent:(FBSDKShareVideoContent *)object];
}

- (BOOL)isEqualToShareVideoContent:(FBSDKShareVideoContent *)content
{
  return (content &&
          [FBSDKInternalUtility object:_contentURL isEqualToObject:content.contentURL] &&
          [FBSDKInternalUtility object:_peopleIDs isEqualToObject:content.peopleIDs] &&
          [FBSDKInternalUtility object:_placeID isEqualToObject:content.placeID] &&
          [FBSDKInternalUtility object:_previewPhoto isEqualToObject:content.previewPhoto] &&
          [FBSDKInternalUtility object:_ref isEqualToObject:content.ref] &&
          [FBSDKInternalUtility object:_video isEqualToObject:content.video]);
}

#pragma mark - NSCoding

+ (BOOL)supportsSecureCoding
{
  return YES;
}

- (id)initWithCoder:(NSCoder *)decoder
{
  if ((self = [self init])) {
    _contentURL = [decoder decodeObjectOfClass:[NSURL class] forKey:FBSDK_SHARE_VIDEO_CONTENT_CONTENT_URL_KEY];
    _peopleIDs = [decoder decodeObjectOfClass:[NSArray class] forKey:FBSDK_SHARE_VIDEO_CONTENT_PEOPLE_IDS_KEY];
    _placeID = [decoder decodeObjectOfClass:[NSString class] forKey:FBSDK_SHARE_VIDEO_CONTENT_PLACE_ID_KEY];
    _previewPhoto = [decoder decodeObjectOfClass:[FBSDKSharePhoto class]
                                          forKey:FBSDK_SHARE_VIDEO_CONTENT_PREVIEW_PHOTO_KEY];
    _ref = [decoder decodeObjectOfClass:[NSString class] forKey:FBSDK_SHARE_VIDEO_CONTENT_REF_KEY];
    _video = [decoder decodeObjectOfClass:[FBSDKShareVideo class] forKey:FBSDK_SHARE_VIDEO_CONTENT_VIDEO_KEY];
  }
  return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
  [encoder encodeObject:_contentURL forKey:FBSDK_SHARE_VIDEO_CONTENT_CONTENT_URL_KEY];
  [encoder encodeObject:_peopleIDs forKey:FBSDK_SHARE_VIDEO_CONTENT_PEOPLE_IDS_KEY];
  [encoder encodeObject:_placeID forKey:FBSDK_SHARE_VIDEO_CONTENT_PLACE_ID_KEY];
  [encoder encodeObject:_previewPhoto forKey:FBSDK_SHARE_VIDEO_CONTENT_PREVIEW_PHOTO_KEY];
  [encoder encodeObject:_ref forKey:FBSDK_SHARE_VIDEO_CONTENT_REF_KEY];
  [encoder encodeObject:_video forKey:FBSDK_SHARE_VIDEO_CONTENT_VIDEO_KEY];
}

#pragma mark - NSCopying

- (id)copyWithZone:(NSZone *)zone
{
  FBSDKShareVideoContent *copy = [[FBSDKShareVideoContent alloc] init];
  copy->_contentURL = [_contentURL copy];
  copy->_peopleIDs = [_peopleIDs copy];
  copy->_placeID = [_placeID copy];
  copy->_previewPhoto = [_previewPhoto copy];
  copy->_ref = [_ref copy];
  copy->_video = [_video copy];
  return copy;
}

@end

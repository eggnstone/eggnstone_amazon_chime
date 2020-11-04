//
//  VideoClientSDK.h
//  AmazonChimeSDKMedia
//
//  Copyright 2020 Amazon.com, Inc. or its affiliates. All Rights Reserved.
//

#ifndef VideoClient_sdk_h
#define VideoClient_sdk_h

#import <Foundation/Foundation.h>
#import <CoreGraphics/CGImage.h>

#import "VideoRendererDelegate.h"
#import "VideoClientMetric.h"

#import "video_client_enum.h"

@protocol VideoClientDelegate;
@protocol VideoClientObserverAdapterDelegate;

@interface VideoDevice : NSObject
@property (atomic, strong, readonly) NSString* identifier;
@property (atomic, strong, readonly) NSString* name;
@property (atomic, assign, readonly) BOOL isDefault;
@property (atomic, assign, readonly) BOOL isBuiltIn;
@end

// Note: If adding to this, make sure to add correspondingly to VideoClient.m
@interface VideoConfiguration : NSObject
// Feature flags
@property (nonatomic, assign) BOOL isUsing16by9AspectRatio;
@property (nonatomic, assign) BOOL isUsingUnifiedPlan;
@property (nonatomic, assign) BOOL isUsingProbingAdaptiveSubscribe;
@property (nonatomic, assign) BOOL isUsingSendSideBwe;
@property (nonatomic, assign) BOOL isUsingPixelBufferRenderer;
@property (nonatomic, assign) BOOL isUsingOptimizedTwoSimulcastStreamTable;
@end

@interface DataMessageInternal : NSObject
@property (nonatomic, assign) long timestampMs;
@property (atomic, strong, readonly) NSString* topic;
@property (atomic, strong, readonly) NSData* data;
@property (atomic, strong, readonly) NSString* senderAttendeeId;
@property (atomic, strong, readonly) NSString* senderExternalUserId;
@property (nonatomic, assign) bool throttled;
@end

#define kMaximumSupportedVideoTiles 16

#pragma clang diagnostic push
// To get rid of 'No protocol definition found' warnings for adapter delegate
// who's header we cannot include because it contains C++ and this header
// is sometimes transitively included from Obj-C (i.e. not Obj-C++ files)
#pragma clang diagnostic ignored "-Weverything"

@interface VideoClient : NSObject<VideoClientObserverAdapterDelegate, VideoRendererDelegate>

#pragma clang diagnostic pop

@property (nonatomic, retain) NSObject<VideoClientDelegate>* delegate;

+ (void)globalInitialize;

// Set the dynamic media client config whenever it is passed down from application
+ (void)setMediaClientConfig:(NSString*)configStr;

- (void)start:(NSString*)callId
            token:(NSString*)token
          sending:(BOOL)sending
           config:(VideoConfiguration*)config
          appInfo:(app_detailed_info_t)appInfo;

- (void)stop;

- (void)updateTurnCreds:(turn_session_response_t)turnResponse
             turnStatus:(video_client_turn_status_t)turnStatus;

- (NSString*)stateString;

- (void)setSending:(BOOL)sending;

- (void)setReceiving:(BOOL)receiving;

- (video_client_service_type_t)getServiceType;

- (void)setRemotePause:(uint32_t)video_id
                 pause:(BOOL)pause;

- (NSArray*)activeTracks;

+ (NSArray*)devices;

- (void)setCurrentDevice:(VideoDevice*)captureDevice;

// Log callback
- (void)videoLogCallBack:(video_client_loglevel_t)logLevel
                     msg:(NSString*)msg;

// currently selected device
+ (VideoDevice*)currentDevice;

// send data message
- (void)sendDataMessage:(NSString*)topic
                   data:(const char*)data
             lifetimeMs:(int)lifetimeMs;
@end

// All of these callbacks occur on the main thread
@protocol VideoClientDelegate <NSObject>

@optional

- (void)videoClient:(VideoClient*)client
    didReceiveFrame:(CGImageRef)image
          displayId:(int)displayId
          profileId:(NSString*)profileId
          pauseType:(video_client_pause_type_t)pauseType
            videoId:(uint32_t)videoId;

- (void)didReceiveBuffer:(CVPixelBufferRef)buffer
               profileId:(NSString*)profileId
              pauseState:(PauseState)pauseState
                 videoId:(uint32_t)videoId;

- (void)videoClient:(VideoClient*)client didUpdateNumberOfTracks:(NSArray*)tracks;

- (void)videoClientIsConnecting:(VideoClient*)client;

- (void)videoClientDidConnect:(VideoClient*)client
                controlStatus:(int)controlStatus;

- (void)videoClientDidFail:(VideoClient*)client
                    status:(video_client_status_t)status
             controlStatus:(int)controlStatus;

- (void)videoClientDidStop:(VideoClient*)client;

- (void)videoClient:(VideoClient*)client cameraSendIsAvailable:(BOOL)available;

- (void)videoClientRequestTurnCreds:(VideoClient*)client;

- (void)videoClientMetricsReceived:(NSDictionary*)metrics;

- (void)videoClientDataMessageReceived:(NSArray<DataMessageInternal*>*)message;
@end

#endif /* VideoClient_sdk_h */

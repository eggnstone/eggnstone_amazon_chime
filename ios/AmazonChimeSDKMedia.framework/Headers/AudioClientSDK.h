//
//  AudioClientSDK.h
//  AmazonChimeSDKMedia
//
//  Copyright 2020 Amazon.com, Inc. or its affiliates. All Rights Reserved.
//

#import <Foundation/Foundation.h>
#import "audio_client_enum.h"

typedef enum
{
    LOGGER_TRACE = 1,
    LOGGER_DEBUG = 2,
    LOGGER_INFO = 3,
    LOGGER_WARNING = 4,
    LOGGER_ERROR = 5,
    LOGGER_FATAL = 6,
    LOGGER_NOTIFY = 7,
} loglevel_t;

typedef NS_ENUM(NSUInteger, AudioClientMetric) {
    clientMicDeviceFramesLostPercent,
    serverPreJbMicPacketsLostPercent,
    serverMicMaxJitterMs,
    serverPostJbMic1sPacketsLostPercent,
    serverPostJbMic5sPacketsLostPercent,
    clientPreJbSpkPacketsLostPercent,
    clientSpkMaxJitterMs,
    clientPostJbSpk1sPacketsLostPercent,
    clientPostJbSpk5sPacketsLostPercent,
};

@protocol AudioClientDelegate <NSObject>

@optional

- (void)signalStrengthChanged:(NSArray*)signalStrengths;

- (void)audioClientStateChanged:(audio_client_state_t)audio_client_state
                         status:(audio_client_status_t)status;

- (void)volumeStateChanged:(NSArray*)volumes;

- (void)audioMetricsChanged:(NSDictionary*)metrics;

- (void)attendeesPresenceChanged:(NSArray*)attendees;

@end

@interface AudioClient : NSObject
{
@private audio_client_t *_client;
}

@property (nonatomic, retain) NSObject <AudioClientDelegate> *delegate;

- (audio_client_status_t)startSession:(NSString *)host
                             basePort:(NSInteger)port
                               callId:(NSString*)callId
                            profileId:(NSString*)profileId
                       microphoneMute:(BOOL)mic_mute
                          speakerMute:(BOOL)spk_mute
                          isPresenter:(BOOL)presenter
                         sessionToken:(NSString *)tokenString
                           audioWsUrl:(NSString *)audioWsUrl
                       callKitEnabled:(BOOL)callKitEnabled
;

- (NSInteger)stopSession;

- (BOOL)isSpeakerOn;

- (BOOL)setSpeakerOn:(BOOL)value;

- (NSInteger) stopAudioRecord;

- (BOOL)isMicrophoneMuted;

- (NSInteger)setMicrophoneMuted:(BOOL)mute;

- (void)setPresenter:(BOOL)presenter;

- (void)remoteMute;

- (void) audioLogCallBack:(loglevel_t)logLevel
                      msg:(NSString*)msg;

+ (AudioClient *)sharedInstance;

@end

@interface AttendeeUpdate: NSObject

@property NSString *profileId;
@property NSString *externalUserId;
@property NSNumber *data;

- (id) initWithProfileId:(NSString *)profile_id
          externalUserId:(NSString *)external_user_id
                    data:(NSNumber *)data;

@end

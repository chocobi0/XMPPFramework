//
//  XMPPTransportProtocol.h
//  iPhoneXMPP
//
//  Created by Chaitanya Gupta on 16/03/11.
//  Copyright 2011 Directi. All rights reserved.
//

#import <Foundation/Foundation.h>
#if TARGET_OS_IPHONE
    #import "DDXML.h"
#endif

@class XMPPJID;

@protocol XMPPTransportProtocol

- (void)addDelegate:(id)delegate withDelegateQueue:(dispatch_queue_t)aQueue;
- (void)removeDelegate:(id)delegate withDelegateQueue:(dispatch_queue_t)aQueue;
- (void)removeDelegate:(id)delegate;
- (BOOL)connect:(NSError **)errPtr;
- (void)disconnect;
- (void)sendData:(id)aData withTimeout:(NSTimeInterval)timeout tag:(long)tag;
@optional

- (void)secure;
- (BOOL)isSecure;

// P2P
- (XMPPJID *)remoteJID;
- (void)setRemoteJID:(XMPPJID *)jid;
- (BOOL)isP2PRecipient;

@end


@protocol XMPPTransportDelegate

@optional
- (void)transportWillConnect:(id <XMPPTransportProtocol>)transport;
- (void)transportDidStartNegotiation:(id <XMPPTransportProtocol>)transport;
- (void)transportDidConnect:(id <XMPPTransportProtocol>)transport;
- (void)transportWillDisconnect:(id <XMPPTransportProtocol>)transport;
- (void)transportWillDisconnect:(id<XMPPTransportProtocol>)transport withError:(NSError *)err;
- (void)transportDidDisconnect:(id <XMPPTransportProtocol>)transport;
- (void)transport:(id <XMPPTransportProtocol>)transport willSecureWithSettings:(NSDictionary *)settings;
- (void)transport:(id <XMPPTransportProtocol>)transport didReceiveData:(NSData*)aData;
- (void)transport:(id <XMPPTransportProtocol>)transport didReceiveError:(id)error;
- (void)transportDidSecure:(id <XMPPTransportProtocol>)transport;

@end

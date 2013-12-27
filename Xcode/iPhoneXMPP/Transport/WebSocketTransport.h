//
//  WebSocketTransport.h
//  iPhoneXMPP
//
//  Created by Yeonho Choi on 2013. 12. 26..
//
//


#import "XMPPTransportProtocol.h"
#import "GCDMulticastDelegate.h"
@interface WebSocketTransport : NSObject<XMPPTransportProtocol>
@property GCDMulticastDelegate<XMPPTransportDelegate>* multicastDelegate;
- (id)initWithURL:(NSURL *)url;
- (id)initWithURL:(NSURL *)url withDelegate:(id<XMPPTransportDelegate>)aDelegate;
- (id)initWithURL:(NSURL *)url withDelegate:(id<XMPPTransportDelegate>)aDelegate withDelegateQueue:(dispatch_queue_t)aDispatchQueue;
/* Protocol Methods */

@end

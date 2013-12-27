//
//  WebSocketTransport.m
//  iPhoneXMPP
//
//  Created by Yeonho Choi on 2013. 12. 26..
//
//

#import "WebSocketTransport.h"
#import "SRWebSocket.h"
@interface WebSocketTransport()<SRWebSocketDelegate>
@property (strong, nonatomic) SRWebSocket* webSocket;
@end

@implementation WebSocketTransport
@synthesize webSocket = _webSocket;
@synthesize multicastDelegate = _multicastDelegate;
- (id)initWithURL:(NSURL *)url
{
    self = [self initWithURL:url withDelegate:nil withDelegateQueue:NULL];
    if (self) {
        
    }
    return self;
}
- (id)initWithURL:(NSURL *)url withDelegate:(id<XMPPTransportDelegate>)aDelegate;
{
    self = [self initWithURL:url withDelegate:aDelegate withDelegateQueue:NULL];
    if (self) {
    }
    return self;
    
}
- (id)initWithURL:(NSURL *)url withDelegate:(id<XMPPTransportDelegate>)aDelegate withDelegateQueue:(dispatch_queue_t)aDispatchQueue;
{
    self = [super init];
    if (self) {
        _webSocket = [[SRWebSocket alloc] initWithURL:url protocols:@[@"xmpp"]];
        _webSocket.delegate = self;
        
    }
    return self;
}

- (BOOL)isConnected
{
    if(_webSocket.readyState == SR_OPEN)
        return YES;
    return NO;
}

- (BOOL)connect:(NSError **)errPtr{
    [_multicastDelegate transportWillConnect:self];
    [_webSocket open];
    
    return YES;
}


- (void)addDelegate:(id)delegate withDelegateQueue:(dispatch_queue_t)aQueue
{
    if (!_multicastDelegate) {
        _multicastDelegate = (GCDMulticastDelegate <XMPPTransportDelegate> *)[[GCDMulticastDelegate alloc] init];
    }
    
    [_multicastDelegate addDelegate:delegate delegateQueue:aQueue];
 
}

- (void) removeDelegate:(id)delegate
{
    [_multicastDelegate removeDelegate:delegate];
 
}
- (void)removeDelegate:(id)delegate withDelegateQueue:(dispatch_queue_t)aQueue;
{
    [_multicastDelegate removeDelegate:delegate delegateQueue:aQueue];
}

- (void)disconnect{
    [_webSocket close];
    
}
- (void)sendData:(id)aData withTimeout:(NSTimeInterval)timeout tag:(long)tag
{
    [_webSocket send:aData];
}


/*
 
 - (void)transportWillConnect:(id <XMPPTransportProtocol>)transport;
 - (void)transportDidStartNegotiation:(id <XMPPTransportProtocol>)transport;
 - (void)transportDidConnect:(id <XMPPTransportProtocol>)transport;
 - (void)transportWillDisconnect:(id <XMPPTransportProtocol>)transport;
 - (void)transportWillDisconnect:(id<XMPPTransportProtocol>)transport withError:(NSError *)err;
 - (void)transportDidDisconnect:(id <XMPPTransportProtocol>)transport;
 - (void)transport:(id <XMPPTransportProtocol>)transport willSecureWithSettings:(NSDictionary *)settings;
 - (void)transport:(id <XMPPTransportProtocol>)transport didReceiveStanza:(NSXMLElement *)stanza;
 - (void)transport:(id <XMPPTransportProtocol>)transport didReceiveError:(id)error;
 - (void)transportDidSecure:(id <XMPPTransportProtocol>)transport;
 */
#pragma mark -
#pragma mark - SRWebSocketDelegate

- (void)webSocket:(SRWebSocket *)webSocket didReceiveMessage:(id)message{
    //[_multicastDelegate ]
    
    NSData* kData;
    if ([message isKindOfClass:[NSString class]]) {
        kData = [message dataUsingEncoding:NSUTF8StringEncoding];
    }
    else if ([message isKindOfClass:[NSData data]]){
        kData = message;
    }
    
    [_multicastDelegate transport:self didReceiveData:kData];
}

- (void)webSocketDidOpen:(SRWebSocket *)webSocket
{
    [_multicastDelegate transportDidConnect:self];
}
- (void)webSocket:(SRWebSocket *)webSocket didFailWithError:(NSError *)error
{
    [_multicastDelegate transport:self didReceiveError:error];
}
- (void)webSocket:(SRWebSocket *)webSocket didCloseWithCode:(NSInteger)code reason:(NSString *)reason wasClean:(BOOL)wasClean
{
    [_multicastDelegate transportDidDisconnect:self];
}
@end

//
// NetworkRecProp.swift
// FireflyApp
//
// Created by Christian Adam on 12.05.15.
// Copyright (c) 2015 Hochschule Darmstadt. All rights reserved.
//

import Foundation

@asmname("ytcpsocket_send") func c_ytcpsocket_send(fd:Int32, buff:UnsafePointer<UInt8>, len:Int32) -> Int32
@asmname("ytcpsocket_pull") func c_ytcpsocket_pull(fd:Int32, buff:UnsafePointer<UInt8>, len:Int32) -> Int32
@asmname("ytcpsocket_listen") func c_ytcpsocket_listen(addr:UnsafePointer<Int8>, port:Int32)->Int32
@asmname("ytcpsocket_accept") func c_ytcpsocket_accept(onsocketfd:Int32, ip:UnsafePointer<Int8>, port:UnsafePointer<Int32>) -> Int32

public class SocketInformations{
    var ip:String
    var port:Int
    var fd:Int32?
    public init(ip:String, port:Int){
        self.ip=ip
        self.port=port
    }
}

public class TCPServer:SocketInformations{
    
    public func listen()->(Bool, String){
        var fd:Int32=c_ytcpsocket_listen(ip, Int32(port))
        if fd>0{
            self.fd=fd
            return (true, "listen success")
        }else{
            return (false, "listen fail")
        }
    }
    
    public func accept()->TCPClient?{
        if let serferfd=fd{
            var buff:[Int8] = [Int8](count:16, repeatedValue:0x0)
            var port:Int32=0
            var clientfd:Int32=c_ytcpsocket_accept(serferfd, &buff, &port)
            if clientfd<0{
                return nil
            }
            var tcpClient:TCPClient=TCPClient(ip: String(CString: buff, encoding: NSUTF8StringEncoding)!, port: Int(port))
            tcpClient.fd=clientfd
            return tcpClient
        }
        return nil
    }
}

public class TCPClient:SocketInformations{
    
    public func send(str:String)->(Bool, String){
        if let fd:Int32=fd{
            var sendsize:Int32=c_ytcpsocket_send(fd, str, Int32(strlen(str)))
            if sendsize==Int32(strlen(str)){
                return (true, "send success")
            }else{
                return (false, "send error")
            }
        }else{
            return (false, "socket not open")
        }
    }
    
    public func read(buffersize:Int)->[UInt8]?{
        if let fd:Int32=fd{
            var buff:[UInt8] = [UInt8](count:buffersize, repeatedValue:0x0)
            var readLen:Int32=c_ytcpsocket_pull(fd, &buff, Int32(buffersize))
            if readLen<=0{
                return nil
            }
            var signs=buff[0...Int(readLen-1)]
            var data:[UInt8] = Array(signs)
            return data
        }
        return nil
    }
}
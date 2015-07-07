//
// ComponentClasses.swift
// FireflyApp
//
// Created by Christian Adam on 12.05.15.
// Copyright (c) 2015 Hochschule Darmstadt. All rights reserved.
//

import Foundation

/**
Function Hooking for binding functions from a c-library on swift functions.
*/
@asmname("ytcpsocket_send") func c_ytcpsocket_send(fd:Int32, buff:UnsafePointer<UInt8>, len:Int32) -> Int32
@asmname("ytcpsocket_pull") func c_ytcpsocket_pull(fd:Int32, buff:UnsafePointer<UInt8>, len:Int32) -> Int32
@asmname("ytcpsocket_listen") func c_ytcpsocket_listen(addr:UnsafePointer<Int8>, port:Int32)->Int32
@asmname("ytcpsocket_accept") func c_ytcpsocket_accept(onsocketfd:Int32, ip:UnsafePointer<Int8>, port:UnsafePointer<Int32>) -> Int32

/**
This class contains variables to save ip and port addresses and the socket informations.
*/
public class SocketInformations{
    var ip:String
    var port:Int
    var fd:Int32?
    public init(ip:String, port:Int){
        self.ip=ip
        self.port=port
    }
}

/**
This class contains the functionality for listen on a port and initialize a socket communication to a client
*/
public class TCPServer:SocketInformations{
    
    /**
    This function is listening on a port
    
    :return: a value for success or not
    :return: a message for success or not
    */
    public func listen()->(Bool, String){
        var fd:Int32=c_ytcpsocket_listen(ip, Int32(port))
        if fd>0{
            self.fd=fd
            return (true, "listen success")
        }else{
            return (false, "listen fail")
        }
    }
    
    /**
    This function is waiting for a incoming signal from a client and create a new TCPcommunication object for the later communication with the client.
    
    :return: nil if failed or the TCPcommunication object for the later communication
    */
    public func accept()->TCPcommunication?{
        if let serferfd=fd{
            var buff:[Int8] = [Int8](count:16, repeatedValue:0x0)
            var port:Int32=0
            var clientfd:Int32=c_ytcpsocket_accept(serferfd, &buff, &port)
            if clientfd<0{
                return nil
            }
            var tCPcommunication:TCPcommunication=TCPcommunication(ip: String(CString: buff, encoding: NSUTF8StringEncoding)!, port: Int(port))
            tCPcommunication.fd=clientfd
            return tCPcommunication
        }
        return nil
    }
}

/**
This class contains the functionality for sending and reading the data to/from the client.
*/
public class TCPcommunication:SocketInformations{
    
    /**
    This function is sending the delivered string to the client
    
    :return: the TCPcommunication object for the later communication
    */
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
    
    /**
    This function is reading the delivered string from the client
    
    :return: the readed bytes in a array or nil if failed
    */
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
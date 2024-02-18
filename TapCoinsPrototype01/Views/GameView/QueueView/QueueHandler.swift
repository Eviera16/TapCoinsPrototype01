//
//  QueueHandler.swift
//  TapCoinsPrototype01
//
//  Created by Eric Viera on 2/18/24.
//

import Foundation
import SocketIO
import SwiftUI

class QueueHandler: NSObject{
    @AppStorage("debug") private var debug: Bool?
    static let sharedInstance = QueueHandler()
//    let socket = SocketManager(socketURL: URL(string: ProcessInfo.processInfo.environment["queueSocket"]!)!, config: [.log(true), .compress])
    let socket = SocketManager(socketURL: URL(string: "https://tapped-queue.herokuapp.com")!, config: [.log(true), .compress])
    let devSocket = SocketManager(socketURL: URL(string: "http://127.0.0.1:3000")!, config: [.log(true), .compress])
    var mSocket: SocketIOClient!
    override init(){
        super.init()
        if debug ?? true{
            mSocket = devSocket.defaultSocket
        }
        else{
            mSocket = socket.defaultSocket
        }
    }

    func getSocket() -> SocketIOClient {
        return mSocket
    }

    func establishConnection(){
        mSocket.connect()
    }

    func closeConnection(){
        mSocket.disconnect()
    }
}

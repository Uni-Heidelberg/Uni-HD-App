//
//  Constants.swift
//  uni-hd
//
//  Created by Nils Fischer on 24.03.15.
//  Copyright (c) 2015 Universit&#228;t Heidelberg. All rights reserved.
//

import Foundation

@objc public class UHDRemoteConstants { // TODO: rename and make struct when unnecessary to access from objc

    public struct Server {
        public static let APIBaseURL = NSURL(string: "http://appserver.physik.uni-heidelberg.de/api/")!
        public static let StaticContentBaseURL = NSURL(string: "http://appserver.physik.uni-heidelberg.de/static/")!
    }
    
    public class func serverAPIBaseURL() -> NSURL {
        return Server.APIBaseURL
    }
    public class func serverStaticContentBaseURL() -> NSURL {
        return Server.StaticContentBaseURL
    }
    
}

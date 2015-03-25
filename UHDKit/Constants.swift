//
//  Constants.swift
//  uni-hd
//
//  Created by Nils Fischer on 24.03.15.
//  Copyright (c) 2015 Universit&#228;t Heidelberg. All rights reserved.
//

import Foundation

// TODO: remove prefix and use @objc(UHDConstants) when this is handled correctly
@objc public class UHDConstants {
    
    public struct UserDefaultsKey {
        public static let SelectedMensaId = "UHDUserDefaultsKeySelectedMensaId"
        public static let MensaPriceCategory = "UHDUserDefaultsKeyMensaPriceCategory"
        public static let MapType = "UHDUserDefaultsKeyMapType"
        public static let ShowCampusOverlay = "UHDUserDefaultsKeyShowCampusOverlay"
        public static let Vegetarian = "UHDUserDefaultsKeyVegetarian"
    }
    public class func userDefaultsKeySelectedMensaId() -> String {
        return UserDefaultsKey.SelectedMensaId
    }
    public class func userDefaultsKeyMensaPriceCategory() -> String {
        return UserDefaultsKey.MensaPriceCategory
    }
    public class func userDefaultsKeyMapType() -> String {
        return UserDefaultsKey.MapType
    }
    public class func userDefaultsKeyShowCampusOverlay() -> String {
        return UserDefaultsKey.ShowCampusOverlay
    }
    public class func userDefaultsKeyVegetarian() -> String {
        return UserDefaultsKey.Vegetarian
    }
    
    public struct RemoteDatasourceKey {
        public static let News = "UHDRemoteDatasourceKeyNews"
        public static let Mensa = "UHDRemoteDatasourceKeyMensa"
        public static let Maps = "UHDRemoteDatasourceKeyMaps"
    }
    public class func remoteDatasourceKeyNews() -> String {
        return RemoteDatasourceKey.News
    }
    public class func remoteDatasourceKeyMensa() -> String {
        return RemoteDatasourceKey.Mensa
    }
    public class func remoteDatasourceKeyMaps() -> String {
        return RemoteDatasourceKey.Maps
    }

}

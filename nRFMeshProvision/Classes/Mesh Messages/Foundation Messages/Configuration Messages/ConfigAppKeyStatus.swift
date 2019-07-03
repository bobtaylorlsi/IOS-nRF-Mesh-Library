//
//  ConfigAppKeyStatus.swift
//  nRFMeshProvision
//
//  Created by Aleksander Nowakowski on 12/06/2019.
//

import Foundation

public struct ConfigAppKeyStatus: ConfigNetAndAppKeyMessage, ConfigStatusMessage {
    public static let opCode: UInt32 = 0x8003  
    
    public var parameters: Data? {
        return Data([status.rawValue]) + encodeNetAndAppKeyIndex()
    }
    
    public var isSegmented: Bool {
        return true
    }
    
    public let networkKeyIndex: KeyIndex
    public let applicationKeyIndex: KeyIndex
    public let status: ConfigMessageStatus
    
    public init(applicationKey: ApplicationKey, status: ConfigMessageStatus) {
        self.applicationKeyIndex = applicationKey.index
        self.networkKeyIndex = applicationKey.boundNetworkKey.index
        self.status = status
    }
    
    public init?(parameters: Data) {
        guard parameters.count == 4 else {
            return nil
        }
        guard let status = ConfigMessageStatus(rawValue: parameters[0]) else {
            return nil
        }
        self.status = status
        (networkKeyIndex, applicationKeyIndex) = ConfigAppKeyUpdate.decodeNetAndAppKeyIndex(from: parameters, at: 1)
    }
    
}

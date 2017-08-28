import Foundation

import MKHSyncSession

//===

public
typealias Parameters = [String: Any]

//===

public
typealias OnConfigureRequestBlock = (NSMutableURLRequest, Parameters?) -> NSMutableURLRequest

public
typealias OnDidPrepareRequestBlock = (NSMutableURLRequest) -> NSMutableURLRequest

public
typealias OnDidReceiveDataResponseBlock = (URLRequest, DataTaskResult) -> Void

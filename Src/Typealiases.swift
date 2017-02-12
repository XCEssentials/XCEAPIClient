//
//  Typealiases.swift
//  MKHAPIClient
//
//  Created by Maxim Khatskevich on 2/12/17.
//  Copyright © 2017 Maxim Khatskevich. All rights reserved.
//

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

//
//  Types.swift
//  MKHAPIClient
//
//  Created by Maxim Khatskevich on 2/12/17.
//  Copyright © 2017 Maxim Khatskevich. All rights reserved.
//

import Foundation

//===

public
enum HTTPHeaderFieldName: String
{
    case
        Authorization,
        ContentType = "Content-Type"
}

//===

public
enum ContentType: String
{
    case
        FormURLEncoded = "application/x-www-form-urlencoded"
}

//===

public
enum HTTPMethod: String
{
    case
        GET,
        POST,
        PUT,
        PATCH,
        DELETE,
        HEAD,
        TRACE,
        CONNECT,
        OPTIONS
}

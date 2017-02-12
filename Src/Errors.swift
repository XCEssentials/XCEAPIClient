//
//  Errors.swift
//  MKHAPIClient
//
//  Created by Maxim Khatskevich on 2/12/17.
//  Copyright © 2017 Maxim Khatskevich. All rights reserved.
//

import Foundation

//===

public
protocol APIClientError: Error {}

//===

struct URLCreationFailed: APIClientError
{
    let basePath: String
    let relativePath: String
}

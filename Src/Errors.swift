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

struct InvalidBasePath: APIClientError
{
    let basePath: String
}

//===

struct InvalidRelativePath: APIClientError
{
    let basePath: String
    let relativePath: String
}

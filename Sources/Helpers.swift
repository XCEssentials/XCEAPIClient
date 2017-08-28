import Foundation

//===

public
enum HTTPHeaderFieldName: String
{
    case
        authorization = "Authorization",
        contentType = "Content-Type"
}

//===

public
enum ContentType: String
{
    case formURLEncoded = "application/x-www-form-urlencoded"
}

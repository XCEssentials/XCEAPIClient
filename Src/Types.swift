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

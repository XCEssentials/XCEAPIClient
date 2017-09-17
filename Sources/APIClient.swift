import Foundation

//===

public
struct APIClient: APIClientCore
{
    // MARK: - APIClientCore conformance
    
    public
    let session: URLSession
    
    public
    let basePath: String
    
    public
    let onConfigureRequest: OnConfigureRequest
    
    public
    let onDidPrepareRequest: OnDidPrepareRequest?
    
    public
    let onDidReceiveDataResponse: OnDidReceiveDataResponse?
    
    // MARK: - Defautls
    
    public
    static
    let onConfigureRequest: OnConfigureRequest = {
        
        try $0 = URLEncoding.default.encode($0, with: $1)
    }
    
    // MARK: - Initializers
    
    public
    init(
        basePath: String,
        onConfigureRequest: @escaping OnConfigureRequest = APIClient.onConfigureRequest,
        onDidPrepareRequest: OnDidPrepareRequest? = nil,
        onDidReceiveDataResponse: OnDidReceiveDataResponse? = nil,
        sessionConfig: URLSessionConfiguration = .default,
        sessionDelegate: URLSessionDelegate? = nil,
        sessionDelegateQueue: OperationQueue? = nil
        ) throws
    {
        guard
            URL(string: basePath) != nil
        else
        {
            throw InvalidBasePath(basePath: basePath)
        }
        
        //===
        
        self.basePath = basePath
        
        self.session = URLSession(
            configuration: sessionConfig,
            delegate: sessionDelegate,
            delegateQueue: sessionDelegateQueue
        )
        
        self.onConfigureRequest = onConfigureRequest
        self.onDidPrepareRequest = onDidPrepareRequest
        self.onDidReceiveDataResponse = onDidReceiveDataResponse
    }
}

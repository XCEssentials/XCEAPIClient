public
protocol RequestBuilder
{
    static
    var relativePath: String { get }

    func buildParameters() throws -> Parameters
}

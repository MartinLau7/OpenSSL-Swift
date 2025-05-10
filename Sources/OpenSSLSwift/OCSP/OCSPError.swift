#if canImport(FoundationEssentials)
    import FoundationEssentials
#else
    import Foundation
#endif

public enum OCSPError: Error {
    case badURL
    case badResponse
    case unSupportsOCSP
    case emptyResponseBody
    case trustSetupFailure
    case responseConversionFailure
    case requestedCertificateNotInResponse

    case requestError(statusCode: Int)
    case responseError(statusCode: Int32)
}

extension OCSPError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .badURL:
            return "The URL for OCSP request is invalid."
        case .badResponse:
            return "The OCSP response is invalid."
        case .unSupportsOCSP:
            return "OCSP is not supported for this certificate."
        case .emptyResponseBody:
            return "The OCSP response body is empty."
        case .trustSetupFailure:
            return "Failed to set up trust for OCSP response."
        case .responseConversionFailure:
            return "Failed to convert OCSP response."
        case .requestedCertificateNotInResponse:
            return "The requested certificate is not present in the OCSP response."
        case let .requestError(statusCode):
            return "Failed to make OCSP request with status code: \(statusCode)."
        case let .responseError(statusCode):
            return "Received OCSP response with error status code: \(statusCode)."
        }
    }
}

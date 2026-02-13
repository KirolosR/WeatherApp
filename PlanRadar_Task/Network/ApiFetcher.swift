//
//  ApiFetcher.swift
//  PlanRadar_Task
//
//  Created by Kirolos Ramses on 22/10/2025.
//

import Foundation

public protocol Fetcher {
    
    @discardableResult
    func fetch<Request> (request: Request) async -> Result<Request.Response, NetworkError> where Request : BaseRequestProtocol
    
    @discardableResult
    func fetchLocalJSON<Response: Codable>(_ jsonFileName: String, _ responseModel: Response.Type) async -> Result<Response, NetworkError>
    
    @discardableResult
    func fetchMultiPart<Request> (request: Request) async -> Result<Request.Response, NetworkError> where Request : MultipartRequestProtocol
}


// Base
public final class APIFetcher: Fetcher {
    static let shared = APIFetcher()
    
    /// Use this to check about internet connection
    static var isConnectedToInternet: Bool {
        return NetworkMonitor.shared.isReachable
    }
    
    
}

// Locale JSON Fetch
extension APIFetcher {
    public func fetchLocalJSON<Response>(
        _ jsonFileName: String,
        _ responseModel: Response.Type
    )
    async -> Result<Response, NetworkError> where Response : Decodable, Response : Encodable
    {
        do {
            // Get the URL of the JSON file in the main bundle
            guard let url = Bundle.main.url(forResource: jsonFileName, withExtension: "json") else {
                throw NetworkError.fileNotFound
            }
            
            // Read data from the file
            let data = try Data(contentsOf: url)
            
            print(data.prettyPrintedJSONString ?? "Empty json file")
            // Decode JSON data into the specified Response type
            let decoder = JSONDecoder()
            let result = try decoder.decode(responseModel, from: data)
            
            // Return the decoded result
            return .success(result)
        } catch {
            // Handle any errors that may occur during the process
            if let decodingError = error as? DecodingError {
                return .failure(NetworkError.decodingError(decodingError.localizedDescription))
            } else {
                return .failure(NetworkError.unknown(code: 500, error: error.localizedDescription))
            }
        }
    }
    
    public func parseLocalJSON<Response>(
        _ json: String,
        _ responseModel: Response.Type
    )
    async -> Result<Response, NetworkError> where Response : Decodable, Response : Encodable
    {
    do {
        // Get the URL of the JSON file in the main bundle
        guard let data = json.data(using: .utf8) else {
            throw NetworkError.invalidJSON("Invalid JSON")
        }
    
        
        // Decode JSON data into the specified Response type
        let decoder = JSONDecoder()
        let result = try decoder.decode(responseModel, from: data)
        
        // Return the decoded result
        return .success(result)
    } catch {
        // Handle any errors that may occur during the process
        if let decodingError = error as? DecodingError {
            return .failure(NetworkError.decodingError(decodingError.localizedDescription))
        } else {
            return .failure(NetworkError.unknown(code: 500, error: error.localizedDescription))
        }
    }
    }
    
}

//Response Handler
extension APIFetcher {
    fileprivate func handleResponse<Request: BaseRequestProtocol>(data: Data, response: URLResponse, request: Request, decoder: JSONDecoder) -> Result<Request.Response, NetworkError> {
        guard let httpResponse = response as? HTTPURLResponse else {
            return .failure(.nonHTTPResponse)
        }
        
        
        switch HTTPStatusCode(rawValue: httpResponse.statusCode) {
            case .information, .success:
                guard let decodedResponse = try? decoder.decode(Request.Response.self, from: data) else {
                    let error = NetworkError.decodingError("Decoding Error")
                    responseLogger(request: request, error: error)
                    return .failure(error)
                }
                responseLogger(request: request, responseData: data, response: httpResponse)
                return .success(decodedResponse)
            case .clientError:
                let error: NetworkError
                switch httpResponse.statusCode {
                    case 401:
                        error = NetworkError.unauthorized(code: httpResponse.statusCode, error: "Unauthorized")
                    default:
                        error = NetworkError.serverError(code: httpResponse.statusCode, error: "")
                }
                responseLogger(request: request, error: error)
                return .failure(error)
            default:
                let error = NetworkError.serverError(code: httpResponse.statusCode, error: "")
                responseLogger(request: request, error: error)
                return .failure(error)
        }
    }
}

//MARK: Fetcher
extension APIFetcher {
    public func fetch<Request> (request: Request) async -> Result<Request.Response, NetworkError> where Request : BaseRequestProtocol {
       
            let decoder = JSONDecoder()
            //SessionConfiguration
            let sessionConfig = URLSessionConfiguration.default
            sessionConfig.timeoutIntervalForRequest = TimeInterval(request.requestTimeOut)
            //Handel URL
            guard let url =  URL(string: request.requestURL) else { return.failure(.badURL("Invalid Url")) }
            requestLogger(request: request)
            //Request
            let urlRequest = generateUrlRequest(url: url, request: request)
            requestBodyLogger(request: urlRequest)
            // response
            do {
                let (data, response) = try await URLSession.shared.data(for: urlRequest)
                return handleResponse(data: data, response: response, request: request, decoder: decoder)
            } catch {
                let error = NetworkError.invalidJSON("Invalid JSON")
                responseLogger(request: request, error: error)
                return .failure(error)
            }
        
    }
    
    
    fileprivate func generateUrlRequest(url: URL, request: any BaseRequestProtocol) -> URLRequest {
        var urlRequest: URLRequest
        urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = request.httpMethod.rawValue
        urlRequest.allHTTPHeaderFields = request.defaultHeaders
        
        switch request.httpMethod {
            case .GET:
                var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false)
                if let params = request.parameters, !params.isEmpty {
                    urlComponents?.queryItems = params.map {
                        URLQueryItem(name: $0.key, value: "\($0.value)")
                    }
                }
                urlRequest.url = urlComponents?.url ?? url
                
            default:
            if request.sendAsParameters {
                var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false)
                if let params = request.parameters, !params.isEmpty {
                    urlComponents?.queryItems = params.map {
                        URLQueryItem(name: $0.key, value: "\($0.value)")
                    }
                }
                urlRequest.url = urlComponents?.url ?? url
            } else {
                if let params = request.parameters?.jsonData {
                    urlRequest.httpBody = params
                }
                debugPrint("paramters: " , request.parameters as Any)
            }
               
        }
        
//        debugPrint(urlRequest.url as Any)
        return urlRequest
    }
}
//MARK: MultiPart Fetcher
extension APIFetcher {
    public func fetchMultiPart<Request: MultipartRequestProtocol>(request: Request) async -> Result<Request.Response, NetworkError> {
            let decoder = JSONDecoder()
            guard let url = URL(string: request.requestURL) else {
                return .failure(.badURL("Invalid URL"))
            }
            
            let urlRequest = generateMultiPartUrlRequest(url: url, request: request)
            requestLogger(request: request)
            requestMultiPartBodyLogger(request: urlRequest)
            
            if urlRequest.httpBody != nil {
                do {
                    let (data, response) = try await URLSession.shared.data(for: urlRequest)
                    return handleResponse(data: data, response: response, request: request, decoder: decoder)
                } catch {
                    let error = NetworkError.invalidJSON("Upload Error: \(error.localizedDescription)")
                    responseLogger(request: request, error: error)
                    return .failure(error)
                }
            } else {
                let error = NetworkError.badRequest(code: 1, error: "Failed to create multipart/form-data body")
                responseLogger(request: request, error: error)
                return .failure(error)
            }
        
    }
    
    fileprivate func generateMultiPartUrlRequest(url: URL, request: any MultipartRequestProtocol) -> URLRequest {
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = request.httpMethod.rawValue
        urlRequest.allHTTPHeaderFields = request.defaultHeaders
        
        let boundary = "Boundary-\(UUID().uuidString)"
        let contentType = "multipart/form-data; boundary=\(boundary)"
        urlRequest.setValue(contentType, forHTTPHeaderField: "Content-Type")
        
        var body = Data()
        for (key, value) in request.multiPartParam {
            body.append("--\(boundary)\r\n")
            
            switch value {
                case .data(let data, let fileName, let mimeType):
                    body.append("Content-Disposition: form-data; name=\"\(key)\"; filename=\"\(fileName)\"\r\n")
                    body.append("Content-Type: \(mimeType)\r\n\r\n")
                    body.append(data)
                    body.append("\r\n")
                    
                case .text(let text):
                    body.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
                    body.append("\(text)\r\n")
            }
        }
        
        body.append("--\(boundary)--\r\n")
        urlRequest.httpBody = body
        return urlRequest
    }
}
//MARK: Logger
extension APIFetcher {
    
    private func requestLogger(request: any BaseRequestProtocol) {
        print("\n📤 Will send request", request.httpMethod.rawValue, ":", request.requestURL)
        print("\n🏷 Headers:")
        for (headerKey, headerValue) in request.baseHeaders {
            print(headerKey, ":", headerValue)
        }
        
        if let parameters = request.parameters {
            print("\n🏷 Parameters:")
            for (key, value) in parameters {
                if let valueString = value as? CustomStringConvertible {
                    print("\(key): \(valueString)")
                } else {
                    print("\(key): \(value)")
                }
            }
        } else {
            print("No parameters available.")
        }
    }
    
    private func requestMultiPartBodyLogger(request: URLRequest) {
        if let responseDataString = request.httpBody?.prettyPrintedDescription {
            print("\nBody:\n",responseDataString)
        } else{
            print("\nBody: Empty...")
        }
    }
    
    private func requestBodyLogger(request: URLRequest) {
        if let responseDataString = request.httpBody?.prettyPrintedJSONString {
            print("\nBody:\n",responseDataString)
        } else{
            print("\nBody: Empty...")
        }
    }
    
    private func responseLogger(request: any BaseRequestProtocol, responseData: Data? = nil ,response: HTTPURLResponse? = nil, error: NetworkError? = nil) {
        if let error = error {
            print("\n❌ Request", request.httpMethod.rawValue, ":", request.requestURL, error)
        }
        
        if let response = response {
            let status = (200..<300) ~= response.statusCode ? "✅" : "⚠️"
            print("\n",status, "Did receive response", response.statusCode, ":", "for request", request.requestURL)
            if let responseDataString = responseData?.prettyPrintedJSONString {
                print("\nBody:\n",responseDataString)
            } else{
                print("\nBody: Empty...")
            }
        }
    }
}

public protocol InternetConnectionChecker {
    func isConnectedToInternet() -> Bool
}

public extension InternetConnectionChecker {
    func isConnectedToInternet() -> Bool {
        return APIFetcher.isConnectedToInternet
    }
}



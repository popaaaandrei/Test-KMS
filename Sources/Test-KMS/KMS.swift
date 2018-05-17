//
//  KMS.swift
//  App
//
//  Created by andrei on 10/05/2018.
//

import Foundation
import HTTP
import JSON
import Sockets
import TLS



enum KMSError : Error {
    case wrongResponse
    case plaintextMissing
    case unauthorized
}





func retrieveKeyKMS(token: String) throws -> String {
    
    let projectID = "tonal-history-203106"
    let keyRing = "test-keyring-eu"
    let keyName = "test-key"
    
    let ciphertext = "CiQAYQMgAbbpYA8h3miHU+QbbrfI5crc3t+0AKJbwbjcGv8iPYYSMgDoRYINeO0ATpI5rvTfAzjUu7e+XNX4d0XPWy8iVJdleGGbeuYtqgKB2XRQxKJJtS+6"
    
    
    /*
     curl -s -X POST "https://cloudkms.googleapis.com/v1/projects/[PROJECT_ID]/locations/global/keyRings/test/cryptoKeys/quickstart:decrypt" \
     -d "{\"ciphertext\":\"[YOUR_CIPHER_TEXT]\"}" \
     -H "Authorization:Bearer $(gcloud auth print-access-token)" \
     -H "Content-Type:application/json"
     */
    
    // build URI
    let googleKMSURI = "/v1/projects/\(projectID)/locations/europe-west4/keyRings/\(keyRing)/cryptoKeys/\(keyName):decrypt"
    
    let headers: [HeaderKey : String] = [HeaderKey.contentType : "application/json",
                                         "Authorization": "Bearer \(token)"]
    
    // build JSON
    var json = JSON()
    try json.set("ciphertext", ciphertext)
    let jsonBytes = try json.makeBytes()
    
    // socket
    let socket = try TCPInternetSocket(
        scheme: "https",
        hostname: "cloudkms.googleapis.com",
        port: 443
    )
    // TLS socket
    let context = try Context(.client)
    let tlsSocket = TLS.InternetSocket(socket, context)
    
    // HTTPS Client
    let client = try TLSClient(tlsSocket)
    
    // Request
    let req = Request(method: .post,
                      uri: googleKMSURI,
                      headers: headers,
                      body: .data(jsonBytes))
    
    // response
    let response = try client.respond(to: req)
    print("=============================================")
    print(response)
    guard response.status != .unauthorized else {
        throw KMSError.unauthorized
    }
    
    // extract key
    return try response.extractKey()
}



extension Response {
    
    /// parses Response and extracts key from plaintext
    func extractKey() throws -> String {
        // accept only json response
        guard case let .data(bytes) = body else {
            throw KMSError.wrongResponse
        }
        
        let json = try JSON(bytes: bytes)
        print("=============================================")
        print(json)
        
        guard let plaintext = json["plaintext"]?.string, let data = Data(base64Encoded: plaintext), let key = data.asStringUTF8() else {
            throw KMSError.plaintextMissing
        }
        
        return key
    }
    
}


extension Data {
    
    /// Data -> String UTF8
    func asStringUTF8() -> String? {
        return String(data: self, encoding: .utf8)
    }
    
}





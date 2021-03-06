import Foundation
import Dispatch
import OAuth2

print("Test-KMS: 0.3")


/*
 curl -s -X POST "https://cloudkms.googleapis.com/v1/projects/[PROJECT_ID]/locations/global/keyRings/test/cryptoKeys/quickstart:decrypt" \
 -d "{\"ciphertext\":\"[YOUR_CIPHER_TEXT]\"}" \
 -H "Authorization:Bearer $(gcloud auth print-access-token)" \
 -H "Content-Type:application/json"
 */


func main() throws {
    
    let scopes = ["https://www.googleapis.com/auth/cloud-platform", "https://www.googleapis.com/auth/cloudkms"]
    
    guard let provider = DefaultTokenProvider(scopes: scopes) else {
        print("Unable to obtain an auth token.\nTry pointing GOOGLE_APPLICATION_CREDENTIALS to your service account credentials.")
        return
    }
    
    let sem = DispatchSemaphore(value: 0)
    try provider.withToken() {(token, error) -> Void in
        if let token = token {
            print("Token:\n\(token)")
            //            let encoder = JSONEncoder()
            //            if let token = try? encoder.encode(token) {
            //                print("\(String(data:token, encoding:.utf8)!)")
            //            }
            
            
            
//            do {
//                let google = try GoogleSession(tokenProvider: provider)
//                print("GoogleSession done")
//                try google.retrieveKeyKMS()
//                print("retrieveKeyKMS done")
//            }
//            catch {
//                print("ERROR \(error)")
//            }
            
        }
        if let error = error {
            print("ERROR \(error)")
        }
        sem.signal()
    }
    
    _ = sem.wait(timeout: DispatchTime.distantFuture)
    print("Got token")
    let google = try GoogleSession(tokenProvider: provider)
    print("GoogleSession done")
    // try google.getMe()
    try google.retrieveKeyKMS()
    print("retrieveKeyKMS done")
    
    
}



try main()




import Foundation
import Dispatch


print("Test-KMS: 0.3")


/*
 curl -s -X POST "https://cloudkms.googleapis.com/v1/projects/[PROJECT_ID]/locations/global/keyRings/test/cryptoKeys/quickstart:decrypt" \
 -d "{\"ciphertext\":\"[YOUR_CIPHER_TEXT]\"}" \
 -H "Authorization:Bearer $(gcloud auth print-access-token)" \
 -H "Content-Type:application/json"
 */


func main() throws {
    
    // "https://www.googleapis.com/auth/cloud-platform"
    let scopes = ["https://www.googleapis.com/auth/cloudkms"]
    
    guard let provider = DefaultTokenProvider(scopes: scopes) else {
        print("Unable to obtain an auth token.\nTry pointing GOOGLE_APPLICATION_CREDENTIALS to your service account credentials.")
        return
    }
    
    let sem = DispatchSemaphore(value: 0)
    try provider.withToken() {(token, error) -> Void in
        
        if let error = error {
            print("ERROR \(error)")
        }
        
        guard let token = token?.AccessToken else {
            print("No access token")
            return
        }
        
        print("Token:\n\(token)")
        
        do {
            try retrieveKeyKMS(token: token)
            print("retrieveKeyKMS done")
        }
        catch {
            print("ERROR \(error)")
        }
        
        sem.signal()
    }
    
    _ = sem.wait(timeout: DispatchTime.distantFuture)
}



try main()




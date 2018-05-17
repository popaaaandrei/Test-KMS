import Foundation
import Dispatch
import OAuth2

print("Hello, world!")


/*
 curl -s -X POST "https://cloudkms.googleapis.com/v1/projects/[PROJECT_ID]/locations/global/keyRings/test/cryptoKeys/quickstart:decrypt" \
 -d "{\"ciphertext\":\"[YOUR_CIPHER_TEXT]\"}" \
 -H "Authorization:Bearer $(gcloud auth print-access-token)" \
 -H "Content-Type:application/json"
 */


let scopes = ["https://www.googleapis.com/auth/cloud-platform"]

if let provider = DefaultTokenProvider(scopes: scopes) {
    let sem = DispatchSemaphore(value: 0)
    try provider.withToken() {(token, error) -> Void in
        if let token = token {
            let encoder = JSONEncoder()
            if let token = try? encoder.encode(token) {
                print("\(String(data:token, encoding:.utf8)!)")
            }
        }
        if let error = error {
            print("ERROR \(error)")
        }
        sem.signal()
    }
    _ = sem.wait(timeout: DispatchTime.distantFuture)
} else {
    print("Unable to obtain an auth token.\nTry pointing GOOGLE_APPLICATION_CREDENTIALS to your service account credentials.")
}



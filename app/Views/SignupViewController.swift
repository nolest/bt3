import UIKit
import AuthenticationServices

class SignupViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupAppleSignInButton()
    }

    func setupAppleSignInButton() {
        let appleButton = ASAuthorizationAppleIDButton(type: .signIn, style: .black)
        appleButton.translatesAutoresizingMaskIntoConstraints = false
        appleButton.addTarget(self, action: #selector(handleAppleSignIn), for: .touchUpInside)
        
        view.addSubview(appleButton)
        NSLayoutConstraint.activate([
            appleButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            appleButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            appleButton.heightAnchor.constraint(equalToConstant: 44), // Standard height
            appleButton.leadingAnchor.constraint(greaterThanOrEqualTo: view.leadingAnchor, constant: 30),
            appleButton.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -30)
        ])
    }

    @objc func handleAppleSignIn() {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email] // You can request fullName and email

        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
}

extension SignupViewController: ASAuthorizationControllerDelegate {
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            // User ID for this app
            let userIdentifier = appleIDCredential.user
            
            // User's full name and email, may be nil (only provided on first sign in)
            let fullName = appleIDCredential.fullName
            let email = appleIDCredential.email
            
            print("User ID: \(userIdentifier)")
            if let givenName = fullName?.givenName, let familyName = fullName?.familyName {
                print("User Name: \(givenName) \(familyName)")
            }
            if let email = email {
                print("User Email: \(email)")
            }
            
            // TODO: Here you would typically:
            // 1. Send the userIdentifier (and potentially identityToken, authorizationCode) to your backend server
            // 2. Your server verifies the token with Apple
            // 3. Create a session for the user or create a new account
            // 4. Navigate to the next screen in your app

            // For now, let's just dismiss or navigate to a placeholder
            print("Sign in with Apple successful!")
            // Example: Navigate to a home screen or dismiss this controller
            // if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
            //    let sceneDelegate = windowScene.delegate as? SceneDelegate {
            //     // Assuming you have a method in SceneDelegate to switch to the main app interface
            //     // sceneDelegate.showMainAppInterface()
            // }
        } else if let passwordCredential = authorization.credential as? ASPasswordCredential {
            // Sign in with an existing iCloud Keychain credential.
            let username = passwordCredential.user
            let password = passwordCredential.password
            
            print("Signed in with iCloud Keychain credential: User \(username)")
            // TODO: Handle sign in with this existing credential.
        }
    }

    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        // Handle error.
        print("Sign in with Apple failed: \(error.localizedDescription)")
        // You might want to display an alert to the user here.
    }
}

extension SignupViewController: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
} 
import SwiftUI
import Auth0

struct MainView: View {
    @State var user: User?

    var body: some View {
        if let user = self.user {
            VStack {
                ProfileView(user: user)
                Button("Logout", action: self.logout)
            }
        } else {
            Button("Login", action: self.login)
        }
    }
}

extension MainView {
    func login() {
        Auth0
            .webAuth()
            .audience("micro-elearning-auth") //Auth0 Dashboard -> API audience id
            .start { result in
                switch result {
                case .success(let credentials):
                    self.user = User(from: credentials.idToken)
                    print("||->\(credentials.accessToken)<-||")
                case .failure(let error):
                    print("Failed with: \(error)")
                }
            }
    }

    func logout() {
        Auth0
            .webAuth()
            .clearSession { result in
                switch result {
                case .success:
                    self.user = nil
                case .failure(let error):
                    print("Failed with: \(error)")
                }
            }
    }
}

//To link with Auth0 application, create Auth0.plist file:

//ClienId and Application domain from Auth0 dashboard -> application

//Auth0.plist

//<?xml version="1.0" encoding="UTF-8"?>
//<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
//<plist version="1.0">
//<dict>
//    <key>ClientId</key>
//    <string>ClientID</string>
//    <key>Domain</key>
//    <string>ApplicationDomain</string>
//</dict>
//</plist>


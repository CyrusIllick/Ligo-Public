//
//  DataGrab2.swift
//  Ligo
//
//  Created by Cyrus Illick on 22/07/2020.
//  Copyright © 2020 Ligo. All rights reserved.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth
import FirebaseStorage
import Firebase

class DataGrab{
    
    
    ///Stores and updates the user's name in a different document for easy access
    static func updateName(firstName:String,lastName:String, who:String){
        var values = [String:String]()
        values["firstName"] = firstName
        values["lastName"] = lastName

        print("Updating First and Last Name")
        Firestore.firestore().collection("user-data").document("names").setData([who:values], merge: true)
        
    }
    
    
    static func saveWebsites(sites:[String], completion: @escaping() -> Void){
        guard let uid = Auth.auth().currentUser?.uid else{return}

        Firestore.firestore().collection("users").document(uid).setData(["Websites":sites], merge: true) { (error) in
            if let error = error {
                print("failed to create card with error: ", error.localizedDescription)
                return
            }
            
            completion()
        }
    }
    
    
    
    /// Update a single field in the card info part of the database
    static func updateField(type: String, to: String, completion: @escaping() -> Void) {
    
        ///Updates the name in other documents as well
        if type == "firstName" || type == "lastName"{
            updateName(firstName: me.firstName, lastName: me.lastName, who: me.username)
            
        }
        
        let value = [type: to]
        
        guard let uid = Auth.auth().currentUser?.uid else{return}
        Firestore.firestore().collection("users").document(uid).setData(value, merge: true) { (error) in
            if let error = error {
                print("failed to create card with error: ", error.localizedDescription)
                return
            }
            
            completion()
        }
        
        
    }
    
    static func updatePrivacy(to: Bool, completion: @escaping() -> Void) {
        
        let value = ["isPublic": to]
        guard let uid = Auth.auth().currentUser?.uid else{return}
        Firestore.firestore().collection("users").document(uid).setData(value, merge: true) { (error) in
            if let error = error {
                print("failed to create card with error: ", error.localizedDescription)
                return
            }
            
            completion()
        }
    }
    
    /// Creates a new user
    static func createUser(email: String, password: String, newUsername: String,firstName:String,lastName:String, completion: @escaping (_ error: String?) -> Void) {
        
        Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
            if let error = error {
                
                print("Failed to sign up user with error", error.localizedDescription)
                
                
                completion(FirebaseErrorToString(error:error))
                return
            }
            
            guard let uid = result?.user.uid else { return }
            
            let values = ["username": newUsername, "email": email,"firstName":firstName,"lastName":lastName, "phone": "", "instagram": "", "snapchat": "", "facebook": "", "website" : "", "work" : "", "linkedin": "", "github": "", "bio" : "", "isPublic" : true, "identity" : "default", "tiktok": "", "spotify": "", "applemusic": "", "youtube": "", "website2": "", "website3": "", "twitter": "", "venmo": "", "website4": "", "soundcloud": "", "whatsapp": "", "grad1": "4FA3A7", "grad2": "8BEB93", "verified": false] as [String: Any]
            
            updateName(firstName: firstName, lastName: lastName, who: newUsername)
            
            Firestore.firestore().collection("users").document(uid).setData(values, merge: true) { (error) in
                
                
                if let error = error {
                    print("failed to update database values with error", error.localizedDescription)
                    completion("An unknown error occurred")
                    return
                }
            }
            
            completion(nil)
        }
    }
    
    
    
    ///Delete account
    static func deleteAccount(completion: @escaping (_ val: Bool) -> Void) {
        let user = Auth.auth().currentUser
        
        user?.delete { error in
            if let error = error {
                print("Account not successfully deleted for reason: \(error.localizedDescription)")
                completion(false)
            } else {
                deleteData()
                print("Account deleted")
                //TODO: - Put an alert to the user that their account was deleted'
                completion(true)
            }
        }
    }
    
    static fileprivate func deleteData(){
        guard let uid = Auth.auth().currentUser?.uid else{return}
        Firestore.firestore().collection("users").document(uid).collection("friends").getDocuments { (snapshot, error) in
            if let documents = snapshot?.documents{
                documents.forEach { (a) in
                    Firestore.firestore().collection("users").document(uid).collection("friends").document(a.documentID).delete()
                }
            }
        }
        Firestore.firestore().collection("users").document(uid).delete()
    }
    
    
    /// Returns the users own card with a completion handler
    /// Returns the card as an identity type
    static func getCard(completion:@escaping(_ val:Identity?) -> Void){
        
        guard let uid = Auth.auth().currentUser?.uid else{
            completion(nil)
            return
        }
        
        Firestore.firestore().collection("users").document(uid).getDocument(completion: { (snapshot, error) in
            
            if error != nil{
                completion(nil)
                return
            }
            
            guard let value = snapshot?.data() else{
                completion(nil)
                
                return}
            let identity = documentToIdentity(doc: value)
            username = identity.username
            completion(identity)
            
        })
    }
    
   
    
    static func documentToIdentity(doc value:[String:Any]) -> Identity{
        
        let username = value["username"] as? String  ?? ""
        let firstName = value["firstName"] as? String  ?? ""
        let lastName = value["lastName"] as? String  ?? ""
        
        
        let identity = Identity(name: username, identity: value["identity"] as? String  ?? "",firstName: firstName,lastName: lastName)
        
        identity.updateField(field: Identity.detailType.username, new: value["username"] as? String)
        
        identity.updateField(field: Identity.detailType.firstName, new: value["firstName"] as? String)
        identity.updateField(field: Identity.detailType.lastName, new: value["lastName"] as? String)
        
        identity.updateField(field: Identity.detailType.email, new: value["email"] as? String)
        identity.updateField(field: Identity.detailType.bio, new: value["bio"] as? String)
        identity.updateField(field: Identity.detailType.work, new: value["work"] as? String)
        identity.updateField(field: Identity.detailType.phone, new: value["phone"] as? String)
        identity.updateField(field: Identity.detailType.instagram, new: value["instagram"] as? String)
        identity.updateField(field: Identity.detailType.facebook, new: value["facebook"] as? String)

        identity.updateField(field: Identity.detailType.snapchat, new: value["snapchat"] as? String)
        identity.updateField(field: Identity.detailType.linkedin, new: value["linkedin"] as? String)
        identity.updateField(field: Identity.detailType.website, new: value["website"] as? String)
        identity.updateField(field: Identity.detailType.website2, new: value["website2"] as? String)
        identity.updateField(field: Identity.detailType.website3, new: value["website3"] as? String)
        identity.updateField(field: Identity.detailType.github, new: value["github"] as? String)
        identity.updateField(field: Identity.detailType.tiktok, new: value["tiktok"] as? String)
        identity.updateField(field: Identity.detailType.spotify, new: value["spotify"] as? String)
        identity.updateField(field: Identity.detailType.applemusic, new: value["applemusic"] as? String)
        identity.updateField(field: Identity.detailType.youtube, new: value["youtube"] as? String)
        identity.updateField(field: Identity.detailType.twitter, new: value["twitter"] as? String)
        identity.updateField(field: Identity.detailType.venmo, new: value["venmo"] as? String)
        identity.updateField(field: Identity.detailType.website4, new: value["website4"] as? String)
        identity.updateField(field: Identity.detailType.soundcloud, new: value["soundcloud"] as? String)
        identity.updateField(field: Identity.detailType.whatsapp, new: value["whatsapp"] as? String)
        
        identity.updateField(field: Identity.detailType.grad1, new: value["grad1"] as? String)
        identity.updateField(field: Identity.detailType.grad2, new: value["grad2"] as? String)
        identity.updateField(field: Identity.detailType.profileImage, new: value["profileImage"] as? String)
        
        
        identity.updateWebsites(value["Websites"] as? [String] ?? [String]())
        
        identity.setVerified(isVer: value["verified"] as? Bool ?? false)
        identity.setPubPriv(isPub: value["isPublic"] as? Bool ?? false)
        
        return identity
        
        
    }
    
    
//    static private func updateFirebasePushNotificationID(token:String){
//        if me.username == "CatchUsername" {return}
//       // if UserDefaults.standard.string(forKey: "FID") != token{
//            print("UPDATING BROOOO")
//            updateField(type: "FID", to: token, completion: {})
//           // UserDefaults.standard.set(token, forKey: "FID")
//        //}
//    }
    
    
    ///Stores Firebase Token
    static func updateFirestore(_ fid:String){
        var values = [String:String]()
        values["firstName"] = me.firstName
        values["lastName"] = me.lastName
        values["FID"] = fid

        Firestore.firestore().collection("user-data").document("names").setData([me.username :values], merge: true)
        
    }
    

    static func requestFirebaseFID(){
        print("NW FID")

        InstanceID.instanceID().instanceID { (result, error) in
          if let error = error {
            print("Error fetching remote instance ID: \(error)")
          } else if let result = result {
            print("Remote instance ID token: \(result.token)")
            let token = result.token
            updateFirestore(token)
          }
        }
    }
    
    
}

//MARK: - Users
extension DataGrab{
    
    /// Returns the Contacts of users from their usernames
    static func usernamesToNames(usernames:[String],completion:@escaping ([Contact ]) -> Void){
        Firestore.firestore().collection("user-data").document("names").getDocument { (snapshot, error) in
            guard let snapshot = snapshot?.data() else{
                return}
            
            var contacts = [Contact]()
            
            for i in usernames{
                print(i)
                if let value = snapshot[i] as? [String:String]{
                
                if let firstName = value["firstName"], let lastName = value["lastName"]{
                    contacts.append(Contact(firstname: firstName, lastname: lastName, username: i))
                }
                }
            }
            
            completion(contacts)
            
        }
    }
    
    
    /// Returns the Contacts of users from their usernames
    static func idsToName(usernames:[String],completion:@escaping ([Contact ]) -> Void){
        Firestore.firestore().collection("user-data").document("names").getDocument { (snapshot, error) in
            guard let snapshot = snapshot?.data() else{
                return}
            
            var contacts = [Contact]()
            
            for i in usernames{
                print(i)
                if let value = snapshot[i] as? [String:String]{
                
                if let firstName = value["firstName"], let lastName = value["lastName"]{
                    contacts.append(Contact(firstname: firstName, lastname: lastName, username: i))
                }
                }
            }
            
            completion(contacts)
            
        }
    }
    
    
    
    
    /// Returns true if the user exists and false if the user does not exist
    static func userExists(who: String, completion: @escaping (_ val: Bool) -> Void) {
        
        Firestore.firestore().collection("users").whereField("username", isEqualTo: who).limit(to:
            1).getDocuments { (snapshot, error) in
                print("EXISTS \(snapshot?.documents)")
                let taken = (snapshot?.documents.count ?? 0) != 0
                print(taken)
                completion(taken)
        }
    }
    
    static func getFriendCard(username:String,completion:@escaping(_ val:Identity) -> Void){
        print(username)
        
        
        Firestore.firestore().collection("users").whereField("username", isEqualTo: username).limit(to:
            1).getDocuments { (snapshot, error) in
                guard let value = snapshot?.documents.first?.data() else{return}
                
                
                
                completion(documentToIdentity(doc: value))
                
        }
        
        
    }
    
    
    
    /// Returns if the user is connected to the person being passed in as a parameter
    static func isConnectedTo(who: String, completion: @escaping (_ val: Bool) -> Void) {
        
        if(who == username){
            completion(true)
            return
        }
        
        guard let uid = Auth.auth().currentUser?.uid else{return}
        
        Firestore.firestore().collection("users").document(uid).collection("friends").document(who).getDocument { (snapshot, error) in
            guard let doc = snapshot?.data() else{
                completion(false)
                return
            }
            completion(doc["accepted"] as? Bool ?? false)
            
        }
        
        
    }
    
    
    
    
//    ///Gets the name of a user based on the username pased in
//    static func getNameFromUsername(who: String, completion: @escaping (_ val: Contact) -> Void) {
//        
//        getFriendCard(username: who) { (i) in
//            completion(Contact(firstname: i.firstName, lastname: i.lastName, username: i.username))
//        }
//    }
    
}


//MARK: - Friends
extension DataGrab{
    
    /// Function that returns a list of someones friends (This includes people that have not accepted friend request
    static func getFriends(completion: @escaping (_ val: [String]) -> Void) {
        var reqArray = [String]()

        guard let uid = Auth.auth().currentUser?.uid else{
            completion(reqArray)
            return}
        
        
        Firestore.firestore().collection("users").document(uid).collection("friends").whereField("accepted", isEqualTo: true).getDocuments { (snapshot, error) in
            // print(snapshot?.documents)
            guard let documents = snapshot?.documents else{
                completion(reqArray)
                return}
            
            for i in documents{
               
                reqArray.append(i.documentID)
                
            }
            completion(reqArray)
            
        }
        
    }
    
    
    ///Returns a string of usernames of people that are requesting to link with the user
    ///uses a completion handle so database functionality works in sync
    static func getRequests(completion: @escaping (_ val: [String]) -> Void) {
        
        guard let uid = Auth.auth().currentUser?.uid else{return}
        
        var reqArray = [String]()
        
        Firestore.firestore().collection("users").document(uid).collection("friends").whereField("accepted", isEqualTo: false).getDocuments { (snapshot, error) in
            guard let documents = snapshot?.documents else{
                completion(reqArray)
                return}
            for i in documents{
                reqArray.append(i.documentID)
                
            }
            
        }
        completion(reqArray)
        
    }
    
    
    static func deleteFriend(who:String, completion:@escaping (() -> Void)){
        
        
            guard let uid = Auth.auth().currentUser?.uid else{return}
        
        Firestore.firestore().collection("users").whereField("username", isEqualTo: who).getDocuments { (snapshot, error) in
            guard let userID = snapshot?.documents.first?.documentID else{return}
            
            Firestore.firestore().collection("users").document(uid).collection("friends").document(who).delete()
            
            Firestore.firestore().collection("users").document(userID).collection("friends").document(username).delete()
              completion()
        }
        
    }
    
    
    
    
    /// Allowes the person in the parameter to view the users card
    static func acceptFriend(who: String, completion: @escaping() -> Void) {
        
        
        guard let uid = Auth.auth().currentUser?.uid else{return}
        
        
        Firestore.firestore().collection("users").whereField("username", isEqualTo: who).getDocuments { (snapshot, error) in
            guard let userID = snapshot?.documents.first?.documentID else{return}
            
            Firestore.firestore().collection("users").document(uid).collection("friends").document(who).setData(["uid":userID,"accepted":true,"my-username":me.username,"Initiated":true], merge: true)
            
            Firestore.firestore().collection("users").document(userID).collection("friends").document(username).setData(["uid":uid,"accepted":true,"my-username":who,"Initiated":false], merge: true)
        }
        
        completion()
    }
    
    /// Adds you to someones friends list, if they are pulic then you can automatically See their card,
    /// if they are not public then you have to wait until the person accepts the card exchange
    static func exchangeCard(who: String, completion: @escaping() -> Void) {
        acceptFriend(who: who, completion: completion)
        
    }
    
    
    
    
    ///Decline a link request
    static func declineFriend(who: String, completion: @escaping() -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else{return}
        
        Firestore.firestore().collection("users").document(uid).collection("friends").document(who).delete()
        
        if(me.isPublic == false){
            Firestore.firestore().collection("users").whereField("username", isEqualTo: who).getDocuments { (snapshot, error) in
                guard let userID = snapshot?.documents.first?.documentID else{return}
                
                Firestore.firestore().collection("users").document(userID).collection("friends").document(username).delete()
            }
            
        }
        
        completion()
    }
    
    
    /// The removeFromWallet disconnects the link, if you remove someone from your wallet and you are private then that person can no longer see you, This function is functionally the same as declining a friend
    static func removeFromWallet(who: String, completion: @escaping() -> Void){
        declineFriend(who: who) {
            completion()
        }
    }
    
}



extension DataGrab{
    
    /// Function returns a bool wheter or not the person passed in is public, uses a completion handler
    static func isPersonPublic(who: String, completion: @escaping (_ val: Bool) -> Void) {
        Firestore.firestore().collection("users").document(who).getDocument { (snapshot, error) in
            completion((snapshot?.data()?["isPublic"] as? Bool) ?? true)
        }
        
    }
    
    
    /// Returns an array of contacts with all of the users in the databse
    static func userListContacts(completion: @escaping (_ val: [Contact]) -> Void) {
        
        Firestore.firestore().collection("users").whereField("isPublic", isEqualTo: true).getDocuments { (snapshot, error) in
            guard let documents = snapshot?.documents else{return}
            var contacts = [Contact]()
            
            for i in documents{
                let identity = documentToIdentity(doc: i.data())
                contacts.append(Contact(firstname: identity.firstName,lastname: identity.lastName, username: identity.username))
                
            }
            completion(contacts)
            
            
        }
        
    }
    
}





//MARK: - Firebase Auth
extension DataGrab{
    
    //MARK: - Sign in/out/up Manage Users
    
    /// Signs user in, returns true if authentication worked, false if it did not
    static func signIn(email: String, password: String, completion: @escaping(_ worked: Bool) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            
            if error != nil {
                print("error loggin in")
                completion(false)
                return
            }
            
            completion(true)
            
        }
    }
    
    
    static func resetPassword(email:String, callBack:@escaping (String?) -> Void){
        Auth.auth().sendPasswordReset(withEmail: email) { error  in
            if let error = error {
                
                let errorString =  self.FirebaseErrorToString(error: error)
                callBack(errorString)
                return
            }
            callBack(nil)
        }
        
    }
    
    
    static func FirebaseErrorToString(error:Error) -> String{
        if let error = AuthErrorCode(rawValue: error._code) {
            
            switch error {
            case AuthErrorCode.networkError:
                return "Please make sure you are connected to the internet"
            case AuthErrorCode.userNotFound:
                return "The email address does not belong to any account"
            case AuthErrorCode.emailAlreadyInUse:
                return "Email Is Already In Use, Please Try Another"
            default:
                
                return "An error occurred please try again later"
            }
        }
        return  "An error occurred please try again later"
        
    }
    
    
    /// Signs the user out of their information. Returns true if the user is successfully signed out
    static func signOut(completion: @escaping (_ val: Bool) -> Void) {
        do {
            try Auth.auth().signOut()
        } catch let error {
            print("Failed to sign out with error..", error)
            completion(false)
            return
        }
        completion(true)
    }
    
    
    
    ///Send Verification email
    static func sendVerificationEmail(completion: @escaping (_ val: Bool) -> Void) {
        Auth.auth().currentUser?.sendEmailVerification { (error) in
            print("Verifying email did not work")
            print(error?.localizedDescription ?? "Unknown Error")
        }
    }
    
    
    ///Update password
    static func updatePassword(password: String, completion: @escaping (_ val: Bool) -> Void) {
        Auth.auth().currentUser?.updatePassword(to: password) { (error) in
            if let error = error {
                print("Something went wrong with resetting the password, the error was \(error.localizedDescription)")
                completion(false)
            } else {
                print("You were able to reset the password")
                completion(true)
            }
        }
    }
    
}



//MARK: - Profile Image
extension DataGrab{
    
    //Uploads profile picture to Firebase Storage. Path to image username/profileImage.jpg
    static func uploadImage(image:UIImage, user:String, completion:@escaping(URL?, Error?) -> Void){
        
        let storage = Storage.storage()
        let imagesRef = storage.reference().child("\(user)/profileImage.jpg")
        
        guard let imageData = image.jpegData(compressionQuality: 0.15) else{
            return
        }
        
        imagesRef.putData(imageData, metadata: nil) { (meta, error) in
            if let error = error {
                return completion(nil,error)
            }
            
            imagesRef.downloadURL(completion: { (url, error) in
                if let error = error {
                    return completion(nil,error)
                }
                completion(url,nil)
            })
            
        }
        
        
    }
    
    
    static func getImageURL(username:String,completion:@escaping (String?) -> Void){
        Firestore.firestore().collection("users").whereField("username", isEqualTo: username).getDocuments(completion: { (snapshot, error) in
           
            var imageUrl = snapshot?.documents.first?.data()["profileImage"] as? String
            imageUrl = imageUrl == "" ? nil : imageUrl
            completion(imageUrl)
        })
        
    }
    
    
    
}

//MARK: -Partners
extension DataGrab{
    
    static func partnerExistsCheck(who: String, completion: @escaping (_ val: Bool) -> Void){
        
        if who.contains("/"){
            completion(false)
            return
        }
          
        Firestore.firestore().collection("Partners").document(who).getDocument { (snapshot, error) in
            completion(snapshot?.exists ?? false)
        }
        
     
          
          
      }
      
      
      static func getPartnerInfo(who: String, completion: @escaping (_ val:  [String: String]) -> Void){
       
        
        if who.contains("/"){
            completion([String:String]())
            return
        }
          
        
        Firestore.firestore().collection("Partners").document(who).getDocument { (snapshot, error) in
            guard let values = snapshot?.data() as? [String:String] else{return}
            completion(values)
               }
               
       
      }
    
    static func getPartnerInfo(withPartnerName partnerName:String, completion:@escaping ((Partner?) -> Void)){
        
        
        if partnerName.contains("/"){
            completion(nil)
            return
        }
          
        
        Firestore.firestore().collection("Partners").document(partnerName).getDocument { (snapshot, error) in
             guard let doc = snapshot?.data() else{
                           completion(nil)
                           return
                       }
            completion(DataGrab.documentToPartner(doc: doc, forUsername: partnerName))
            print(doc)
                      
        }
    }
    
    static func documentToPartner(doc value:[String:Any], forUsername username:String) -> Partner{
           
        Partner(username: username, name: value["name"] as? String, bio: value["bio"] as? String, work: value["work"] as? String, phone: value["phone"] as? String, email: value["email"] as? String, facebook: value["facebook"] as? String, instagram: value["instagram"] as? String, snapchat: value["snapchat"] as? String, website: value["website"] as? String, linkedin: value["linkedin"] as? String, website2: value["website2"] as? String, website3: value["website3"] as? String, github: value["github"] as? String, tiktok: value["tiktok"] as? String, applemusic: value["applemusic"] as? String, spotify: value["spotify"] as? String, youtube: value["youtube"] as? String, twitter: value["twitter"] as? String, venmo: value["venmo"] as? String, website4: value["website4"] as? String, soundcloud: value["soundcloud"] as? String, whatsapp: value["whatsapp"] as? String, grad1: value["grad1"] as? String, grad2: value["grad2"] as? String,  profileImage: value["photourl"] as? String, websites: value["Websites"] as? [String] ?? [String]())
           
       }
}

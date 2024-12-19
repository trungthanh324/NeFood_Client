//
//  SignUp.swift
//  FoodOderring_FinalProject
//
//  Created by Trung Thành  on 1/10/24.
//

import SwiftUI
import FirebaseAuth
import FirebaseDatabase
struct SignUp: View {
    @State var color = Color.black.opacity(0.7)
    @State var email = ""
    @State var pass = ""
    @State var repass = ""
    @State var visible = false
    @State var revisible = false
    @State var alert = false
    @State var error = ""
    @State var openHomeView = false
    var body: some View {
        NavigationView{
            ZStack(alignment: .center){
                Color.white
                    .ignoresSafeArea()
                    .onTapGesture {
                        hideKeyboard()
                    }
                GeometryReader{_ in
                    VStack{
                        Image("ImageLogin")
                        
                        Text("Create new account")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(Color.black)
                            .padding(.top, 35)
                        
                        
                        TextField("Email", text: self.$email)
                            .padding()
                            .background(RoundedRectangle(cornerRadius: 4).stroke(self.email != "" ? Color(Color.gray.opacity(0.5)) : self.color, lineWidth: 2))
                            .padding(.bottom,5)
                            .autocapitalization(.none)
                            .foregroundColor(.black)
    // Password , visible or not
                        HStack(spacing: 15){
                            VStack{
                                if self.visible{
                                    TextField("Password", text: self.$pass)
                                        .background(RoundedRectangle(cornerRadius: 4).stroke(self.pass != "" ? Color("Color") : self.color, lineWidth: 2))
                                        .foregroundColor(.black)
                                }else{
                                    SecureField("Password", text: self.$pass)
                                        .foregroundColor(.black)
                                }
                            }
                            
                            Button {
                                self.visible.toggle()
                            } label: {
                                Image(systemName: self.visible ? "eye.slash.fill" : "eye.fill")
                                    .foregroundColor(self.color)
                                
                            }
                            
                        }
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 4).stroke(self.pass != "" ? Color(Color.gray.opacity(0.5)) : self.color, lineWidth: 2))
                        .padding(.bottom,5)
                        
    // RePassword , visible or not
                        HStack(spacing: 15){
                            VStack{
                                if self.revisible{
                                    TextField("Comfirm Password", text: self.$repass)
                                        .background(RoundedRectangle(cornerRadius: 4).stroke(self.pass != "" ? Color("Color") : self.color, lineWidth: 2))
                                        .foregroundColor(.black)
                                }else{
                                    SecureField("Confirm Password", text: self.$repass)
                                        .foregroundColor(.black)
                                }
                            }
                            
                            Button {
                                self.revisible.toggle()
                            } label: {
                                Image(systemName: self.revisible ? "eye.slash.fill" : "eye.fill")
                                    .foregroundColor(self.color)
                            }
                            
                        }
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 4).stroke(self.repass != "" ? Color(Color.gray.opacity(0.5)) : self.color, lineWidth: 2))
    //Register btn
                        Button {
                            self.register()
                        } label: {
                            Text("Register")
                                .foregroundColor(.white)
                                .padding(.vertical)
                                .frame(width: UIScreen.screenWidth - 50)
                        }
                        .background(Color.red.opacity(0.8))
                        .cornerRadius(10)
                        .padding(.top, 20)
                    }
                    .padding(.horizontal,25)
                    
                    NavigationLink(destination : Home(), isActive: $openHomeView){
                        EmptyView()
                    }
                }// geometry
                if self.alert{
                    ErrView(alert: self.$alert, error: self.$error)
                }
            }//zstack
        }
    }//dong cua body
    
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
    func register(){
        if self.email != ""{
            if self.pass == self.repass{
                Auth.auth().createUser(withEmail: self.email, password: self.pass) { result, err in
                    if err != nil{
                        self.error = err!.localizedDescription
                        self.alert.toggle()
                        return
                    }else{
                        openHomeView = true
                        //add user -> realtimeDB
                        if let data = result{
                            let idUser = data.user.uid
                            let databaseReference = Database.database().reference()
                            let value = ["email" : self.email, "id" : idUser]
                            databaseReference.child("user").child(idUser).setValue(value)
                        }
                    }
                }
            }else{
                self.error = "Password mismatch"
                self.alert.toggle()
            }
        }else{
            self.error = "Please fill all the contents properly"
            self.alert.toggle()
        }
    }//dong func register
}



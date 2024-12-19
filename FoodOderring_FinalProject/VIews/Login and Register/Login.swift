//
//  Login.swift
//  FoodOderring_FinalProject
//
//  Created by Trung Thành  on 1/10/24.
//

import SwiftUI
import FirebaseAuth
struct Login: View {
    @State var color = Color.black.opacity(0.7)
    @State var email = ""
    @State var pass = ""
    @State var visible = false
    @State var isShowingScreenRegister = false
    @State var alert = false
    @State var error = ""
    @State var openHome = false
    
    
    var body: some View {
        //WelcomeShape()
        NavigationView{
            ZStack{
                Color.white
                    .ignoresSafeArea()
                    .onTapGesture {
                        hideKeyboard()
                    }
                ZStack(alignment: .topTrailing){
                    GeometryReader{_ in
    //Login image , email, password
                             VStack{
                                 Image("ImageLogin")
                                 
                                 Text("Log in to your account")
                                     .font(.title)
                                     .fontWeight(.bold)
                                     .foregroundColor(Color.black)
                                     .lineLimit(0)
                                     .padding(.top, 35)
                                     
                                 
                                 TextField("Email", text: self.$email)
                                     .padding()
                                     .foregroundColor(.black)
                                     .background(RoundedRectangle(cornerRadius: 4).stroke(self.email != "" ? Color(Color.gray.opacity(0.5)) : self.color, lineWidth: 2))
                                     .padding(.bottom,5)
                                     .autocorrectionDisabled()
                                     .autocapitalization(.none)
                                     
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
    //Forget Password
                                 HStack{
                                     Spacer()
                                     
                                     Button {
                                         self.reset()
                                     } label: {
                                         Text("Forget password")
                                             .fontWeight(.bold)
                                             .foregroundColor(.red.opacity(0.8))
                                     }

                                 }
                                 .padding(.top, 20)
    //Login btn
                                 Button {
                                     self.verify()
                                 } label: {
                                     Text("Log in")
                                         .foregroundColor(.white)
                                         .padding(.vertical)
                                         .frame(width: UIScreen.screenWidth - 50)
                                 }
                                 .background(Color.red.opacity(0.8))
                                 .cornerRadius(10)
                                 .padding(.top, 20)
                             }
                             .padding(.horizontal,25)
                        
                        NavigationLink(destination: Home(),isActive: $openHome)
                        {
                                EmptyView()
                        }
                          
                    }
    //register btn
                    Button {
                       isShowingScreenRegister = true
                    } label: {
                        Text("Register")
                            .fontWeight(.bold)
                            .foregroundColor(Color.red.opacity(0.8))
                    }
                    .padding()
                    NavigationLink(destination: SignUp(), isActive: $isShowingScreenRegister) {
                    EmptyView()
                    }
                }
                if self.alert{
                    ErrView(alert: self.$alert, error: self.$error)
                }
            }
        }
    }
    
// Hàm ẩn bàn phím
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
    func verify(){
        if self.email != "" && self.pass != ""{
            Auth.auth().signIn(withEmail: self.email, password: self.pass) { result, err in
                if err != nil{
                    self.error = err!.localizedDescription
                    self.alert.toggle()
                }else{
                    openHome = true
                }
            } 
        }else{
            self.error = "Please fill all the contents properly"
            self.alert.toggle()
        }
        
    }
    
    func reset(){
        if self.email != nil {
            Auth.auth().sendPasswordReset(withEmail: self.email){err in
                if err != nil{
                    self.error = err!.localizedDescription
                    self.alert.toggle()
                    return
                }
                
                self.error = "Reset"
                self.alert.toggle()
            }
        }else{
            self.error = "Input your email"
            self.alert.toggle()
        }
    }
}// dong cua struct login



#Preview {
    Login()
}

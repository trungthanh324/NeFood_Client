//
//  WelcomeView.swift
//  FoodOderring_FinalProject
//
//  Created by Trung Thành  on 30/9/24.
//

import SwiftUI

struct WelcomeView: View {
    let welcomeMessageSliders: [WelcomeMessageSlider] = [
        WelcomeMessageSlider(tittle: "Various delicious food", description: "New experience you ever taste"),
        WelcomeMessageSlider(tittle: "Get your food at doorstep", description: "Your order will be delivered fast as possible"),
        WelcomeMessageSlider(tittle: "Let's explore!!!", description: "")
    ]
    @State var showScreen = false
    
    var body: some View {
        //ham chuyen ve mau sac
        ZStack{
            WelcomeShape()
            TabView{
                //Co 3 man hinh nhu v nen phai duyet bang forEach
                ForEach(welcomeMessageSliders, id: \.self) { welcomeMessageSlider in
                    // de 1 thang nam duoi 1 thang nam tren
                    ZStack{
                        //Vertical Stack
                        VStack (alignment: .leading, spacing: 20) {
                            Text(welcomeMessageSlider.tittle)
                                .font(.system(size: 30))
                                .fontWeight(.semibold)
                                .foregroundColor(Color.white)
                                .multilineTextAlignment(.center)
                            Text(welcomeMessageSlider.description)
                                .font(.system(size: 15))
                                .foregroundColor(Color.white)
                            if welcomeMessageSliders.last == welcomeMessageSlider {
                                Button(action: {
                                    self.showScreen.toggle()
                                }, label:  {
                                    Text("Login or Register")
                                        .frame(minWidth: 0, maxWidth: UIScreen.screenWidth / 2)
                                        .font(.system(size: 18))
                                        .padding()
                                        .foregroundColor(.white)
                                        .overlay{
                                            RoundedRectangle(cornerRadius: 25)
                                                .stroke(Color.white, lineWidth: 2)// duong to vien
                                        }
                                        .background(Color(237,75,106))
                                        .cornerRadius(25)
                                })
                                .fullScreenCover(isPresented: $showScreen, content: {
                                    Login()
                                })
                                
                            }
                        }
                        .padding(20)
                        //bat su kien khi vuot
                        .onAppear{
                            print(welcomeMessageSlider.tittle)
                            
                        }
                    }
                }
                
            }.frame(width: UIScreen.screenWidth,
                    height: UIScreen.screenHeight,
                    alignment: .center)
            .tabViewStyle(PageTabViewStyle())
        }.ignoresSafeArea()
    }
}

#Preview {
    WelcomeView()
}

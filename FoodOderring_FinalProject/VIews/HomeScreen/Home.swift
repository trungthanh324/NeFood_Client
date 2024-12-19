//
//  Home.swift
//  FoodOderring_FinalProject
//
//  Created by Trung Thành  on 6/10/24.
//

import SwiftUI

struct Home: View {
    @State var color = Color.red.opacity(0.8)
    @State var open = false
    @StateObject var HomeModel = HomeViewModel()
    @State var alert = false
    @State var error = ""
    var body: some View {
                  ZStack{
                Color.white
                    .ignoresSafeArea()
                    .onTapGesture {
                        hideKeyboard()
                    }
                VStack(spacing: 15){
                    HStack(spacing: 15){
                        Button(action: {
                            withAnimation(.easeIn){
                                HomeModel.showMenu.toggle()
                            }
                        }, label: {
                            Image(systemName: "line.horizontal.3")
                                .font(.title)
                                .foregroundColor(color)
                        })
                        
                        Text(HomeModel.userLocation == nil ? "Locating.." : "Deliver to ")
                            .foregroundColor(.black)
                        Text(HomeModel.userAddress)
                            .foregroundColor(color)
                            .font(.caption)
                            .fontWeight(.heavy)
                        
                        Spacer(minLength: 0)
                    }//Hstack
                    .padding([.horizontal, .top])
                  
                    Divider()
//Search
                    HStack(spacing: 15){
                        TextField("Search", text: $HomeModel.search)
                            .foregroundColor(.black)
                        
                        Image(systemName: "magnifyingglass")
                            .font(.title2)
                            .foregroundColor(color)
                            .onTapGesture {
                                hideKeyboard()
                            }
                    }
                    .padding(.horizontal)
                    .padding(.top, 5)
                    
                    Divider()
//ItemData -> CrollView
                    ScrollView(.vertical, showsIndicators: false) {
                        VStack(spacing: 25){
                            ForEach(HomeModel.filtered){item in
//Item View
                                ZStack(alignment: Alignment(horizontal: .center, vertical: .top)){
                                    ItemView(item: item)
                                    
                                    HStack{
                                        Text("Discount shipping")
                                        //.font(.title2)
                                            .foregroundColor(.white)
                                            .fontWeight(.bold)
                                            .padding(.vertical, 5)
                                            .padding(.horizontal)
                                            .background(Color.red.opacity(0.8))
                                        
                                        Spacer(minLength: 0 )
                                        
                                        Button(action: {
                                            HomeModel.addToCart(item: item)
                                        }, label: {
                                            Image(systemName: item.isAdded ? "checkmark" : "plus")
                                                .font(.title2)
                                                .foregroundColor(.white)
                                                .padding(10)
                                                .background(item.isAdded ? Color.green.opacity(0.8) : Color.red.opacity(0.8))
                                                .clipShape(Circle())
                                        })
                                    }
                                    .padding(.trailing ,10)
                                    .padding(.top ,10)
                                }
                                .frame(width: UIScreen.screenWidth - 20)
                            }//foreach
                        }
                        .padding(.top, 10)
                    }
                }//Vstack
                
//Side menu
                HStack{
                    Menu(homeData: HomeModel)
                        .offset(x: HomeModel.showMenu ? 0 : -UIScreen.screenWidth / 1.6)
                    
                    Spacer(minLength: 0)
                }
                .background(Color.black.opacity(HomeModel.showMenu ? 0.3 : 0).ignoresSafeArea()
                            //closing when tap outside
                    .onTapGesture(perform: {
                        withAnimation(.easeIn) {
                            HomeModel.showMenu.toggle()
                        }
                    })
                )
                
//User denied using location
                if HomeModel.noLocation{
                    Text("Please Enable Location in Settings!!!")
                        .foregroundColor(.black)
                        .padding()
                    //.frame(width: UIScreen.screenWidth - 100, height: 100)
                        .background(.white)
                        .cornerRadius(10)
                        .frame(maxWidth: .infinity, minHeight: .infinity)
                        .background(Color.black.opacity(0.3).ignoresSafeArea())
                        .position(x: UIScreen.screenWidth / 2, y: UIScreen.screenHeight / 2)
                    
                }
                
                if self.alert{
                    ErrView(alert: self.$alert, error: self.$error)
                }
            }
                    .navigationBarBackButtonHidden(true)
            .onAppear(perform: {
//call location delegate
                HomeModel.locationManager.delegate = HomeModel
            })
            .onChange(of: HomeModel.search, perform: { value in
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3){
                    if value == HomeModel.search && HomeModel.search != "" {
                        HomeModel.filterData()
                    }
                }
// reset lai data
                if HomeModel.search == ""{
                    withAnimation(.linear){HomeModel.filtered = HomeModel.items}
                }
            })
    }
    
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

#Preview {
    Home()
}

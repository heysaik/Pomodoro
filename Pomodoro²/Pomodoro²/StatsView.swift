//
//  StatsView.swift
//  Pomodoro²
//
//  Created by Sai Kambampati on 12/23/19.
//  Copyright © 2019 Sai Kambampati. All rights reserved.
//

import SwiftUI

struct StatsView: View {
    @State var workScale: CGFloat = 1
    @State var breakScale: CGFloat = 0.9
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        GeometryReader() { geometry in
            HStack {
                Spacer()
                VStack {
                    HStack {
                        Button(action: {
                            self.presentationMode.wrappedValue.dismiss()
                        }) {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(Color("close"))
                                .font(Font.system(.title, design: .rounded))
                        }
                        .padding([.top, .leading])
                        Spacer()
                    }
                    .padding(.top)

                    Image(systemName: "chart.bar.fill")
                        .font(Font.system(.largeTitle, design: .rounded))
                        .padding(.top)
                        .foregroundColor(Color("accent"))
                    Text("Stats")
                        .font(.system(.largeTitle, design: .rounded))
                        .fontWeight(.heavy)
                        .foregroundColor(Color("accent"))
                        .multilineTextAlignment(.center)
                    VStack(spacing: 10) {
                        Spacer()
                        HStack {
                            ZStack() {
                                Circle()
                                    .foregroundColor(Color("accent"))
                                VStack {
                                    Image(systemName: "square.and.pencil")
                                        .foregroundColor(.white)
                                        .font(Font.system(.title, design: .rounded))

                                    Text("Work Sessions")
                                        .foregroundColor(.white)
                                        .font(Font.system(.headline, design: .rounded).lowercaseSmallCaps())
                                    .padding(.bottom)

                                    Text("\(UserDefaults.standard.integer(forKey: "com.p2.works"))")
                                        .foregroundColor(.white)
                                        .font(Font.system(.largeTitle, design: .rounded))
                                }
                                
                            }
                            .frame(width: geometry.size.width / 2)
                            Spacer()
                        }
                        .scaleEffect(self.workScale)
                        .onAppear {
                            UserDefaults.standard.synchronize()
                            let baseAnimation = Animation.easeInOut(duration: 1.5)
                            let repeated = baseAnimation.repeatForever(autoreverses: true)
                            
                            return withAnimation(repeated) {
                                self.workScale = 0.9
                            }
                        }
                        HStack {
                            Spacer()
                            ZStack {
                                Circle()
                                    .foregroundColor(Color("accent"))
                                VStack {
                                    Image(systemName: "gamecontroller.fill")
                                        .foregroundColor(.white)
                                        .font(Font.system(.title, design: .rounded))
                                    Text("Breaks")
                                        .foregroundColor(.white)
                                        .font(Font.system(.headline, design: .rounded).lowercaseSmallCaps())
                                    .padding(.bottom)

                                    Text("\(UserDefaults.standard.integer(forKey: "com.p2.breaks"))")
                                        .foregroundColor(.white)
                                        .font(Font.system(.largeTitle, design: .rounded))
                                }
                                
                            }
                            .frame(width: geometry.size.width / 2)
                        }
                        .scaleEffect(self.breakScale)
                        .onAppear {
                            UserDefaults.standard.synchronize()
                            let baseAnimation = Animation.easeInOut(duration: 1.5)
                            let repeated = baseAnimation.repeatForever(autoreverses: true)
                            
                            return withAnimation(repeated) {
                                self.breakScale = 1
                            }
                        }
                        Spacer()
                    }
                    .padding(.horizontal)
                    
                }
                Spacer()
            }
        }
        .background(Color("background").edgesIgnoringSafeArea(.all))
        
    }
}

struct StatsView_Previews: PreviewProvider {
    static var previews: some View {
        StatsView()
    }
}

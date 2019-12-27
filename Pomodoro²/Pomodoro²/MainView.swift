//
//  MainView.swift
//  Pomodoro²
//
//  Created by Sai Kambampati on 12/23/19.
//  Copyright © 2019 Sai Kambampati. All rights reserved.
//

import SwiftUI

struct MainView: View {
    @State var timerView = false
    @State var showingStats = false
    @State var showingHelp = false
    
    var body: some View {
        NavigationView {
            VStack {
                // Hidden Surprise 😉
                Image("clock")
                    .contextMenu {
                        Button(action: {
                            if UIApplication.shared.supportsAlternateIcons {
                                if UIApplication.shared.alternateIconName == nil {
                                    UIApplication.shared.setAlternateIconName("LightIcon")
                                } else {
                                    UIApplication.shared.setAlternateIconName(nil)
                                }
                                
                            }
                        }) {
                            HStack {
                                Text("Change App Icon 😉")
                                Image(systemName: "app")
                            }
                        }
                }
                .padding(.top)
                
                
                Text("Pomodoro²")
                    .font(.system(.largeTitle, design: .rounded))
                    .fontWeight(.heavy)
                    .foregroundColor(Color("accent"))
                    .multilineTextAlignment(.center)
                Text("A simple and effective way to help you stay focused")
                    .font(.system(.headline, design: .rounded))
                    .fontWeight(.bold)
                    .foregroundColor(Color("blue"))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
                    .padding(.bottom)
                VStack(spacing: 20) {
                    NavigationLink(destination: ClockView(showView: self.$timerView), isActive: self.$timerView) {
                        ZStack {
                            Capsule()
                                .foregroundColor(Color("accent"))
                                .frame(height: 50)
                            HStack {
                                Image(systemName: "hourglass.bottomhalf.fill")
                                    .accentColor(.white)
                                Text("START")
                                    .foregroundColor(.white)
                                    .font(.system(.headline, design: .rounded))
                                    .fontWeight(.bold)
                            }
                        }
                        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 10)
                    }
                    
                    Button(action: {
                        self.showingStats.toggle()
                    }) {
                        ZStack {
                            Capsule()
                                .foregroundColor(Color("accent"))
                                .frame(height: 50)
                            HStack {
                                Image(systemName: "chart.bar.fill")
                                    .accentColor(.white)
                                Text("STATS")
                                    .foregroundColor(.white)
                                    .font(.system(.headline, design: .rounded))
                                    .fontWeight(.bold)
                            }
                        }
                        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 10)
                    }
                    .sheet(isPresented: $showingStats) {
                        StatsView()
                    }
                    
                    Button(action: {
                        self.showingHelp.toggle()
                    }) {
                        ZStack {
                            Capsule()
                                .foregroundColor(Color("accent"))
                                .frame(height: 50)
                            HStack {
                                Image(systemName: "questionmark.circle.fill")
                                    .accentColor(.white)
                                Text("HELP")
                                    .foregroundColor(.white)
                                    .font(.system(.headline, design: .rounded))
                                    .fontWeight(.bold)
                            }
                        }
                        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 10)
                        
                    }
                    .sheet(isPresented: $showingHelp) {
                        HelpView()
                    }
                }
                .padding(.all)
                Spacer()
            }
            .background(Color("background").edgesIgnoringSafeArea(.all)
            )
                .navigationBarTitle("")
                .navigationBarHidden(true)
        }
        .onAppear {
            UIApplication.shared.isIdleTimerDisabled = false
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            MainView()
            MainView().environment(\.colorScheme, .dark).previewDevice(PreviewDevice.init(rawValue: "iPhone SE"))
        }
    }
}

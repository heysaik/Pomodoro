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
    let selection = UISelectionFeedbackGenerator()
    
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
                                Text("easterEggTitle")
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
                Text("pomodoroSubtitle")
                    .font(.system(.headline, design: .rounded))
                    .fontWeight(.bold)
                    .foregroundColor(Color("blue"))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
                    .padding(.bottom)
                VStack(spacing: 20) {
                    NavigationLink(destination: ClockView(showView: self.$timerView), isActive: self.$timerView) { EmptyView() }
                    Button(action: {
                        self.selection.selectionChanged()
                        self.timerView = true
                    }) {
                        ZStack {
                            Capsule()
                                .foregroundColor(Color("accent"))
                                .frame(height: 50)
                            HStack {
                                Image(systemName: "hourglass.bottomhalf.fill")
                                    .accentColor(.white)
                                Text("Start")
                                    .foregroundColor(.white)
                                    .font(Font.system(.headline, design: .rounded).lowercaseSmallCaps())
                                    .fontWeight(.bold)
                            }
                        }
                        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 10)
                    }
                    
                    Button(action: {
                        self.selection.selectionChanged()
                        self.showingStats.toggle()
                    }) {
                        ZStack {
                            Capsule()
                                .foregroundColor(Color("accent"))
                                .frame(height: 50)
                            HStack {
                                Image(systemName: "chart.bar.fill")
                                    .accentColor(.white)
                                Text("Stats")
                                    .foregroundColor(.white)
                                    .font(Font.system(.headline, design: .rounded).lowercaseSmallCaps())
                                    .fontWeight(.bold)
                            }
                        }
                        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 10)
                    }
                    .sheet(isPresented: $showingStats) {
                        StatsView()
                    }
                    
                    Button(action: {
                        self.selection.selectionChanged()
                        self.showingHelp.toggle()
                    }) {
                        ZStack {
                            Capsule()
                                .foregroundColor(Color("accent"))
                                .frame(height: 50)
                            HStack {
                                Image(systemName: "questionmark.circle.fill")
                                    .accentColor(.white)
                                Text("Help")
                                    .foregroundColor(.white)
                                    .font(Font.system(.headline, design: .rounded).lowercaseSmallCaps())
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
                .environment(\.locale, Locale(identifier: "te"))
        }
    }
}

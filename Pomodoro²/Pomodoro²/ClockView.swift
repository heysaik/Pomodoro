//
//  ClockView.swift
//  Pomodoro²
//
//  Created by Sai Kambampati on 12/21/19.
//  Copyright © 2019 Sai Kambampati. All rights reserved.
//

import SwiftUI
import AVFoundation

struct ClockView: View {
    @State var secondsRemaining = 1500
    @State private var angle: Double = 0
    @State private var countdownTimer = RepeatingTimer(timeInterval: 1.0)
    @State var isWorking = false
    @State var wantsToLeave = false
    @State var buttonStart = true
    @Binding var showView: Bool
    
    @State var workSessions = 0
    @State var breakSessions = 0
    
    let impact = UIImpactFeedbackGenerator()
    
    var body: some View {
        GeometryReader { geometry in
            HStack {
                Spacer()
                VStack {
                    Text(self.isWorking ? (self.breakTime().title) : NSLocalizedString("25 Minute Pomodoro", comment: "25 Minute Pomodoro"))
                        .font(Font.system(size: 30, weight: .bold, design: .rounded))
                        .kerning(-0.11)
                        .foregroundColor(Color("accent"))
                        .multilineTextAlignment(.center)
                        .padding(.top)
                    
                    Spacer()
                    ZStack {
                        Circle()
                            .fill(Color("clock-outer"))
                            .frame(width: geometry.size.width / DeviceConstraints().outerCircle(), height: geometry.size.width / DeviceConstraints().outerCircle())
                            .shadow(color: Color.primary.opacity(0.2), radius: 30, x: 0, y: 0)
                            .padding(.horizontal)
                        Ticks()
                            .frame(width: geometry.size.width / DeviceConstraints().ticks(), height: geometry.size.width / DeviceConstraints().ticks())
                        
                        ZStack(alignment: .top) {
                            Circle()
                                .fill(Color("clock-inner"))
                                .frame(width: geometry.size.width / DeviceConstraints().innerCircle(), height: geometry.size.width / DeviceConstraints().innerCircle())
                                .shadow(color: Color.black.opacity(0.35), radius: 10, x: 4, y: 0)
                                .padding(.horizontal)
                            Ticker()
                                .rotationEffect(.degrees(self.angle), anchor: UnitPoint.init(x: 0, y: 1))
                                .animation(.easeInOut)
                                .frame(height: (geometry.size.width / DeviceConstraints().innerCircle())/2)
                        }
                    }
                    Text("\(secondsToMinutesSeconds(seconds: self.secondsRemaining))")
                        .font(Font.system(size: 47, weight: .bold, design: .rounded))
                        .kerning(-0.17)
                        .foregroundColor(Color.primary)
                        .multilineTextAlignment(.center)
                    Spacer()
                    
                    VStack(spacing: 20) {
                        Button(action: {
                            self.impact.impactOccurred(intensity: 1.0)
                            if self.buttonStart {
                                self.buttonStart.toggle()
                                self.countdownTimer.eventHandler = {
                                    self.angle += (360 / (self.isWorking ? (self.breakTime().seconds) : 1500))
                                    self.secondsRemaining -= 1
                                    
                                    if self.secondsRemaining == 0 {
                                        AudioServicesPlayAlertSound(SystemSoundID(1005))
                                        self.isWorking.toggle()
                                        if self.isWorking == false {
                                            self.angle = 0
                                            self.breakSessions += 1
                                            self.secondsRemaining = 1500
                                        } else {
                                            self.angle = 0
                                            self.workSessions += 1
                                            self.secondsRemaining = Int(self.breakTime().seconds)
                                        }
                                    }
                                }
                                self.countdownTimer.resume()
                            } else {
                                if self.buttonText() == NSLocalizedString("End Break", comment: "End Break") {
                                    self.secondsRemaining = 1
                                } else {
//                                    self.wantsToLeave.toggle()
                                    UserDefaults.standard.synchronize()
                                    var breakStats = UserDefaults.standard.integer(forKey: "com.p2.breaks")
                                    breakStats += self.breakSessions
                                    UserDefaults.standard.set(breakStats, forKey: "com.p2.breaks")
                                    
                                    var workStats = UserDefaults.standard.integer(forKey: "com.p2.works")
                                    workStats += self.workSessions
                                    UserDefaults.standard.set(workStats, forKey: "com.p2.works")
                                    UserDefaults.standard.synchronize()
                                    self.countdownTimer.suspend()
                                    self.showView = false
                                }
                            }
                        }) {
                            ZStack {
                                Capsule()
                                    .fill(Color("accent"))
                                Text(self.buttonText())
                                    .font(Font.system(.headline, design: .rounded).lowercaseSmallCaps())
                                    .fontWeight(.bold)
                                    .foregroundColor(Color.white)
                            }
                        }
                        .frame(height: 50)
                        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 10)
                    }
                    .padding(.horizontal, geometry.size.width / 10)
                    Spacer()
                }
                
                Spacer()
            }
            .background(Color("background").edgesIgnoringSafeArea(.all))
        }
        .onAppear {
            UIApplication.shared.isIdleTimerDisabled = true
        }
//        .alert(isPresented: self.$wantsToLeave) {
//            Alert(title: Text("Are you sure?"), message: Text("This action will end all progress you have made"), primaryButton: .destructive(Text("End Session"), action: {
//                UserDefaults.standard.synchronize()
//                var breakStats = UserDefaults.standard.integer(forKey: "com.p2.breaks")
//                breakStats += self.breakSessions
//                UserDefaults.standard.set(breakStats, forKey: "com.p2.breaks")
//
//                var workStats = UserDefaults.standard.integer(forKey: "com.p2.works")
//                workStats += self.workSessions
//                UserDefaults.standard.set(workStats, forKey: "com.p2.works")
//                UserDefaults.standard.synchronize()
//                self.countdownTimer.suspend()
//                self.showView = false
//            }), secondaryButton: .cancel(Text("Cancel")))
//        }
        
    }
    
    // Helper Functions
    func buttonText() -> String {
        // Differentiate between Work and Break
        if !isWorking {
            return (self.buttonStart ? NSLocalizedString("Start 25 min work session", comment: "Start 25 min work session") : NSLocalizedString("End Work Session", comment: "End Work Session"))
        } else {
            return (self.buttonStart ? "\(NSLocalizedString("Start", comment: "Start")) \(breakTime().title)" : NSLocalizedString("End Break", comment: "End Break"))
        }
    }
    
    func breakTime() -> (title: String, seconds: Double) {
        // Differentiate between the 5 minute break or the 30 minute break
        if workSessions % 4 == 0 {
            return (title: NSLocalizedString("30 Minute Break", comment: "30 Minute Break"), seconds: 1800)
        } else {
            return (title: NSLocalizedString("5 Minute Break", comment: "5 Minute Break"), seconds: 300)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ClockView(showView: .constant(false))
            .environment(\.locale, Locale(identifier: "es"))
            ClockView(showView: .constant(false)).environment(\.colorScheme, .dark).previewDevice(PreviewDevice(rawValue: "iPhone SE"))
                .environment(\.locale, Locale(identifier: "es"))
        }
    }
}

// Seconds Formatting Function
func secondsToMinutesSeconds(seconds : Int) -> String {
    return "\(String(format: "%02d", ((seconds % 3600) / 60))):\(String(format: "%02d", ((seconds % 3600) % 60)))"
}

class RepeatingTimer {

    let timeInterval: TimeInterval
    
    init(timeInterval: TimeInterval) {
        self.timeInterval = timeInterval
    }
    
    private lazy var timer: DispatchSourceTimer = {
        let t = DispatchSource.makeTimerSource()
        t.schedule(deadline: .now() + self.timeInterval, repeating: self.timeInterval)
        t.setEventHandler(handler: { [weak self] in
            self?.eventHandler?()
        })
        return t
    }()

    var eventHandler: (() -> Void)?

    private enum State {
        case suspended
        case resumed
    }

    private var state: State = .suspended

    deinit {
        timer.setEventHandler {}
        timer.cancel()
        /*
         If the timer is suspended, calling cancel without resuming
         triggers a crash. This is documented here https://forums.developer.apple.com/thread/15902
         */
        resume()
        eventHandler = nil
    }

    func resume() {
        if state == .resumed {
            return
        }
        state = .resumed
        timer.resume()
    }

    func suspend() {
        if state == .suspended {
            return
        }
        state = .suspended
        timer.suspend()
    }
}

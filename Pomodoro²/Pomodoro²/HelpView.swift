//
//  HelpView.swift
//  Pomodoro²
//
//  Created by Sai Kambampati on 12/24/19.
//  Copyright © 2019 Sai Kambampati. All rights reserved.
//

import SwiftUI
import SafariServices
import MessageUI

struct HelpView: View {
    
    @State var showPomodoro = false
    @State var pomoURL = "https://en.wikipedia.org/wiki/Pomodoro_Technique"
    @State var showDev = false
    @State var devURL = "https://skyhighlabs.app"
    @State var result: Result<MFMailComposeResult, Error>? = nil
    @State var isShowingShareView = false
    @State var resetStats = false
    @Environment(\.presentationMode) var presentationMode
    let selection = UISelectionFeedbackGenerator()
    
    var body: some View {
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
                Image(systemName: "questionmark.circle.fill")
                    .font(Font.system(.largeTitle, design: .rounded))
                    .padding(.top)
                    .foregroundColor(Color("accent"))
                Text("Help")
                    .font(.system(.largeTitle, design: .rounded))
                    .fontWeight(.heavy)
                    .foregroundColor(Color("accent"))
                    .multilineTextAlignment(.center)
                
                VStack(spacing: 20) {
                    HStack(alignment: .bottom, spacing: 20) {
                        
                        Button(action: {
                            // About Pomodoro
                            self.selection.selectionChanged()
                            self.showPomodoro = true
                        }) {
                            ZStack {
                                RoundedRectangle(cornerRadius: 10, style: .circular)
                                    .foregroundColor(Color("accent"))
                                VStack {
                                    Image(systemName: "timer")
                                        .foregroundColor(.white)
                                        .font(Font.system(.largeTitle, design: .rounded))
                                        .padding(.bottom)
                                    Text("About the Pomodoro Timer")
                                        .foregroundColor(.white)
                                        .font(Font.system(.headline, design: .rounded))
                                        .multilineTextAlignment(.center)
                                        .padding(.horizontal)
                                }
                            }
                            
                        }
                        .sheet(isPresented: $showPomodoro) {
                            SafariView(url: URL(string: self.pomoURL)!)
                        }
                        
                        Button(action: {
                            // About the Developer
                            self.selection.selectionChanged()
                            self.showDev = true
                        }) {
                            ZStack {
                            RoundedRectangle(cornerRadius: 10, style: .circular)
                                .foregroundColor(Color("accent"))
                                VStack {
                                    Image(systemName: "person.circle.fill")
                                        .foregroundColor(.white)
                                        .font(Font.system(.largeTitle, design: .rounded))
                                        .padding(.bottom)
                                    Text("About the Developer")
                                        .foregroundColor(.white)
                                        .font(Font.system(.headline, design: .rounded))
                                        .multilineTextAlignment(.center)
                                        .padding(.horizontal)
                                }
                            }
                        }
                        .sheet(isPresented: $showDev) {
                            SafariView(url: URL(string: self.devURL)!)
                        }
                        
                    }
                    
                    HStack(alignment: .bottom, spacing: 20) {
                        Button(action: {
                            self.selection.selectionChanged()
                            if MFMailComposeViewController.canSendMail() {
                                UIApplication.shared.open(URL(string: "mailto:sai@skyhighlabs.app")!)
                            } else if UIApplication.shared.canOpenURL(URL(string: "readdle-spark://compose?recipient=sai@skyhighlabs.app")!) {
                                UIApplication.shared.open(URL(string: "readdle-spark://compose?recipient=sai@skyhighlabs.app")!)
                            } else if UIApplication.shared.canOpenURL(URL(string: "airmail://compose?to=sai@skyhighlabs.app")!) {
                                UIApplication.shared.open(URL(string: "airmail://compose?to=sai@skyhighlabs.app")!)
                            } else {
                                self.isShowingShareView.toggle()
                            }
                        }) {
                            ZStack {
                            RoundedRectangle(cornerRadius: 10, style: .circular)
                                VStack {
                                    Image(systemName: "envelope.circle.fill")
                                        .foregroundColor(.white)
                                        .font(Font.system(.largeTitle, design: .rounded))
                                        .padding(.bottom)
                                    Text("Email Support")
                                        .foregroundColor(.white)
                                        .font(Font.system(.headline, design: .rounded))
                                        .multilineTextAlignment(.center)
                                        .padding(.horizontal)
                                }
                            }
                        }
                        .sheet(isPresented: $isShowingShareView) {
                            ShareSheet()
                        }
                        
                        Button(action: {
                            // Reset Stats
                            self.selection.selectionChanged()
                            self.resetStats.toggle()
                        }) {
                            ZStack {
                            RoundedRectangle(cornerRadius: 10, style: .circular)
                                VStack {
                                    Image(systemName: "0.circle.fill")
                                        .foregroundColor(.white)
                                        .font(Font.system(.largeTitle, design: .rounded))
                                        .padding(.bottom)
                                    Text("Reset All Stats")
                                        .foregroundColor(.white)
                                        .font(Font.system(.headline, design: .rounded))
                                        .multilineTextAlignment(.center)
                                        .padding(.horizontal)
                                }
                            }
                        }
                        .alert(isPresented: self.$resetStats) { () -> Alert in
                            Alert(title: Text("Are you sure?"), message: Text("\(NSLocalizedString("This will reset all the stats on Pomodoro² on", comment: "This will reset all the stats on Pomodoro² on")) \(UIDevice.current.name)"), primaryButton: .destructive(Text("Reset"), action: {
                                UserDefaults.standard.synchronize()
                                UserDefaults.standard.set(0, forKey: "com.p2.breaks")
                                UserDefaults.standard.set(0, forKey: "com.p2.works")
                                UserDefaults.standard.synchronize()
                            }), secondaryButton: .cancel())
                        }
                        
                    }
                }
                .padding(.bottom)
                
            }
            Spacer()
        }
        .background(Color("background").edgesIgnoringSafeArea(.all))
    }
}

struct AboutView_Previews: PreviewProvider {
    static var previews: some View {
        HelpView()
            .environment(\.locale, Locale(identifier: "es"))
    }
}

struct SafariView: UIViewControllerRepresentable {

    let url: URL

    func makeUIViewController(context: UIViewControllerRepresentableContext<SafariView>) -> SFSafariViewController {
        return SFSafariViewController(url: url)
    }

    func updateUIViewController(_ uiViewController: SFSafariViewController, context: UIViewControllerRepresentableContext<SafariView>) {

    }

}

struct ShareSheet: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> UIActivityViewController {
        let controller = UIActivityViewController(
            activityItems: ["sai@skyhighlabs.app"], applicationActivities: nil)
        return controller
    }
      
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {
        // nothing to do here
    }
}

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
    @State var devURL = "https://saikambampati.com"
    @State var result: Result<MFMailComposeResult, Error>? = nil
    @State var isShowingMailView = false
    @State var resetStats = false
    let selection = UISelectionFeedbackGenerator()
    
    var body: some View {
        HStack {
            Spacer()
            VStack {
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
                            self.isShowingMailView.toggle()
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
                        .disabled(!MFMailComposeViewController.canSendMail())
                        .sheet(isPresented: $isShowingMailView) {
                            MailView(result: self.$result)
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
                                    Text("Reset all Stats")
                                        .foregroundColor(.white)
                                        .font(Font.system(.headline, design: .rounded))
                                        .multilineTextAlignment(.center)
                                        .padding(.horizontal)
                                }
                            }
                        }
                        .alert(isPresented: self.$resetStats) { () -> Alert in
                            Alert(title: Text("Are you sure?"), message: Text("This will reset all the stats on Pomodoro² on \(UIDevice.current.name)"), primaryButton: .destructive(Text("Reset"), action: {
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

struct MailView: UIViewControllerRepresentable {

    @Environment(\.presentationMode) var presentation
    @Binding var result: Result<MFMailComposeResult, Error>?

    class Coordinator: NSObject, MFMailComposeViewControllerDelegate {

        @Binding var presentation: PresentationMode
        @Binding var result: Result<MFMailComposeResult, Error>?

        init(presentation: Binding<PresentationMode>,
             result: Binding<Result<MFMailComposeResult, Error>?>) {
            _presentation = presentation
            _result = result
        }

        func mailComposeController(_ controller: MFMailComposeViewController,
                                   didFinishWith result: MFMailComposeResult,
                                   error: Error?) {
            defer {
                $presentation.wrappedValue.dismiss()
            }
            guard error == nil else {
                self.result = .failure(error!)
                return
            }
            self.result = .success(result)
        }
    }

    func makeCoordinator() -> Coordinator {
        return Coordinator(presentation: presentation,
                           result: $result)
    }

    func makeUIViewController(context: UIViewControllerRepresentableContext<MailView>) -> MFMailComposeViewController {
        let vc = MFMailComposeViewController()
        vc.mailComposeDelegate = context.coordinator
        return vc
    }

    func updateUIViewController(_ uiViewController: MFMailComposeViewController,
                                context: UIViewControllerRepresentableContext<MailView>) {

    }
}

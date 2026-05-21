//
//  Drops
//
//  Copyright (c) 2021-Present Omar Albeik - https://github.com/omaralbeik
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.

import SwiftUI
import Drops

struct ContentView: View {
    @State var title: String = "Hello There!"
    @State var subtitle: String = "Use Drops to show alerts"
    @State var positionIndex: Int = 0
    @State var duration: TimeInterval = 2.0
    @State var hasIcon: Bool = false
    @State var hasActionIcon: Bool = false
    @State var glassEffect: Bool = true
    
    @State var customTitleColor: Bool = false
    @State var titleColor: Color = .primary
    @State var customSubtitleColor: Bool = false
    @State var subtitleColor: Color = .secondary
    @State var customIconColor: Bool = false
    @State var iconColor: Color = .accentColor
    
    var body: some View {
        ZStack {
            #if os(iOS) || os(visionOS)
            Color(.secondarySystemBackground).ignoresSafeArea(.all)
            #endif
            VStack(alignment: .center, spacing: 20) {
                #if os(iOS) || os(macOS) || os(visionOS)
                VStack {
                    HStack {
                        Text("Title").font(.caption)
                        Spacer()
                    }
                    
                    TextField("Title", text: $title)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }
                
                VStack {
                    HStack {
                        Text("Optional Subtitle").font(.caption)
                        Spacer()
                    }
                    TextField("Subtitle", text: $subtitle)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }
                #endif
                
                VStack {
                    HStack {
                        Text("Position").font(.caption)
                        Spacer()
                    }
                    Picker(selection: $positionIndex, label: Text("Position")) {
                        Text("Top").tag(0)
                        Text("Bottom").tag(1)
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
                
                #if os(iOS) || os(macOS) || os(visionOS)
                VStack {
                    HStack {
                        Text("Duration (\(String(format: "%.1f", duration)) s)").font(.caption)
                        Spacer()
                    }
                    
                    Slider(value: $duration, in: 0.1...10)
                }
                #endif
                
                Toggle("Icon", isOn: $hasIcon)
                Toggle("Button", isOn: $hasActionIcon)
                
                if #available(iOS 26.0, *) {
                    Toggle("Glass", isOn: $glassEffect)
                }
                
                #if os(iOS) || os(macOS) || os(visionOS)
                HStack {
                    Toggle("Title Color", isOn: $customTitleColor)
                    ColorPicker("", selection: $titleColor, supportsOpacity: false)
                        .labelsHidden()
                        .disabled(!customTitleColor)
                        .opacity(customTitleColor ? 1 : 0.4)
                }
                
                HStack {
                    Toggle("Subtitle Color", isOn: $customSubtitleColor)
                    ColorPicker("", selection: $subtitleColor, supportsOpacity: false)
                        .labelsHidden()
                        .disabled(!customSubtitleColor)
                        .opacity(customSubtitleColor ? 1 : 0.4)
                }
                
                HStack {
                    Toggle("Icon Color", isOn: $customIconColor)
                    ColorPicker("", selection: $iconColor, supportsOpacity: false)
                        .labelsHidden()
                        .disabled(!customIconColor)
                        .opacity(customIconColor ? 1 : 0.4)
                }
                #endif
                
                Spacer()
                
                Button(action: {
                    showDrop()
                }, label: {
                    Text("Show Drop")
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(10)
                })
                .frame(maxWidth: .infinity)
                .background(Color.blue)
                .cornerRadius(7.5)
            }
            .padding()
            .padding(.top, 80)
        }
        .ignoresSafeArea(.keyboard)
        .onTapGesture {
            #if !os(macOS)
            UIApplication.shared.endEditing()
            #endif
        }
    }
    
    private func showDrop() {
        #if !os(macOS)
        UIApplication.shared.endEditing()
        #endif
        
        let aTitle = title.trimmingCharacters(in: .whitespacesAndNewlines)
        let aSubtitle = subtitle.trimmingCharacters(in: .whitespacesAndNewlines)
        let position: Drop.Position = positionIndex == 0 ? .top : .bottom
        
        #if os(macOS)
        
        let icon = hasIcon ? NSImage(systemSymbolName: "star.fill", accessibilityDescription: nil) : nil
        let buttonIcon = hasActionIcon ? NSImage(systemSymbolName: "arrowshape.turn.up.left", accessibilityDescription: nil) : nil
        
        let drop = Drop(
            title: aTitle,
            titleColor: customTitleColor ? NSColor(titleColor) : nil,
            subtitle: aSubtitle,
            subtitleColor: customSubtitleColor ? NSColor(subtitleColor) : nil,
            icon: icon,
            iconColor: customIconColor ? NSColor(iconColor) : nil,
            background: glassEffect ? .glass : .standard,
            action: .init(icon: buttonIcon, handler: {
                print("Drop tapped")
                Drops.hideCurrent()
            }),
            position: position,
            duration: .seconds(duration)
        )
        Drops.show(drop)
        #else
        let icon = hasIcon ? UIImage(systemName: "star.fill") : nil
        let buttonIcon = hasActionIcon ? UIImage(systemName: "arrowshape.turn.up.left") : nil
        
        let drop = Drop(
            title: aTitle,
            titleColor: customTitleColor ? UIColor(titleColor) : nil,
            subtitle: aSubtitle,
            subtitleColor: customSubtitleColor ? UIColor(subtitleColor) : nil,
            icon: icon,
            iconColor: customIconColor ? UIColor(iconColor) : nil,
            background: glassEffect ? .glass : .standard,
            action: .init(icon: buttonIcon, handler: {
                print("Drop tapped")
                Drops.hideCurrent()
            }),
            position: position,
            duration: .seconds(duration)
        )
        Drops.show(drop)
        #endif
    }
}

#if !os(macOS)
private extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
#endif

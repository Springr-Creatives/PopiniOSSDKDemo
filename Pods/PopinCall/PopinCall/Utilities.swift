//
//  Utilities.swift
//  PopinCall
//
//  Created by Ashwin Nath on 17/11/22.
//

import Foundation

import UIKit
import TwilioVideo

enum VideoCodec: CaseIterable {
    case auto, VP8, VP8Simulcast, H264, VP9
    
    var codec: TwilioVideo.VideoCodec? {
        switch self {
        case .auto:
            return nil
        case .VP8:
            return Vp8Codec()
        case .VP8Simulcast:
            return Vp8Codec(simulcast: true)
        case .H264:
            return H264Codec()
        case .VP9:
            return Vp9Codec()
        }
    }
    
    var name: String {
        switch self {
        case .auto:
            return "Auto"
        case .VP8, .H264, .VP9:
            return codec?.name ?? ""
        case .VP8Simulcast:
            return "\(VideoCodec.VP8.name) Simulcast"
        }
    }
}


class Utilities: NSObject {
    
    
    let supportedAudioCodecs: [TwilioVideo.AudioCodec] = [IsacCodec(),
                                                          OpusCodec(),
                                                          PcmaCodec(),
                                                          PcmuCodec(),
                                                          G722Codec()]
    
    // Valid signaling Regions are listed here:
    // https://www.twilio.com/docs/video/ip-address-whitelisting#signaling-communication
    let supportedSignalingRegions: [String] = ["gll",
                                               "au1",
                                               "br1",
                                               "de1",
                                               "ie1",
                                               "in1",
                                               "jp1",
                                               "sg1",
                                               "us1",
                                               "us2"]
    
    
    let supportedSignalingRegionDisplayString: [String : String] = ["gll": "Global Low Latency",
                                                                    "au1": "Australia",
                                                                    "br1": "Brazil",
                                                                    "de1": "Germany",
                                                                    "ie1": "Ireland",
                                                                    "in1": "India",
                                                                    "jp1": "Japan",
                                                                    "sg1": "Singapore",
                                                                    "us1": "US East Coast (Virginia)",
                                                                    "us2": "US West Coast (Oregon)"]
    
    var audioCodec: TwilioVideo.AudioCodec?
    var videoCodec: VideoCodec = .auto
    
    var maxAudioBitrate = UInt()
    var maxVideoBitrate = UInt()
    
    var signalingRegion: String?
    
    // The videoEncodingMode API is mutually exclusive with existing codec management APIs EncodingParameters.maxVideoBitrate and preferredVideoCodecs, therefore when .auto is used, set maxVideoBitrate to 0 (Zero indicates the WebRTC default value, which is 2000 Kbps)
    func getEncodingParameters() -> EncodingParameters?  {
        if maxAudioBitrate == 0 && maxVideoBitrate == 0 {
            return nil;
        } else if videoCodec == .auto {
            return EncodingParameters(audioBitrate: maxAudioBitrate,
                                      videoBitrate: 0)
        } else {
            return EncodingParameters(audioBitrate: maxAudioBitrate,
                                      videoBitrate: maxVideoBitrate)
        }
    }
    
    private override init() {
        // Can't initialize a singleton
    }
    
    // MARK:- Shared Instance
    static let shared = Utilities()
    
    
    
    func saveUserToken(token: String) {
        UserDefaults.standard.set(token, forKey: "popinToken")
    }
    
    func getUserToken() -> String {
        return UserDefaults.standard.string(forKey: "popinToken") ?? ""
    }
    
    func saveChannel(channel: String) {
        UserDefaults.standard.set(channel, forKey: "popinChannel")
    }
    
    func getChannel() -> String {
        return UserDefaults.standard.string(forKey: "popinChannel") ?? ""
    }
    
    func saveSeller(seller_id: Int) {
        UserDefaults.standard.set(seller_id, forKey: "popinSeller")
    }
    
    func getSeller() -> Int {
        return UserDefaults.standard.integer(forKey: "popinSeller");
    }
    
    func isConnected() -> Bool {
        let dateDouble=UserDefaults.standard.double(forKey: "agent_connect");
        if (dateDouble > 0) {
            let captureDate = Date(timeIntervalSince1970: dateDouble)
            let difference = Int(Date().timeIntervalSince(captureDate))
            if (difference < 3600)  { // 1 hour
                return true;
            }
        }
        return false;
    }
    
    func saveConnected() {
        UserDefaults.standard.set(Date().timeIntervalSince1970, forKey: "agent_connect")
    }
    
    
}

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(rgb: Int) {
        self.init(
            red: (rgb >> 16) & 0xFF,
            green: (rgb >> 8) & 0xFF,
            blue: rgb & 0xFF
        )
    }
}
extension UIViewController {
    func registerKeyboardTap() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func unregisterKeyboardTap() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
}
extension UITextField {
    @IBInspectable var placeholderColor: UIColor {
        get {
            return attributedPlaceholder?.attribute(.foregroundColor, at: 0, effectiveRange: nil) as? UIColor ?? .clear
        }
        set {
            guard let attributedPlaceholder = attributedPlaceholder else { return }
            let attributes: [NSAttributedString.Key: UIColor] = [.foregroundColor: newValue]
            self.attributedPlaceholder = NSAttributedString(string: attributedPlaceholder.string, attributes: attributes)
        }
    }
}

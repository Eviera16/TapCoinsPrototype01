//
//  BannerAd.swift
//  TapCoinsPrototype01
//
//  Created by Eric Viera on 2/18/24.
//

import Foundation
import GoogleMobileAds
import SwiftUI

struct BannerAd: UIViewRepresentable {
    @AppStorage("ad_loaded") var ad_loaded: Bool?

    var unitID: String

    func makeCoordinator() -> Coordinator {

        return Coordinator()
    }

    func makeUIView(context: Context) -> GADBannerView {

        let adView = GADBannerView(adSize: GADAdSizeBanner)

        adView.adUnitID = unitID
        adView.rootViewController = UIApplication.shared.getRootViewController()

        adView.load(GADRequest())

        ad_loaded = true

        return adView
    }

    func updateUIView(_ uiView: UIViewType, context: Context) {
        print("Updating")
    }

    class Coordinator: NSObject, GADBannerViewDelegate {
        func bannerViewDidReceiveAd(_ bannerView: GADBannerView) {
          print("bannerViewDidReceiveAd")
        }

        func bannerView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: Error) {
          print("bannerView:didFailToReceiveAdWithError: \(error.localizedDescription)")
        }

        func bannerViewDidRecordImpression(_ bannerView: GADBannerView) {
          print("bannerViewDidRecordImpression")
        }

        func bannerViewWillPresentScreen(_ bannerView: GADBannerView) {
          print("bannerViewWillPresentScreen")
        }

        func bannerViewWillDismissScreen(_ bannerView: GADBannerView) {
          print("bannerViewWillDIsmissScreen")
        }

        func bannerViewDidDismissScreen(_ bannerView: GADBannerView) {
          print("bannerViewDidDismissScreen")
        }
    }
}

extension UIApplication {
    func getRootViewController()->UIViewController{

        guard let screen = self.connectedScenes.first as? UIWindowScene else{
            return.init()
        }

        guard let root = screen.windows.first?.rootViewController else{
            return.init()
        }

        return root
    }
}


// Banner Ad

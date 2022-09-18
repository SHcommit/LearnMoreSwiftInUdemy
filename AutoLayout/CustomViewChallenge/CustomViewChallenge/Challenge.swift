//
//  Challenge.swift
//  CustomViewChallenge
//
//  Created by Jonathan Rasmusson Work Pro on 2019-10-17.
//  Copyright © 2019 Rasmusson Software Consulting. All rights reserved.
//

import UIKit

class Challenge: UIViewController {

    let margin: CGFloat = 20
    let spacing: CGFloat = 32

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupViews()
    
    }

    func setupNavigationBar() {
        navigationItem.title = "Playback"
    }

    /*
     
     Challenge here is to take the various controls and practice extracting components as subViews (UIViews).

     Two good candidates for extraction are the:

      - RowView (label and a switch)
      - CrossfadeView (label, progressbar, and max min label)
     
     ┌───────────────┐        ┌───────────────┐
     │               │        │               │
     │               ├────────▶    RowView    │ x4
     │               │        │               │
     │               │        └───────────────┘
     │   Challenge   │ extract
     │               │
     │               │        ┌───────────────┐
     │               │        │               │
     │               ├────────▶ CrossfadeView │ x1
     │               │        │               │
     └───────────────┘        └───────────────┘
     
     See if you can extract those into their own custom UIViews and then lay those out.
     
     */
    func setupViews() {
        let subTitle = "When you go offline, you'll only be able to play the music and podcasts you've downloaded."
        let offilneRow = RowView(title: "Offline", isOn: false,subTitle: subTitle)
        let crossViewRow = CrossView(center: "Crossfade", left: "0s", right: "12s")
        
        view.addSubview(offilneRow)
        //view.addSubview(crossViewRow)
        
        setupOfflineRowConstraint(view: offilneRow)
        //setupCrossViewRowConstraint(view: crossViewRow, targetAnchor: offilneRow)
        
        
//        let offlineLabel = makeLabel(withText: "Offline")
//        let offlineSwitch = makeSwitch(isOn: false)
//        let offlineSublabel = makeSubLabel(withText: "When you go offline, you'll only be able to play the music and podcasts you've downloaded.")
//
//        let crossfadeLabel = makeBoldLabel(withText: "Crossfade")
//        let crossfadeMinLabel = makeSubLabel(withText: "0s")
//        let crossfadeMaxLabel = makeSubLabel(withText: "12s")
//        let crossfadeProgressView = makeProgressView()
//
//        let gaplessPlaybackLabel = makeLabel(withText: "Gapless Playback")
//        let gaplessPlaybackSwitch = makeSwitch(isOn: true)
//
//        let hideSongsLabel = makeLabel(withText: "Hide Unplayable Songs")
//        let hideSongsSwitch = makeSwitch(isOn: true)
//
//        let enableNormalizationLabel = makeLabel(withText: "Enable Audio Normalization")
//        let enableNormalizationSwitch = makeSwitch(isOn: true)

//        view.addSubview(offlineLabel)
//        view.addSubview(offlineSwitch)
//        view.addSubview(offlineSublabel)
//
//        view.addSubview(crossfadeLabel)
//        view.addSubview(crossfadeMinLabel)
//        view.addSubview(crossfadeProgressView)
//        view.addSubview(crossfadeMaxLabel)
//
//        view.addSubview(gaplessPlaybackLabel)
//        view.addSubview(gaplessPlaybackSwitch)
//
//        view.addSubview(hideSongsLabel)
//        view.addSubview(hideSongsSwitch)
//
//        view.addSubview(enableNormalizationLabel)
//        view.addSubview(enableNormalizationSwitch)


    }
    
}

//MARK: - setup SubView Constraints
extension Challenge {
    
    func setupOfflineRowConstraint(view: RowView) {
        view.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        view.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        view.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
    }
    
    func setupCrossViewRowConstraint(view: CrossView, targetAnchor upperView: RowView ) {
        view.topAnchor.constraint(equalTo: upperView.bottomAnchor).isActive = true
        view.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        view.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
    }
}



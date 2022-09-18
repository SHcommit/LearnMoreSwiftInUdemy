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
       let stackView = makeStackView(withOrientation: .vertical)
        
        let offilneRow = RowView(title: "Offline", isOn: false)
        let crossViewRow = CrossView(center: "Crossfade", left: "0s", right: "12s")
        let subTitleLabel = makeSubLabel(withText: subTitle)
        let playbackRow = RowView(title: "Gapless Playback", isOn: true)

        let hideRow = RowView(title: "Hide Unplayable Songs", isOn: true)
        let enableNormalLable = RowView(title: "Enable Audio Normalization", isOn: true)
        stackView.addArrangedSubview(offilneRow)
        stackView.addArrangedSubview(subTitleLabel)
        stackView.addArrangedSubview(crossViewRow)
        stackView.addArrangedSubview(playbackRow)
        stackView.addArrangedSubview(hideRow)
        stackView.addArrangedSubview(enableNormalLable)
        
        view.addSubview(stackView)
        
        stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 8).isActive = true
        stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8).isActive = true
        
        // stackView 사용 안할 경우 constraint 정해줘야함.
        //view.addSubview(offilneRow)
        //view.addSubview(crossViewRow)
        //view.addSubview(subTitleLabel)
        
        //setupOfflineRowConstraint(view: offilneRow)
        //setupRowDetailViewConstraint(view: subTitleLabel, targetAnchor: offilneRow)
        //setupCrossViewRowConstraint(view: crossViewRow, targetAnchor: subTitleLabel)
    }
    
}

//MARK: - setup SubView Constraints
extension Challenge {
    
    func setupOfflineRowConstraint(view: RowView) {
        view.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        view.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 8).isActive = true
        view.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -8).isActive = true
    }
    
    func setupCrossViewRowConstraint(view: CrossView, targetAnchor upperView: UILabel ) {
        view.topAnchor.constraint(equalTo: upperView.bottomAnchor, constant: 16).isActive = true
        view.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 8).isActive = true
        view.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -8).isActive = true
    }
    
    func setupRowDetailViewConstraint(view: UILabel, targetAnchor upperView: RowView) {
        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: upperView.bottomAnchor, constant: 16),
            view.leadingAnchor.constraint(equalTo: self.view.leadingAnchor,constant: 8),
            view.trailingAnchor.constraint(equalTo: self.view.trailingAnchor,constant: -8)])
    }
    
}



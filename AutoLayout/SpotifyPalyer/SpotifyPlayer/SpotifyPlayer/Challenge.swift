//
//  Challenge.swift
//  SpotifyPlayer
//
//  Created by Jonathan Rasmusson (Contractor) on 2019-08-26.
//  Copyright © 2019 Jonathan Rasmusson. All rights reserved.
//

import UIKit

class Challenge: UIViewController {
    
    let albumImage = makeImageView(named: "rush")
    let trackLabel = makeTrackLabel(withText: "Tom Sawyer")
    let albumLabel = makeAlbumLabel(withText: "Rush • Moving Pictures (2011 Remaster)")

    let playButton = makePlayButton()
    let previewStartLabel = makePreviewLabel(withText: "0:00")
    let previewEndLabel = makePreviewLabel(withText: "0:30")
    let progressView = makeProgressView()

    let spotifyButton = makeSpotifyButton(withText: "PLAY ON SPOTIFY")

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }

    func setupViews() {

        // Comment in incrementally...
        view.addSubview(albumImage)
        view.addSubview(trackLabel)
        view.addSubview(albumLabel)

        view.addSubview(playButton)
        view.addSubview(previewStartLabel)
        view.addSubview(progressView)
        view.addSubview(previewEndLabel)

        view.addSubview(spotifyButton)
        
        // Start your layout here...
        setupAlbumImageConstraint()
        setupTrackLabelConstraint()
        setupAlbumLabelConstraint()
        setupPlayControlsConstraint()
        setupSpotifyButtonConstraint()
    }
    
    
}

//MARK: - setupControlConstraints
extension Challenge {
    
    func setupAlbumImageConstraint() {
        NSLayoutConstraint.activate([
            albumImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            albumImage.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            albumImage.widthAnchor.constraint(equalTo: view.widthAnchor),
            albumImage.heightAnchor.constraint(equalTo: view.widthAnchor)])
    }
    
    func setupTrackLabelConstraint() {
        NSLayoutConstraint.activate([
            trackLabel.topAnchor.constraint(equalTo: albumImage.bottomAnchor, constant: 15),
            trackLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)])
        
    }
    
    func setupAlbumLabelConstraint() {
        NSLayoutConstraint.activate([
            albumLabel.topAnchor.constraint(equalTo: trackLabel.bottomAnchor, constant: 15),
            albumLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)])
    }
    
    func setupPlayControlsConstraint() {
        setupPlayButtonConstraint()
        setupPreviewStartLabelConstriant()
        setupProgressViewConstraint()
        setupPreviewEndLabelConstraint()
    }
    
    func setupSpotifyButtonConstraint() {
        NSLayoutConstraint.activate([
            spotifyButton.topAnchor.constraint(equalTo: playButton.bottomAnchor, constant: 15),
            spotifyButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)])
    }
    
            
    func setupPlayButtonConstraint() {
        
        NSLayoutConstraint.activate([
            playButton.topAnchor.constraint(equalTo: albumLabel.bottomAnchor, constant: 15),
            playButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            playButton.widthAnchor.constraint(equalToConstant: buttonHeight),
            playButton.heightAnchor.constraint(equalToConstant: buttonHeight)])
    }
    
    func setupPreviewStartLabelConstriant() {
        NSLayoutConstraint.activate([
            previewStartLabel.centerYAnchor.constraint(equalTo: playButton.centerYAnchor),
            previewStartLabel.leadingAnchor.constraint(equalTo: playButton.trailingAnchor, constant: 8)
        ])
    }
    
    func setupProgressViewConstraint() {
        NSLayoutConstraint.activate([
            progressView.centerYAnchor.constraint(equalTo: playButton.centerYAnchor),
            progressView.leadingAnchor.constraint(equalTo: previewStartLabel.trailingAnchor, constant: 8)])
    }
    
    func setupPreviewEndLabelConstraint() {
        NSLayoutConstraint.activate([
            previewEndLabel.centerYAnchor.constraint(equalTo: progressView.centerYAnchor),
            previewEndLabel.leadingAnchor.constraint(equalTo: progressView.trailingAnchor, constant: 8),
            previewEndLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -8)])
    }
    
    
}

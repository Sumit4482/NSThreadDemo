//
//  ViewController.swift
//  NSThreadDemo
//
//  Created by E5000855 on 24/06/24.
//

import UIKit
import Foundation

class ViewController: UIViewController {

    let imageView1 = UIImageView()
    let imageView2 = UIImageView()
    let button = UIButton(type: .system)
    var timer: Timer?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        startColorChangeTimer()
    }

    func setupUI() {
        imageView1.translatesAutoresizingMaskIntoConstraints = false
        imageView2.translatesAutoresizingMaskIntoConstraints = false
        button.translatesAutoresizingMaskIntoConstraints = false

        imageView1.backgroundColor = .red
        imageView2.backgroundColor = .blue

        button.setTitle("Fetch Image", for: .normal)
        button.addTarget(self, action: #selector(fetchImage), for: .touchUpInside)

        view.addSubview(imageView1)
        view.addSubview(imageView2)
        view.addSubview(button)

        NSLayoutConstraint.activate([
            // ImageView1 constraints
            imageView1.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView1.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 100),
            imageView1.widthAnchor.constraint(equalToConstant: 200),
            imageView1.heightAnchor.constraint(equalToConstant: 200),

            // ImageView2 constraints
            imageView2.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView2.topAnchor.constraint(equalTo: imageView1.bottomAnchor, constant: 20),
            imageView2.widthAnchor.constraint(equalToConstant: 200),
            imageView2.heightAnchor.constraint(equalToConstant: 200),

            // Button constraints
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            button.topAnchor.constraint(equalTo: imageView2.bottomAnchor, constant: 20)
        ])
    }

    @objc func fetchImage() {
        //this line create a new thread and call  the function fetchImageBG
        Thread.detachNewThreadSelector(#selector(fetchImageInBackground), toTarget: self, with: nil)
    }

    //now this func  execute onn background thread
    @objc func fetchImageInBackground() {
        let urlString = "https://dog.ceo/api/breeds/image/random"
        guard let url = URL(string: urlString) else { return }

        do {
            let data = try Data(contentsOf: url)
            if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
               let imageUrlString = json["message"] as? String,
               let imageUrl = URL(string: imageUrlString) {
              
                let imageData = try Data(contentsOf: imageUrl)
                
                //update the  UI  using  main thread
                DispatchQueue.main.async {
                    self.imageView2.image = UIImage(data: imageData)
                }
            }
        } catch {
            print("Error fetching image: \(error)")
        }
    }

    func startColorChangeTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(changeImageView1Color), userInfo: nil, repeats: true)
    }

    @objc func changeImageView1Color() {
        let colors: [UIColor] = [.red, .green, .blue, .yellow, .purple, .orange]
        imageView1.backgroundColor = colors.randomElement()
    }
}

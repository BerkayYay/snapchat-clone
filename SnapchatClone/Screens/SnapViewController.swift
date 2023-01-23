//
//  SnapViewController.swift
//  SnapchatClone
//
//  Created by Berkay YAY on 24.12.2022.
//

import UIKit
import ImageSlideshow


class SnapViewController: UIViewController {

    @IBOutlet weak var timeLabel: UILabel!
    
    var selectedSnap : Snap?
    var inputArray = [KingfisherSource]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        guard let snap = selectedSnap  else {
            return
        }
        timeLabel.text = "Time Left: \(snap.timeDifference)"
        for imageUrl in snap.imageUrlArray{
            inputArray.append(KingfisherSource(urlString: imageUrl)!)
        }
        
        let imageSlideShow = ImageSlideshow(frame: CGRect(x: 10, y: 10, width: self.view.frame.width * 0.95, height: self.view.frame.height * 0.90))
        imageSlideShow.backgroundColor = UIColor.white
        
        let pageIndicator = UIPageControl()
        pageIndicator.currentPageIndicatorTintColor = UIColor.lightGray
        pageIndicator.pageIndicatorTintColor = UIColor.black
        imageSlideShow.pageIndicator = pageIndicator
        
        imageSlideShow.contentScaleMode = UIViewContentMode.scaleAspectFit
        imageSlideShow.setImageInputs(inputArray)
        self.view.addSubview(imageSlideShow)
        self.view.bringSubviewToFront(timeLabel)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

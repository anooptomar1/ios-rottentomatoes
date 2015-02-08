//
//  MovieDetailsViewController.swift
//  RottenTomatoes
//
//  Created by Anoop tomar on 2/3/15.
//  Copyright (c) 2015 devtechie.com. All rights reserved.
//

import UIKit

class MovieDetailsViewController: UIViewController {

    @IBOutlet weak var movieDescLbl: UILabel!
    @IBOutlet weak var movieTitleLbl: UILabel!
    @IBOutlet weak var moviePoster: UIImageView!
    @IBOutlet weak var movieSynopsis: UILabel!
    @IBOutlet weak var synopsisScrollView: UIScrollView!
    
    var movieDictionary : NSDictionary?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let moviePosters = movieDictionary?["posters"] as NSDictionary;
        var movieThumbnail = moviePosters["thumbnail"] as NSString;
        let movieRatings = movieDictionary?["ratings"] as NSDictionary;
        
        let movieTitle = movieDictionary?["title"] as NSString;
        let movieYear = movieDictionary?["year"] as Int;
        let movieMPAARating = movieDictionary?["mpaa_rating"] as NSString;
        let movieCriticRatings = movieRatings["critics_score"] as Int;
        let movieAudienceScore = movieRatings["audience_score"] as Int;
        
        movieTitleLbl.text = "\(movieTitle) (\(movieYear)) \(movieMPAARating)"
        movieDescLbl.text = "Critics Score: \(movieCriticRatings), AudienceScore: \(movieAudienceScore)"
        self.navigationItem.title = movieTitle
        
        moviePoster?.setImageWithURL(NSURL(string: movieThumbnail))
        movieThumbnail = movieThumbnail.stringByReplacingOccurrencesOfString("_tmb.jpg", withString: "_ori.jpg");
        moviePoster?.setImageWithURL(NSURL(string: movieThumbnail))
        
        movieSynopsis.text = movieDictionary?["synopsis"] as NSString;
        movieSynopsis.sizeToFit();
        synopsisScrollView.contentSize = CGSize(width: UIScreen.mainScreen().bounds.width, height: UIScreen.mainScreen().bounds.height+300);
        
        var nav = self.navigationController?.navigationBar;
        
        nav?.tintColor = UIColor.blackColor();
        nav?.barStyle = UIBarStyle.Black;
        nav?.alpha = 0.5;
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

//
//  MoviesViewController.swift
//  RottenTomatoes
//
//  Created by Anoop tomar on 2/6/15.
//  Copyright (c) 2015 devtechie.com. All rights reserved.
//

import UIKit

class MoviesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var errorLbl: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var movieArray : NSArray?
    let refreshControl1: UIRefreshControl! = UIRefreshControl()
    var currentPage = 1;
    var movies : NSArray?
    enum movieOptions:Int {
        case Dvd = 1, BoxOffice = 2;
    }
    
    var currentlyShowing : movieOptions = movieOptions.Dvd;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.refreshControl1.addTarget(self, action: "onRefresh", forControlEvents: UIControlEvents.ValueChanged)
        tableView.insertSubview(refreshControl1, atIndex: 0)
        let RottenTomatoesURLString = "http://api.rottentomatoes.com/api/public/v1.0/lists/dvds/new_releases.json?page_limit=16&page=\(currentPage)&country=us&apikey=vzmkwz3xmfdk23srbt83yaxj";
        loadMovies(RottenTomatoesURLString)
        self.navigationItem.title = "Movies"
        
        var nav = self.navigationController?.navigationBar;
        
        nav?.tintColor = UIColor.blackColor();
        nav?.barStyle = UIBarStyle.Black;
        nav?.alpha = 0.5;
    }

    func onRefresh(){
        if(currentlyShowing == movieOptions.Dvd){
            currentPage++;
            let RottenTomatoesURLString = "http://api.rottentomatoes.com/api/public/v1.0/lists/dvds/new_releases.json?page_limit=16&page=\(currentPage)&country=us&apikey=vzmkwz3xmfdk23srbt83yaxj";
            loadMovies(RottenTomatoesURLString);
        }else{
            let RottenTomatoesURLString = "http://api.rottentomatoes.com/api/public/v1.0/lists/movies/box_office.json?limit=16&country=us&apikey=vzmkwz3xmfdk23srbt83yaxj";
            loadMovies(RottenTomatoesURLString);
        }
        
        
    }
    
    @IBAction func loadDVD(sender: AnyObject) {
        let RottenTomatoesURLString = "http://api.rottentomatoes.com/api/public/v1.0/lists/dvds/new_releases.json?page_limit=16&page=\(currentPage)&country=us&apikey=vzmkwz3xmfdk23srbt83yaxj";
        loadMovies(RottenTomatoesURLString);
        currentlyShowing = movieOptions.Dvd;
    }
    
    @IBAction func loadBoxOffice(sender: AnyObject) {
        let RottenTomatoesURLString = "http://api.rottentomatoes.com/api/public/v1.0/lists/movies/box_office.json?limit=16&country=us&apikey=vzmkwz3xmfdk23srbt83yaxj";
        loadMovies(RottenTomatoesURLString);
        currentlyShowing = movieOptions.BoxOffice;
    }
   
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated);
        
    }
    
    func loadMovies(url: String){
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        
        let request = NSMutableURLRequest(URL: NSURL(string: url)!)
        
        downloadMovies(url, {
            data in self.movies = data
            self.movieArray = self.movies
            self.tableView.reloadData();
            self.refreshControl1.endRefreshing();
            MBProgressHUD.hideHUDForView(self.view, animated: true)
        });
        
    }
    
    func downloadMovies(url: String, successcallback:(NSArray!) -> Void){
        let manager = AFHTTPRequestOperationManager();
        manager.GET(url, parameters: nil, success: {(operation: AFHTTPRequestOperation!, responseObject: AnyObject!) in
            if let result = responseObject["movies"] as? NSArray{
                successcallback(result);
            }
            }, failure: {(operation: AFHTTPRequestOperation!, error: NSError!) in
                if(error.code == -1009){
                    self.errorLbl.hidden = false;
                    MBProgressHUD.hideHUDForView(self.view, animated: true)
                }
            })
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let array = movieArray{
            if(array.count<16){
                self.currentPage = 1;
            }
            return array.count;
        }else{
            return 0;
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let movie = self.movieArray![indexPath.row] as NSDictionary;
        let cell : MovieCustomCell = tableView.dequeueReusableCellWithIdentifier("com.devtechie.customcell") as MovieCustomCell;
        var moviePosters = movie["posters"] as NSDictionary
        var movieThumbnail = moviePosters["thumbnail"] as NSString
        cell.movieThumbnail?.setImageWithURL(NSURL(string: movieThumbnail));
        cell.movieTitleLbl.text = movie["title"] as NSString;
        cell.movieDescLbl.text = movie["synopsis"] as NSString
        
        return cell;
    }

    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "movieDetails"){
            let details:MovieDetailsViewController = segue.destinationViewController as MovieDetailsViewController;
            var selectedMovieIndex = self.tableView.indexPathForSelectedRow()!;
            let movie = self.movieArray![selectedMovieIndex.row] as NSDictionary;
            details.movieDictionary = movie;
        }
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


import UIKit

class LoginController: UIViewController
{
    @IBOutlet weak var slidingTextLabel: UILabel!
    @IBOutlet weak var slidingTitleLabel: UILabel!
    @IBOutlet weak var pagec: UIPageControl!

    var tipstitle = ["Skillcoins", "Linkedin", "Accepting jobs"];
    var tips = ["By doing small jobs, you will earn skillcoins. With skillcoins you can buy discount for study’s or complete courses that can expend your expierence.", "To use this app, you need to have a Linkedin account, it's best that the profile is up-to date", "You are not obligated to accept all the jobs, you can just pick out the onces you like."];
    var curSlide = 0;
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        pagec.numberOfPages = tips.count;
    
        let image1 = UIImage(named: "pageT1.png")
        let imageview = UIImageView(image: image1)
        imageview.contentMode = UIViewContentMode.ScaleAspectFill
        imageview.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)
        self.view.addSubview(imageview)
        self.view.sendSubviewToBack(imageview)
        
        var leftSwipe = UISwipeGestureRecognizer(target: self, action: Selector("handleSwipes:"))
        var rightSwipe = UISwipeGestureRecognizer(target: self, action: Selector("handleSwipes:"))
        
        leftSwipe.direction = .Left
        rightSwipe.direction = .Right
        
        view.addGestureRecognizer(leftSwipe)
        view.addGestureRecognizer(rightSwipe)

    }
    
    func handleSwipes(sender:UISwipeGestureRecognizer) {
        if (sender.direction == .Left) {
            curSlide = curSlide + 1;
            
            if(curSlide < tips.count) {
                self.slidingTextLabel.slideInFromRight()
                self.slidingTextLabel.text = tips[curSlide];
                
                self.slidingTitleLabel.slideInFromRight()
                self.slidingTitleLabel.text = tipstitle[curSlide];
                
                pagec.currentPage = curSlide;
            } else {
                curSlide = 0;
                self.slidingTextLabel.slideInFromRight()
                self.slidingTextLabel.text = tips[curSlide];
                
                self.slidingTitleLabel.slideInFromRight()
                self.slidingTitleLabel.text = tipstitle[curSlide];
                
                pagec.currentPage = curSlide;

            }
            
        }
        
        if (sender.direction == .Right) {
            println(curSlide);
            switch(curSlide) {
                case 0:
                    var curSlide = 2;
                    println(curSlide);
                    self.slidingTextLabel.slideInFromLeft()
                    self.slidingTextLabel.text = tips[curSlide];
                
                    self.slidingTitleLabel.slideInFromLeft()
                    self.slidingTitleLabel.text = tipstitle[curSlide];
                
                    pagec.currentPage = curSlide;
                
                    break;
                case 1:
                    var curSlide = 0;
                    println(curSlide);
                    self.slidingTextLabel.slideInFromLeft()
                    self.slidingTextLabel.text = tips[curSlide];
                    
                    self.slidingTitleLabel.slideInFromLeft()
                    self.slidingTitleLabel.text = tipstitle[curSlide];
                    break;
                case 2:
                    var curSlide = 1;
                    println(curSlide);

                    self.slidingTextLabel.slideInFromLeft()
                    self.slidingTextLabel.text = tips[curSlide];
                    
                    self.slidingTitleLabel.slideInFromLeft()
                    self.slidingTitleLabel.text = tipstitle[curSlide];
                    break;
            default:
                break;
            }
        }
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
}

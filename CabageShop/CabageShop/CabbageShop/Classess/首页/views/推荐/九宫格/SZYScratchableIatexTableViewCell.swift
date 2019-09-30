

import UIKit

class SZYScratchableIatexTableViewCell: UITableViewCell {
    
    @IBOutlet weak var bg_view: UIView!
    @IBOutlet weak var bg_view_height: NSLayoutConstraint!
    
    var mainCollectionView : UICollectionView?
    let identyfierTable1 = "identyfierTable1"
    let identyfierTable2 = "identyfierTable2"
    let identyfierTable3 = "identyfierTable3"
    
    let kSpace : CGFloat = 0
    
    var entranceDiy = entranceDiyModel()
    weak var superViewController : UIViewController?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        bg_view_height.constant = 200
        
        let layout = LXFChatEmotionCollectionLayout()
        layout.itemSize = CGSize(width: kSCREEN_WIDTH / 4, height: bg_view_height.constant / 2)
//        //        配置UICollectionView
//        let layout = UICollectionViewFlowLayout.init()
//        //        滑动方向
//        layout.scrollDirection = .horizontal
//        //        最小列间距
//        layout.minimumInteritemSpacing = kSpace
//        //        最小行间距
//        layout.minimumLineSpacing = kSpace
        
        mainCollectionView = UICollectionView.init(frame: CGRect(x: 0, y: -kStatusBarH, width: kSCREEN_WIDTH, height: kSCREEN_HEIGHT+kStatusBarH-49), collectionViewLayout: layout)
        mainCollectionView?.delegate = self
        mainCollectionView?.dataSource = self
        mainCollectionView?.register(UINib.init(nibName: "LNSuperOptionsCell", bundle: nil), forCellWithReuseIdentifier: identyfierTable1)
        
        bg_view.addSubview(mainCollectionView!)
        mainCollectionView?.backgroundColor = UIColor.clear
        mainCollectionView?.showsHorizontalScrollIndicator = false
        mainCollectionView?.showsVerticalScrollIndicator = false
        mainCollectionView?.snp.makeConstraints({ (ls) in
            ls.left.right.bottom.equalToSuperview()
            ls.top.equalToSuperview()
        })
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func serUpModel(model: entranceDiyModel) {
        entranceDiy = model
        
        mainCollectionView?.reloadData()
    }
    
    
}
extension SZYScratchableIatexTableViewCell : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return entranceDiy.data.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell:LNSuperOptionsCell = collectionView.dequeueReusableCell(withReuseIdentifier: identyfierTable1, for: indexPath) as! LNSuperOptionsCell
        
        cell.setUpValues3(model: entranceDiy.data[indexPath.row])
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        let vc = self.viewContainingController() as? SZYMainViewController  //推荐
        vc!.moduleIdentifier(str: entranceDiy.data[indexPath.row].url, vc: superViewController!)
        
    }
//    //    每个cell的尺寸
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        return CGSize(width: kSCREEN_WIDTH / 4, height: bg_view.height / 2)
//    }
    //    每个section的缩进
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
}

import UIKit
import WonderPush

class ViewController: UITableViewController {

    var cellConfiguration = [
        ["title":"FIRST VISIT",   "event":"firstVisit", "bgColor": UIColor(red: 0/255.0, green: 144/255.0, blue: 255/255.0, alpha: 1.0)],
        ["title":"NEWS READ",     "event":"newsRead",   "bgColor": UIColor(red:16/255.0, green:172/255.0, blue:255/255.0, alpha:1.0)],
        ["title":"GAME OVER",     "event":"gameOver",   "bgColor": UIColor(red:99/255.0, green:192/255.0, blue:242/255.0, alpha:1.0)],
        ["title":"LIKE",          "event":"like",       "bgColor": UIColor(red:172/255.0, green:217/255.0, blue:228/255.0, alpha:1.0)],
        ["title":"ADD TO CART",   "event":"addToCart", "data": ["float_amount": 14.99], "bgColor": UIColor(red:149/255.0, green:149/255.0, blue:149/255.0, alpha:1.0)],
        ["title":"PURCHASE",      "event":"purchase",   "bgColor": UIColor(red: 51/255.0, green: 51/255.0, blue: 51/255.0, alpha:1.0)],
        ["title":"GEOFENCING",    "event":"geofencing", "bgColor": UIColor(red:  0/255.0, green:153/255.0, blue:102/255.0, alpha:1.0)],
        ["title":"INACTIVE USER", "event":"inactivity", "bgColor": UIColor(red:222/255.0, green:113/255.0, blue:113/255.0, alpha:1.0)],
        ["title":"GENDER: MALE",           "data":["string_gender":"male"],   "bgColor": UIColor(red:222/255.0, green:113/255.0, blue:113/255.0, alpha:1.0)],
        ["title":"GENDER: FEMALE",         "data":["string_gender":"female"], "bgColor": UIColor(red:222/255.0, green:113/255.0, blue:113/255.0, alpha:1.0)],
        ["title":"GENDER: [MALE, FEMALE]", "data":["string_gender":["male","female"]], "bgColor": UIColor(red:222/255.0, green:113/255.0, blue:113/255.0, alpha:1.0)],
        ["title":"GENDER: NULL",           "data":["string_gender":NSNull()], "bgColor": UIColor(red:222/255.0, green:113/255.0, blue:113/255.0, alpha:1.0)],
    ]
    var cellHeight: CGFloat = 0

    override var shouldAutorotate: Bool {
        get {
            return true
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        calculateNewCellHeight(for: tableView.frame.size);
    }

    func calculateNewCellHeight(for size:CGSize) {
        cellHeight = (size.height
                - navigationController!.navigationBar.frame.size.height
                - UIApplication.shared.statusBarFrame.size.height
            ) / CGFloat(cellConfiguration.count)
        if (cellHeight < 44) {
            cellHeight = 44
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        if (WonderPush.isReady()) {
            updateTitle()
        } else {
            NotificationCenter.default.addObserver(forName: NSNotification.Name("_wonderpushInitialized"), object: nil, queue: nil, using: { (note) in
                self.updateTitle()
            })
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        calculateNewCellHeight(for: size)
        tableView.reloadData()
    }

    func updateTitle() {
        if (WonderPush.getNotificationEnabled()) {
            title = "SIMULATE AN EVENT BELOW"
        } else {
            title = "(Push disabled)"
        }
    }
    
    @IBAction func readInstallationCustomProperties(_ sender: Any) {
        let custom = WonderPush.getInstallationCustomProperties()
        let data = try? JSONSerialization.data(withJSONObject: custom!)
        let str = String(data: data ?? Data(), encoding: .utf8)
        UIAlertView(title: "Install custom properties", message: str, delegate: nil, cancelButtonTitle: "Close").show()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        var myLabel: UILabel
        if (cell == nil || cell!.frame.size.width != tableView.frame.size.width || cell!.frame.size.height != cellHeight) {
            cell = UITableViewCell(style: .subtitle, reuseIdentifier:"cell")
            cell!.frame = CGRect(x: cell!.frame.origin.x, y: cell!.frame.origin.y, width: tableView.frame.size.width, height: cellHeight)
            cell!.autoresizingMask = .flexibleWidth
            myLabel = UILabel(frame: cell!.frame)
            myLabel.autoresizingMask = .flexibleWidth
            myLabel.tag = 111
            myLabel.textAlignment = .center
            myLabel.textColor = UIColor(white:1.0, alpha:1.0)
            myLabel.font = UIFont.boldSystemFont(ofSize: 30.0)
            cell!.contentView.addSubview(myLabel)
        }

        myLabel = cell!.contentView.viewWithTag(111) as! UILabel
        myLabel.text = cellConfiguration[indexPath.row]["title"] as! String?
        myLabel.backgroundColor = cellConfiguration[indexPath.row]["bgColor"] as! UIColor?
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeight
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cellConf = cellConfiguration[indexPath.row]
        let type = cellConf["event"] as? String
        let data = cellConf["data"] as? [AnyHashable : Any]
        if (type == nil) {
            WonderPush.putInstallationCustomProperties(data)
        } else {
            WonderPush.trackEvent(type, withData: data ?? [:])
        }
        if let cell = tableView.cellForRow(at: indexPath) {
            cell.isSelected = false
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellConfiguration.count
    }
    
}

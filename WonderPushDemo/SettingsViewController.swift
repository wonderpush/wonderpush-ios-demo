import Foundation
import WonderPush

class SettingsViewController: UITableViewController, UITextViewDelegate {

    @IBOutlet weak var swtEnableNotifications: UISwitch!
    @IBOutlet weak var swtEnableGeolocation: UISwitch!
    @IBOutlet weak var txtUserId: UITextField!
    @IBOutlet weak var swtNotificationTypeAlert: UISwitch!
    @IBOutlet weak var swtNotificationTypeBadge: UISwitch!
    @IBOutlet weak var swtNotificationTypeSound: UISwitch!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let geolocation = UserDefaults.standard.bool(forKey: "geolocation")
        swtEnableGeolocation.setOn(geolocation, animated: false)
        
        if (WonderPush.isReady()) {
            loadSettings();
        } else {
            swtEnableNotifications.isEnabled = false
            NotificationCenter.default.addObserver(forName: NSNotification.Name("_wonderpushInitialized"), object: nil, queue: nil, using: { (node) in
                self.swtEnableNotifications.isEnabled = true
                self.loadSettings();
            })
        }
        
        if let settings = UIApplication.shared.currentUserNotificationSettings {
            let types = settings.types
            swtNotificationTypeAlert.setOn(types.contains(.alert), animated: false)
            swtNotificationTypeBadge.setOn(types.contains(.badge), animated: false)
            swtNotificationTypeSound.setOn(types.contains(.sound), animated: false)
        }
    }
    
    func loadSettings() {
        swtEnableNotifications.setOn(WonderPush.getNotificationEnabled(), animated: false)
        txtUserId.text = WonderPush.userId()
    }
    
    @IBAction func swtEnableNotifications_valueChange(_ sender: UISwitch!) {
        WonderPush.setNotificationEnabled(sender.isOn)
    }
    
    @IBAction func swtEnableGeolocation_valueChange(_ sender: UISwitch!) {
        let locationManager = UIApplication.shared.delegate!.perform(#selector(getter: AppDelegate.locationManager)).takeRetainedValue() as! CLLocationManager
        UserDefaults.standard.set(swtEnableNotifications.isOn, forKey:"geolocation")
        if (swtEnableNotifications.isOn) {
            locationManager.startUpdatingLocation()
        } else {
            locationManager.stopUpdatingLocation()
        }
    }

    func textFieldShouldReturn(_ textField: UITextField!) -> Bool {
        if (textField == txtUserId) {
            print("Setting userId to \"\(txtUserId.text)\"")
            WonderPush.setUserId(txtUserId.text)
        }
        textField.resignFirstResponder()
        return true;
    }
    
    @IBAction func swtNotificationType_valueChange(_ sender: UISwitch!) {
        if let currentSettings = UIApplication.shared.currentUserNotificationSettings {
            var types = currentSettings.types;
            if (swtNotificationTypeAlert.isOn) {
                types.insert(.alert)
            } else {
                types.remove(.alert)
            }
            if (swtNotificationTypeBadge.isOn) {
                types.insert(.badge)
            } else {
                types.remove(.badge)
            }
            if (swtNotificationTypeSound.isOn) {
                types.insert(.sound)
            } else {
                types.remove(.sound)
            }
            let settings = UIUserNotificationSettings(types: types, categories:currentSettings.categories)
            UIApplication.shared.registerUserNotificationSettings(settings)
        }
    }

    @IBAction func btnUnregister_touchUpInside(_ sender: UIButton!) {
        UIApplication.shared.unregisterForRemoteNotifications()
    }
    
}

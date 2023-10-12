//
//  ViewController.m
//  Pentagram
//
//  Created by GeoSn0w on 3/18/22.
//

#import "ViewController.h"
#include "Exploit/desc_race.h"
#import <sys/sysctl.h>
#include "Exploit/spray_stuff.h"
#import <sys/utsname.h>

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UITextView *errorTextView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Redirect stdout and stderr to the errorTextView
    freopen([[[self errorTextView] text] fileSystemRepresentation], "a+", stdout);
    freopen([[[self errorTextView] text] fileSystemRepresentation], "a+", stderr);
}

- (void)detectdevicekernel {
    struct utsname utsnamestring;
    uname(&utsnamestring);
    printf("%s%s%s\n", utsnamestring.version, utsnamestring.release, utsnamestring.machine);
    return;
}

- (void)viewDidAppear:(BOOL)animated {
    [self detectdevicekernel];
    uint64_t mem;
    size_t len = sizeof(uint64_t);
    sysctlbyname("hw.memsize", &mem, &len, NULL, 0);
    printf("Mem: %lld\n", mem);
    
    if (mem >= 4100000000) {
        // Device has more than 4GB of RAM
        UIAlertController *alertvc = [UIAlertController alertControllerWithTitle:@"Information" message:@"This device has more than 4GB of RAM. Will use Tihmstar's fork of the exploit." preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"Dismiss" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        }];
        [alertvc addAction:action];
        [self presentViewController:alertvc animated:true completion:nil];
    } else if (mem <= 4100000000 && mem > 2385486592) {
        // Device has 4GB of RAM
        UIAlertController *alertvc = [UIAlertController alertControllerWithTitle:@"Information" message:@"This device has 4GB of RAM. Will use BinaryBoy's version of the exploit." preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"Dismiss" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        }];
        [alertvc addAction:action];
        [self presentViewController:alertvc animated:true completion:nil];
    } else if (mem <= 2385486592) {
        // Device has less than 2.385GB of RAM
        UIAlertController *alertvc = [UIAlertController alertControllerWithTitle:@"Oops..." message:@"This exploit does not currently work on 2GB or lower devices. For that, you'll need to use Jake James' exploit for the same bug." preferredStyle:UIAlertControllerStyleAlert];
        [self presentViewController:alertvc animated:true completion:nil];
    }
}

- (IBAction)runExploit:(id)sender {
    if (desc_race() == 0) {
        // Exploit succeeded
        printf("Exploit succeeded.\n");
        UIAlertController *alertvc = [UIAlertController alertControllerWithTitle:@"Exploit seems to work!" message:@"Exploit succeeded, and pipe write also worked. This device on this particular iOS version appears to be compatible with this exploit. Do not update your device! Close the app to reboot now and clean up. If it doesn't reboot by itself, please reboot manually." preferredStyle:UIAlertControllerStyleAlert];
        [self presentViewController:alertvc animated:true completion:nil];
    } else if (desc_race() == -3) {
        // Exploit failed due to pipe leak
        printf("Exploit failed because pipe leak failed.\n");
        UIAlertController *alertvc = [UIAlertController alertControllerWithTitle:@"An issue occurred." message:@"Exploit failed because pipe leak failed. It's possible the device is running an incompatible iOS version, but still, reboot and try again a few more times. Exploit isn't 100% foolproof." preferredStyle:UIAlertControllerStyleAlert];
        [self presentViewController:alertvc animated:true completion:nil];
    } else if (desc_race() == -1) {
        // Exploit failed due to Pipe Write
        printf("Exploit failed because Pipe Write failed.\n");
        UIAlertController *alertvc = [UIAlertController alertControllerWithTitle:@"An issue occurred." message:@"Exploit failed because Pipe Write failed. It's possible the device is running an incompatible iOS version, but still, reboot and try again a few more times. Exploit isn't 100% foolproof." preferredStyle:UIAlertControllerStyleAlert];
        [self presentViewController:alertvc animated:true completion:nil];
    } else if (desc_race() == -1) {
        // Exploit failed due to Pipe Spray
        printf("Exploit failed because Pipe Spray failed.\n");
        UIAlertController *alertvc = [UIAlertController alertControllerWithTitle:@"An issue occurred." message:@"Exploit failed because Pipe Spray failed. It's possible the device is running an incompatible iOS version, but still, reboot and try again a few more times. Exploit isn't 100% foolproof." preferredStyle:UIAlertControllerStyleAlert];
        [self presentViewController:alertvc animated:true completion:nil];
    } else if (desc_race() == 1) {
        // Exploit failed due to an unhandled error
        printf("Exploit failed due to an unhandled error.\n");
        UIAlertController *alertvc = [UIAlertController alertControllerWithTitle:@"An issue occurred." message:@"Exploit failed due to an unhandled error. It's possible the device is running an incompatible iOS version, but still, reboot and try again a few more times. Exploit isn't 100% foolproof." preferredStyle:UIAlertControllerStyleAlert];
        [self presentViewController:alertvc animated:true completion:nil];
    }
}

@end

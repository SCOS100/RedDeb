# Devices

This directory is used to store SOC's and Devices.

# Porting

```
WARNING: We assume you're porting the device directly on that device. If you try to use `build.sh` on another device, said device will give out results based on it's own SOC. So do not go into the `Issues` tab telling me that porting doesn't work.
I AM NOT RESPONSIBLE FOR ANY DAMAGE DONE TO YOUR DEVICE, DO THIS AT YOUR OWN RISK!!!
```

If you wanna make another device available, you are gonna need a few things from the system:

`/sys/devices/soc0/family` to know your SOC's family;
`/sys/devices/soc0/soc_id` to know it's ID;
`getprop` to get it's `ro.product.device` and `ro.product.cpu.abilist`.

Using these, fork this repo and make a new directory inside whatever the SOC's family value said that's equal to the SOC'S ID. If such directory already exists, then go into that directory and make a new folder which is the **codename** of the device you're trying to port.

Take note from this template:
```
[DeviceInfo]
MarketName=Redmi Note 11
Manufacturer=Xiaomi
SOCName=Qualcomm® Snapdragon™ 680
Arch=aarch64
ABI=arm64-v8a,armeabi-v7a,armeabi

[RedDeb]
Type=Stable
BroughtBy=SCOS100
```
And make your own according to these rules:

In `MarketName`, put in the device's full name.
In `Manufacturer`, put in the device's maker.
In `SOCName`, put in the device's SOC Full Name.
In `Arch`, put in the device's architecture.
In `ABI`, put in the device's ABI List.

The last part is pretty easy, just put in `Community` instead of `Stable` and your GitHub username instead of mine.

Save this file as `info`, then create 2 dirs: `boot-imgs` and `kernel`.

Inside `boot-imgs` put in the modified `boot.img` and `vendor_boot.img`.
Inside `kernel` put in the `boot` dir where the kernel binary is stored and `lib` where the modules are.

Now you need to test the device before proceeding,
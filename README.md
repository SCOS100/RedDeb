# RedDeb - Debian and other distributions on Phones!

<sub><sup>*Note: The name is not representing it's actual purpose, other factors may apply...*</sup></sub>

# What is RedDeb?

RedDeb is a name created by @PolMartDetera on Telegram (thank you), and it is called like that because, as the name suggests, it doesn't only run on a singular device, even though some tweaks are needed, and it runs down the family of Xiaomi phones and Xiaomi sub-company made phones (such as Redmi, Mi and POCO phones) (and maybe some others).

It works by utilizing the Android boot.img to load a custom initramfs that then loads a premade environment created in the Android Data directory or SD-Card. This works because Android, as a base, uses Linux, and Linux is very versatile, being able to boot multiple OS's with a single kernel.

The nice thing about RedDeb is that, unlike other Linux OS's for Android Smartphones, it natively runs as a dual-boot next to Android thanks to the A/B Partitioning Scheme or via the DSU infrastructure.

# Which devices support/don't support RedDeb?

Right now, with the current devices that I own, RedDeb only works on the **Redmi Note 11**, but other phones that *may* be able to support RedDeb are:

* Phones with **SnapDragon chips**.
* Phones that have a **Close-To-Mainstream** kernel (e.g. 6.x.x).
* Phones with a **large community**. (custom kernel sources, tutorials on building kernels, etc.)
* Phones that you or others have succesfully **built and booted custom kernels**

If your phone has one or more of these requirements, then you might be able to build Reddeb. If your device meets **all** the requirements, then you're sure 100% that your phone can run RedDeb.

Personally, I've seen many Mediatek sources **not** build correctly, as Mediatek's are harder to build because of their closed-source kernels.

# How do I build RedDeb?

Please check [`Building`](https://github.com/SCOS100/RedDeb/wiki/Building) in the wiki.

# Downloads?

There are currently none as RedDeb is not stable yet.
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

To start, you'll need to build your kernel. (NOTE: If your device is a Redmi Note 11, then you don't need to do that as the kernel is already included inside the main branch)

Alpine, RedDeb's Linux distribution of choice, uses OpenRC, which is very easy to run on most systems.

There are, however, some requirements:
```
CONFIG_SYSVIPC
CONFIG_SYSVIPC_SYSCTL
CONFIG_BPF_SYSCALL
CONFIG_BPF_JIT
CONFIG_BPF_JIT_ALWAYS_ON
CONFIG_RD_GZIP
CONFIG_RD_BZIP2
CONFIG_RD_LZMA
CONFIG_RD_XZ
CONFIG_RD_LZO
CONFIG_RD_LZ4
CONFIG_CGROUPS
CONFIG_MEMCG
CONFIG_MEMCG_SWAP
CONFIG_MEMCG_SWAP_ENABLED
CONFIG_MEMCG_KMEM
CONFIG_BLK_CGROUP
CONFIG_DEBUG_BLK_CGROUP
CONFIG_CGROUP_WRITEBACK
CONFIG_CGROUP_SCHED
CONFIG_RT_GROUP_SCHED
CONFIG_CGROUP_PIDS
CONFIG_CGROUP_RDMA
CONFIG_CGROUP_FREEZER
CONFIG_CGROUP_HUGETLB
CONFIG_CPUSETS
CONFIG_PROC_PID_CPUSET
CONFIG_CGROUP_DEVICE
CONFIG_CGROUP_CPUACCT
CONFIG_CGROUP_PERF
CONFIG_CGROUP_BPF
CONFIG_CGROUP_DEBUG
CONFIG_SOCK_CGROUP_DATA
CONFIG_NAMESPACES
CONFIG_UTS_NS
CONFIG_IPC_NS
CONFIG_USER_NS
CONFIG_PID_NS
CONFIG_NET_NS
CONFIG_CHECKPOINT_RESTORE
CONFIG_SMP
CONFIG_VETH
CONFIG_MACVLAN
CONFIG_VLAN_8021Q
CONFIG_BRIDGE
CONFIG_NETFILTER_ADVANCED
CONFIG_NF_NAT_IPV4
CONFIG_NF_NAT_IPV6
CONFIG_IP_NF_TARGET_MASQUERADE
CONFIG_IP6_NF_TARGET_MASQUERADE
CONFIG_NETFILTER_XT_TARGET_CHECKSUM
CONFIG_NETFILTER_XT_MATCH_COMMENT
CONFIG_FUSE_FS
CONFIG_DRM_FBDEV_EMULATION (for devices with DRM/KMS)
CONFIG_FRAMEBUFFER_CONSOLE
CONFIG_FRAMEBUFFER_CONSOLE_DETECT_PRIMARY
CONFIG_FRAMEBUFFER_CONSOLE_ROTATION
CONFIG_FRAMEBUFFER_CONSOLE_DEFERRED_TAKEOVER
CONFIG_TTY
CONFIG_VT
CONFIG_VT_CONSOLE
CONFIG_VT_CONSOLE_SLEEP
CONFIG_HW_CONSOLE
CONFIG_VT_HW_CONSOLE_BINDING
CONFIG_UNIX98_PTYS
CONFIG_LEGACY_PTYS
CONFIG_DEVTMPFS
CONFIG_DEVTMPFS_MOUNT
```

There are also some suggestions to make debugging easier (you'll need it)
```
CONFIG_USB_LIBCOMPOSITE
CONFIG_USB_F_ACM
CONFIG_USB_F_SS_LB
CONFIG_USB_U_SERIAL
CONFIG_USB_U_ETHER
CONFIG_USB_U_AUDIO
CONFIG_USB_F_SERIAL
CONFIG_USB_F_OBEX
CONFIG_USB_F_NCM
CONFIG_USB_F_ECM
CONFIG_USB_F_EEM
CONFIG_USB_F_SUBSET
CONFIG_USB_RNDIS
CONFIG_USB_F_RNDIS
CONFIG_USB_F_QCRNDIS
CONFIG_USB_F_MASS_STORAGE
CONFIG_USB_F_FS
CONFIG_USB_F_UAC1
CONFIG_USB_F_UAC1_LEGACY
CONFIG_USB_F_UAC2
CONFIG_USB_F_UVC
CONFIG_USB_F_MIDI
CONFIG_USB_F_HID
CONFIG_USB_F_PRINTER
CONFIG_USB_F_DIAG
CONFIG_USB_F_CDEV
CONFIG_USB_F_CCID
CONFIG_USB_F_AUDIO_SRC
CONFIG_USB_CONFIGFS_F_ACC
CONFIG_USB_CONFIGFS_F_AUDIO_SRC
CONFIG_USB_CONFIGFS_F_UAC1
CONFIG_USB_CONFIGFS_F_UAC1_LEGACY
CONFIG_USB_CONFIGFS_F_UAC2
CONFIG_USB_CONFIGFS_F_MIDI
CONFIG_USB_CONFIGFS_F_HID
CONFIG_USB_CONFIGFS_F_UVC
CONFIG_USB_CONFIGFS_F_PRINTER
CONFIG_USB_CONFIGFS_F_DIAG
CONFIG_USB_CONFIGFS_F_CDEV
CONFIG_USB_CONFIGFS_F_CCID
CONFIG_USB_CONFIGFS_F_QDSS
CONFIG_USB_CONFIGFS_F_GSI
CONFIG_USB_CONFIGFS_F_MTP
CONFIG_USB_CONFIGFS_F_PTP
CONFIG_USB_ZERO
CONFIG_USB_ZERO_HNPTEST
CONFIG_USB_AUDIO
CONFIG_GADGET_UAC1
CONFIG_GADGET_UAC1_LEGACY
CONFIG_USB_ETH
CONFIG_USB_ETH_RNDIS
CONFIG_USB_ETH_EEM
CONFIG_USB_G_NCM
CONFIG_USB_GADGETFS
CONFIG_USB_FUNCTIONFS
CONFIG_USB_FUNCTIONFS_ETH
CONFIG_USB_FUNCTIONFS_RNDIS
CONFIG_USB_FUNCTIONFS_GENERIC
CONFIG_USB_MASS_STORAGE
CONFIG_USB_G_SERIAL
CONFIG_USB_MIDI_GADGET
CONFIG_USB_G_PRINTER
CONFIG_USB_CDC_COMPOSITE
CONFIG_USB_G_ACM_MS
CONFIG_USB_G_MULTI
CONFIG_USB_G_MULTI_RNDIS
CONFIG_USB_G_MULTI_CDC
CONFIG_USB_G_HID
CONFIG_USB_G_DBGP
CONFIG_USB_G_DBGP_SERIAL
CONFIG_USB_G_WEBCAM
CONFIG_USB_RAW_GADGET
```
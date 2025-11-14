# Acemagic X1 Control Center (Open Source Replacement)

A custom-engineered control center for the **Acemagic X1 (Z1A Chassis)** dual-screen laptop. This utility restores functionality to the 4-button screen switching array after a fresh Windows installation, replacing the missing or broken proprietary drivers.

## 🚨 The Problem
The official Acemagic driver package provided on their website is incomplete. While it installs the hardware drivers, it is missing the **"Hotkey" application** required to listen to the custom 4-button array (A, B, Mirror, Extend). Without this software, the buttons do nothing.

## ✅ The Solution
This project provides a lightweight, invisible background service that:
1.  **Intercepts raw HID signals** from the Holtek controller.
2.  **Maps them** to native Windows `DisplaySwitch.exe` commands.
3.  **Runs silently** as a High-Privilege System Task (works even before login).
4.  **Auto-reconnects** if the device wakes from sleep or is hot-plugged.

**Note on LEDs:** The RGB LEDs on the buttons run in a hardware-level "Demo Mode" (cycling colors). This is currently assumed to be internal to the controller firmware and cannot be overridden without the original factory handshake. The buttons **will** function perfectly despite the cycling lights. 

---

## 🛠 Hardware Details
This software is hard-coded for the specific controller used in the "Z1A" dual-screen chassis (also sold as Dere T30 Pro, Ninkear DS16, etc.).

* **Controller:** Holtek Semiconductor USB HID
* **VID:** `0x04D9`
* **PID:** `0xFD02`
* **Interface:** MI_00 / MI_01 (Input Reports)
* **Protocol:** 9-Byte HID Report. Byte 1 contains the button flag.

### Button Mappings
| Button | Hardware ID | Action | Windows Command |
| :--- | :--- | :--- | :--- |
| **A (Top)** | `1` | PC Screen Only | `/internal` |
| **B (Bottom)** | `4` | Second Screen Only | `/external` |
| **Mirror** | `8` | Duplicate | `/clone` |
| **Extend** | `2` | Extend | `/extend` |

---

## 📦 Installation (For End Users)

### Option A: The "USB Stick" Method (Recommended)
Use the pre-built executable found in the `installers` folder (or download from Releases).

1.  Copy the `installers` folder to the target machine.
2.  Right-click **`install_as_system.bat`** and select **Run as Administrator**.
3.  The script will kill any old instances, copy the exe to `C:\Program Files\AcemagicControl`, and register a Scheduled Task.
4.  **Reboot**. The buttons will work immediately upon the next login.

### Option B: Manual / Legacy Startup Folder
If you prefer not to install a System Task, you can run the executable manually or place it in your Startup folder (`shell:startup`).

---

## 🗑 Uninstallation

A unified uninstaller is included in the `installers` folder.

* **Full Uninstall:** Right-click `uninstall.bat` and **Run as Administrator**. This removes the System Task and Program Files.
* **Legacy Cleanup:** If you previously used the "Startup Folder" method, run `uninstall.bat /legacy` to clean up the old shortcuts.

---

## 👨‍💻 Development (Building from Source)

If you want to modify the mapping or behavior:

1.  **Install Python 3.11+**
2.  **Install Dependencies:**
    ```bash
    pip install -r requirements.txt
    ```
3.  **Run the Build Script:**
    ```bash
    dev_tools/build_exe.bat
    ```
    This uses PyInstaller to bundle the Python interpreter and `pywinusb` library into a standalone `.exe` located in the `installers` folder.

## License
MIT License. Free to use, modify, and distribute.
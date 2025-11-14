import time
import subprocess
import pywinusb.hid as hid

# --- CONFIGURATION ---
VID = 0x04D9
PID = 0xFD02

# Command Mapping (Verified from your testing)
# 1 = Button A (Top)    -> PC Screen Only
# 4 = Button B (Bottom) -> Second Screen Only
# 8 = Mirror            -> Duplicate
# 2 = Extend            -> Extend
COMMAND_MAP = {
    1: "DisplaySwitch.exe /internal",
    4: "DisplaySwitch.exe /external",
    8: "DisplaySwitch.exe /clone",
    2: "DisplaySwitch.exe /extend"
}

# Debounce (Seconds to ignore subsequent presses)
DEBOUNCE_TIME = 0.8 
last_press_time = 0

def input_handler(data):
    global last_press_time
    
    # Validate Data: [ReportID, ButtonValue, 0, 0, 0]
    if len(data) < 2: return
    val = data[1]
    
    # Ignore "Idle" signals (0)
    if val == 0: return

    # Check Debounce
    current_time = time.time()
    if current_time - last_press_time < DEBOUNCE_TIME:
        return
    
    # Execute Command
    if val in COMMAND_MAP:
        cmd = COMMAND_MAP[val]
        # subprocess.Popen runs it silently without blocking
        subprocess.Popen(cmd, shell=True, creationflags=subprocess.CREATE_NO_WINDOW)
        last_press_time = current_time

def main():
    print("Acemagic Control Service Started.")
    
    while True:
        try:
            # 1. Find the Device
            filter = hid.HidDeviceFilter(vendor_id=VID, product_id=PID)
            devices = filter.get_devices()

            if devices:
                # 2. Attach Listener to ALL interfaces (MI_00 and MI_01)
                # This ensures we catch the signal regardless of how Windows mapped it
                for device in devices:
                    try:
                        device.open()
                        device.set_raw_data_handler(input_handler)
                    except:
                        pass
                
                # 3. Keep Alive Loop
                # We stay here as long as the device is connected
                while True:
                    if not any(d.is_plugged() for d in devices):
                        break # Device disconnected, restart search
                    time.sleep(2)
            
            else:
                # Device not found (booting up?), wait and retry
                time.sleep(5)
                
        except Exception:
            # If anything crashes (sleep mode, driver reset), wait and restart
            time.sleep(5)

if __name__ == '__main__':
    main()
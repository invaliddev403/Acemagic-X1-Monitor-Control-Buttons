# HT66FB540 ICP Wiring & Programmer Notes

Goal: read and backup the HT66FB540 flash firmware before making modifications.

## Chip
- HT66FB540, 28-pin SSOP-A package
- Datasheet: `HT66FB540_542_550_560v210.pdf` (Rev 2.10, March 2026)

## Programmer / Adapter
OCDS adapter pinout (5-pin):

| Pin | Signal |
|-----|--------|
| 1   | VDD    |
| 2   | RESB   |
| 3   | NC     |
| 4   | SDA    |
| 5   | GND    |

## Use ICP Mode (not OCDS) to Read Flash

OCDS is only for the HT66VB540 EV emulator chip — it does NOT work directly on the HT66FB540.
To read/write the HT66FB540 flash, use **ICP (In-Circuit Programming)** mode.

## ICP Wiring — Adapter → 28-pin SSOP Chip

| Adapter Pin | Signal    | Chip Pin | Chip Pin Name     |
|-------------|-----------|----------|-------------------|
| 1 (VDD)     | Power     | Pin 8    | UBUS/PE1/AVDD/VDD |
| 2 (RESB)    | ICP Clock | Pin 13   | RES/OCDSCK/ICPCK  |
| 3 (NC)      | —         | —        | —                 |
| 4 (SDA)     | ICP Data  | Pin 5    | UDN/GPIO0/ICPDA   |
| 5 (GND)     | Ground    | Pin 10   | VSS               |

> **Note:** In ICP mode, adapter "SDA" goes to chip Pin 5 (UDN/ICPDA) — NOT pin 4 (OCDSDA).

## Hardware Cautions

- During programming, UDN (pin 5) and RES (pin 13) are taken over by the programmer — isolate from other circuitry on the board.
- Put a **>300Ω resistor** (or <1nF cap) in series on the RES line between the programmer and any other circuitry tied to reset.

## Software

Use **Holtek HT-IDE3000** (or a compatible third-party Holtek ICP writer) to read/verify/save the binary.
The Holtek e-Link programmer supports ICP mode for FB-series chips.

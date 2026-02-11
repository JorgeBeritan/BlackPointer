#!/usr/bin/env python3
import os 
import time
import sys

ROJO = '\033[91m'
VERDE = '\033[92m'
AMARILLO = '\033[93m'
AZUL = '\033[94m'
BLANCO = '\033[97m'
RESET = '\033[0m'
NEGRITA = '\033[1m'
b = "\u2588"
l = "\u2550"

def limpiar():
    os.system('cls' if os.name == "nt" else 'clear')

def barra_carga(texto, tiempo=1.5):
    sys.stdout.write(f"{VERDE}[*]{texto:<20} {RESET}")
    sys.stdout.flush()

    for i in range(10):
        time.sleep(tiempo / 10)
        sys.stdout.write(f"{VERDE}.{RESET}")
        sys.stdout.flush()
        print(f" {NEGRITA} [OK] {RESET}")

def banner():
    limpiar()
    arte = r"""
██████╗ ██╗  █████╗  ██████╗  ██╗ ██╗
██╔══██╗██║  ██╔══██╗██╔═══╝  ██║ ██╔
██████╔╝██║  ███████║██║      █████╔╝ 
██╔══██╗██║  ██╔══██║██║      ██╔═██╗ 
██████╔╝████ ██   ██║ ██████╗ ██║ ██╗
╚═════╝ ╚══════╝╚═╝ ╚═════╝╚═╝╚═╝
██████╗ ██████╗   ██╗███╗   ██╗████████╗███████╗██████╗
██╔══██╗██╔═══██╗ ██║████╗  ██║╚══██╔══╝██╔════╝██╔══██╗
██████╔╝██║   ██║ ██║██╔██╗ ██║   ██║   █████╗  ██████╔╝
██╔═══╝ ██║   ██║ ██║██║╚██╗██║   ██║   ██╔══╝  ██╔══██╗
██║     ╚██████╔╝ ██║██║ ╚████║   ██║   ███████╗██║   ██║
╚═╝      ╚═════╝  ╚═╝╚═╝ ╚═══╝    ╚═╝   ╚══════╝╚═╝   ╚═╝

"""
    print(f"{ROJO}{NEGRITA}{arte}{RESET}")
    print(f"{BLANCO}={'='*62}{RESET}")
    print(f"   :: BLACK POINTER :: ED25519 ENCRYPTED :: {ROJO}GOD MODE{RESET}")
    print(f"{BLANCO}={'='*62}{RESET}\n")

def inicio_sistema():
    limpiar()
    print(f"{AZUL}[INFO] Starting BlackPointer Framework v1.0.0...{RESET}")
    time.sleep(0.5)

    barra_carga("Loading Kernel")
    barra_carga("Mounting FS")
    barra_carga("Crypto Engine")
    barra_carga("Steganography Mod")

    time.sleep(0.5)
    banner()
    print(f"{VERDE}[+] SYSTEM STATUS:{RESET}")
    time.sleep(0.2)
    print(f" > C2 Server IP.......... [{VERDE} HIDDEN {RESET}]")
    print(f" > Listener Port......... [{VERDE} 443/TCP {RESET}]")
    print(f" > Active Agents......... [{ROJO} 0 {RESET}]")
    print(f"\n{AMARILLO}[!] WARNING: SECURITY PROTOCOLS ACTIVE.{RESET}")
    print(f"{AMARILLO}[!] AUTHORIZED PERSONNEL ONLY.{RESET}\n")

def main():
    try:
        inicio_sistema()
        clave = input(f"{ROJO}{NEGRITA}[🔐] INSERT MASTER KEY TO ARM SYSTEM:{RESET}")
        print(f"\n{BLANCO}[*] Verifying Identity...", end="\r")
        time.sleep(2)
        if clave:
            print(f"\n\n{VERDE}[✓] ACCESS GRANTED. WELCOME, COMMANDER.{RESET}")
            time.sleep(1)
            print(f"\n{ROJO}BlackPointer (GodMode) >_{RESET} ", end="")
            input() # Mantiene la terminal abierta
        else:
            print(f"\n\n{ROJO}[X] ACCESS DENIED. LOCKING SYSTEM.{RESET}")
    except KeyboardInterrupt:
        print(f"\n\n{ROJO}[!] ABORTED BY USER.{RESET}")
if __name__ == "__main__":
    main()
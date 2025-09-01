import yaml
import os
import subprocess

USERNAME = os.getenv("USER")
HYPRLAND_PATH = f"/home/{USERNAME}/.config/hypr"
WALYAML_PATH = f"/home/{USERNAME}/.cache/wal/colors.yml"

#Parse colors.yaml
with open(WALYAML_PATH, "r") as wyaml:
    data = yaml.safe_load(wyaml)
background = data['special']['background']
foreground = data['special']['foreground']
cursor = data['special']['cursor']
colors = []
for n in range(16):
    colors.append(data['colors'][f'color{n}'])

#Write Hyprland Color Config
print("=== Changing Hyprland Colors! === ")
with open(f"{HYPRLAND_PATH}/config/colors.conf", "w") as hyprcolors:
    hyprcolors.write(f"$foreground=rgb({foreground[1:]})\n")
    hyprcolors.write(f"$background=rgb({background[1:]})\n")
    for n in range(16):
        hyprcolors.write(f"$color{n}=rgba({colors[n][1:]}ff)\n")
        hyprcolors.write(f"$color{n}dim=rgba({colors[n][1:]}88)\n")
print(f"✅ Done! File written at {HYPRLAND_PATH}/config/colors.conf")

print("=== Adding Vencord/BetterDiscord Theme! === ")
subprocess.run("pywal-discord")

print("=== Updating Telegram Theme! ===")
subprocess.run("walogram")
import argparse
import os
from pathlib import Path

parser = argparse.ArgumentParser("Wallpaper randomizer helper")

parser.add_argument('-r', action='store_true', help='Pick a random wallpaper')

args = parser.parse_args()

if args.r:
    print("Random wallpaper used!")
    p = Path(f'/home/{os.getenv('USER')}/.config/hypr/wallpapers')
    files = [f for f in p.iterdir()]
    

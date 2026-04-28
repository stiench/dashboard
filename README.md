
# MagicMirror² config

The repo contains the config for Magic Mirror setup

## Setup

To setup MagicMirror² on Raspberry PI, follow this guide : [https://raspberrytips.com/magic-mirror-guide/](https://raspberrytips.com/magic-mirror-guide/)

## Crontab

```bash
crontab -e
0 23 * * * /usr/bin/vcgencmd display_power 0
0 6 * * * /usr/bin/vcgencmd display_power 1
0 2 * * 0 ~/git/dashboard/update.sh
0 8 * * * ~/git/dashboard/dl-album.sh https://www.icloud.com/sharedalbum/#XXXXXXX ~/icloud-album
```

## PM2
```bash
pm2 restart mm
pm2 stop mm
pm2 start mm.sh
pm2 logs mm
``` 

## Modules

| Name | Link |
| ---- | ---- |
| Calendar | [https://github.com/MMRIZE/MMM-CalendarExt3](https://github.com/MMRIZE/MMM-CalendarExt3) |
| Google Sheet | [https://github.com/ryan-d-williams/MMM-GoogleSheets](https://github.com/ryan-d-williams/MMM-GoogleSheets) |
| Position | [https://github.com/TheBodger/MMM-ModulePosition](https://github.com/TheBodger/MMM-ModulePosition) |
| Netatmo | [https://github.com/CFenner/MMM-Netatmo](https://github.com/CFenner/MMM-Netatmo) |
| Wallpaper | [https://github.com/kolbyjack/MMM-Wallpaper](https://github.com/kolbyjack/MMM-Wallpaper) |

## iCloud Sync

[https://github.com/icloud-photos-downloader/icloud_photos_downloader](https://github.com/icloud-photos-downloader/icloud_photos_downloader)

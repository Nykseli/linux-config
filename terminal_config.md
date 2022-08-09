Save settings:

```
dconf dump /org/gnome/terminal/ > gnome_terminal_settings_backup.txt
```

Load the saved settings:

```
dconf load /org/gnome/terminal/ < gnome_terminal_settings_backup.txt
```

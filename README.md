# How-to: Dump from sysNAND USER partition to NSP
Guide on how to dump your NX titles from the sysNAND's USER partition to NSP

## Why do you want to do this?
- You can't be bothered to dump an entire sysNAND everytime you get yourself a new game.
- You want a quick and (relatively) painless way to bring over games you bought with your hard-earned cash to your emuNAND. (maybe because you want to run said game while overclocked or something?)
- Every other tutorial seems to be a pain to follow.

## Requirements
1. NxNandManager : https://github.com/eliboa/NxNandManager
2. SwitchSDTool : https://github.com/CaitSith2/SwitchSDTool
3. Hekate (you should know what this is by now)
4. Your very own `prod.keys` dumped via *Lockpick_RCM* (google it, GitHub does not likey)
5. Windows

## Steps - NX and Hekate
1. Boot the device normally, and move the games that you want to dump into the internal storage. Power off afterwards.
2. "Boot" the device into Hekate, then go to `Tools` -> `USB Tools`, and choose to mount `eMMC RAW GPP`. **Make sure Read-Only mode is kept on throughout this process**. Plug it in to your PC after.

## Steps - NxNandManager
3. Get on your computer and launch NxNandManager. Go to `Options` -> `Configure Keyset`, and click `Import keys from file`. Find your `prod.keys` dump file and import that.
4. Go to `File` -> `Open Drive`, and choose `eMMC GPP hekate`.
5. Dump your own *PRODINFO.bin* by selecting `PRODINFO` from the list of partitions, and clicking "Advanced Copy" (the diskette icon with a gear).
6. Choose `Crypto: decrypt` and specify the location of the dump output. Leave the other checkboxes empty, dump it, then set this file aside for now.
7. Now select `USER` and click on "Mount". Make sure that the only checkbox that's ticked on this window is the `Read-Only` option. You can mount it whereever, but I personally would mount it on a far-away drive letter like `N:` just to be on the safe side.
8. Next select `SYSTEM` and mount that too. Do the same as you did for `USER` but on a different drive letter.

## Steps - SwitchSDTool
9. Remember `prod.keys`? Copy that file into SwitchSDTool's root folder (where its executable resides). Rename the file here to `keys.txt`
10. Move your `PRODINFO.bin` dump to SwitchSDTool's root folder as well.
11. Create a new folder on here as well, label it `NSP` (otherwise it will fail to dump later).
12. Launch SwitchSDTool, and now click the following buttons in this exact order, selecting the following when prompted:
    - `Select SD Folder` : "USER (NxNandManager)"
    - `Select System Path` : "SYSTEM (NxNandManager)"
    - `Find SD Key`
    - `Load RSA KEK`
    - `Extract Tickets`
    - `Decrypt NCAs`
    - `Parse NCAs`

## You're good to go from here! (hopefully)
If you haven't had any issues up to this point, your titles should now appear under the `Games` tab. From this point, you can either select a single game to dump, or dump everything on the list to an NSP package.

Once you're done, remember to unmount everything in NxNandManager first before disconnecting your device, just to be safe. Have fun!

## Bonus - Fitting a large NSP under 4GB (for FAT32 SD cards)
You have a few options:
- NSPsplitty : https://github.com/Aionmagan/NSPsplitty
- splitNSP : https://github.com/AnalogMan151/splitNSP
- [**`dd`**](nsp_dd.sh) (faster) or [**`split`**](nsp_split.sh) (slower) via Linux / WSL

### Usage
```shell
./nsp_dd.sh <inputFile> [outputDir]
```
...or...
```shell
./nsp_split.sh <inputFile> [outputDir]
```

### To use `split` manually, execute:
```shell
split --bytes=$((131070*32768)) -d "nspThatIsLargerThan4GB.nsp" ""
```
This will produce split files labeled `00`, `01`, `02` and onwards, depending on how big the file is. You will then need to create a new folder with a label that ends in the `.nsp` extension (yes, we are still talking about a folder), then move all of the numbered split files into this folder.

Once done, on Windows, right-click the folder -> `Properties` -> `Advanced...` -> tick `Folder is ready for archiving` (also known as the Archive bit). If you did the split on Linux, you'll need to move it to your NX device first and set the Archive bit using something like *NX-Shell*. You should be able to use the NSP like normal after doing this. This part applies as well if you were splitting using the `dd`/`split` shell scripts I provided above.

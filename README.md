## xrecord - Capture video on OS X from the command line (including iOS devices)

## Getting started

```
brew install coming soon.  In the meantime, use the xrecord binary from the /bin directory
```

## Command line

### Help
```bash
$ xrecord --help
```

### Options
* **-l, --list**: List available capture devices.
* **-n, --name**: Device Name.
* **-i, --id**: Device ID.
* **-o, --out**: Output File.
* **-f, --force**: Overwrite existing files.
* **-q, --quicktime**: Start QuickTime in the background (necessary for iOS recording).
* **-t, --time**: Recording time in seconds (records until stopped if not specified).
* **-d, --debug**: Display debugging info to stderr.
* **-h, --help**: Prints a help message.

### Examples

#### List available capture devices
```bash
$ xrecord --quicktime --list
Available capture devices:
AppleHDAEngineInput:1B,0,1,0:1: Built-in Microphone
5f355a5b183b2d2d7ba91dcfadd4c14b98504642: iPhone
CC2437519T1F6VVDH: FaceTime HD Camera
```

#### Record video from iPhone
```bash
$ xrecord --quicktime --name="iPhone" --out="/Users/blah/video/iphone.mp4" --force
Recording started.  Hit ctrl-C to stop.
Done
```

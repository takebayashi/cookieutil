# cookieutil

A command line interface to manipulate Cocoa's cookie storage

## Usage

* `cookieutil list`: show all cookies
* `cookieutil delete <domain> <path> <name>`: delete the cookie

## Example

Delete all cookies that name starts with "__utm"

```
cookieutil list | awk '$3 ~ /^__utm/ {print $1,$2,$3}' | while read LINE; do cookieutil delete ${=LINE}; done
```

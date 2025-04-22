# BurpSuite-Browser-Fix

This repository contains a custom AppArmor profile to fix the "Burp's browser / Renderer not working" issue on Ubuntu 24.04 and later version (tested on 25.04).

## Problem Description

Burp Suite Browser does not work correctly on Ubuntu 24.04 and later due to a kernel change that restricts the use of unprivileged user namespaces. When performing a health check on the Burp browser, the following error is received:

```
Checking headless browser: Error Aborting checks due to errors. net.portswigger.browser.Zyg: No dev tools websocket output from local chromium process 8635
```

This error prevents Burp Suite from starting the integrated browser correctly, displaying the label "unconfined" for the application.

## Solution

A temporary solution involves creating a custom AppArmor profile that allows Burp Suite to run correctly on the system. This can be done by adding a specific configuration to the `/etc/apparmor.d/burpbrowser` file.

### Steps to Apply the Solution

1. **Create a new AppArmor profile file**:

   Create the `/etc/apparmor.d/burpbrowser` file and add the following content:

    ```
    # This profile allows everything and only exists to give the application a name
    # instead of showing "unconfined"
    abi <abi/4.0>, include <tunables/global>
    profile burp-browser @{HOME}/BurpSuiteCommunity/burpbrowser/*/chrome flags=(unconfined) {
        userns,
        # Site-specific adjustments and overrides. See local/README for details.
        include if exists <local/burpbrowser>
    }
    ```

2. **Load the profile into AppArmor**:

   After creating the file, load the profile using the following command:

   ```
   sudo apparmor_parser -r /etc/apparmor.d/burpbrowser
   ```

3. **Verify the correct application**:

   After applying the profile, try launching the Burp browser again. It should work correctly without the rendering error.

### Notes

- This solution is temporary and may change in the future. PortSwigger will need to implement an official fix for Ubuntu 24.04+.
- If the Burp browser path is different for your installation, adjust the profile accordingly.
- The issue has also been observed on other Ubuntu-based distributions, like Kali Linux, and the solution should work there as well.

## References

- [Ubuntu 24.04 Kernel Issue](https://discourse.ubuntu.com/t/ubuntu-24-04-lts-noble-numbat-release-notes/39890#unprivileged-user-namespace-restrictions-15)
- [The issue on BurpSuite forum](https://archive.ph/FyWJy)

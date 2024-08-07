# My Terminal Settings

## GitHub

### Windows Terminal

1. **Install scoop:**

    ```sh
    irm get.scoop.sh | iex
    ```

2. **Install fonts**

3. **Copy settings:**

    - Copy the content of `settings.json` to your Windows Terminal `settings.json`.

4. **Install oh my posh:**

    ```sh
    scoop install https://github.com/JanDeDobbeleer/oh-my-posh/releases/latest/download/oh-my-posh.json
    ```

### PowerShell

1. **Install PowerShell and update:**

    - Ensure PowerShell is installed and up-to-date.

2. **Run these commands:**

    ```sh
    Install-Module -Name Terminal-Icons -Repository PSGallery -Force
    Install-Module -Name z -Force
    scoop install fzf
    Install-Module -Name PSFzf -Scope CurrentUser -Force
    ```

3. **Update your PowerShell profile:**

    - Run `$PROFILE` in PowerShell to find the profile path.

    - Move `Microsoft.PowerShell_profile.ps1` to the directory returned by `$PROFILE`.

4. **Adjust the path:**

    - Edit `Microsoft.PowerShell_profile.ps1` to set the correct path to `oh my posh`.

### Reference

- For more detailed instructions, refer to [this video](https://www.youtube.com/watch?v=5-aK2_WwrmM).

---

This `README.md` contains personal settings for setting up Windows Terminal and PowerShell. It is intended for private use only.

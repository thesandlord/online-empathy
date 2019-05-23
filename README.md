<!-- Don't Delete This Top Part -->
<!-- Modify the button to point to your repository and add your own intro text -->

# Click The Button To Get started 

[![Open in Cloud Shell](https://gstatic.com/cloudssh/images/open-btn.svg)](https://console.cloud.google.com/cloudshell/editor?cloudshell_print=instructions.txt&cloudshell_git_repo=https://github.com/thesandlord/online-empathy.git)

<!-- Delete From Here Down -->

# How to use this project:

1. Pick a name for your challenge, such as: `kubernetes-internal-services` or `erlang-cloud-run`
1. Create a Google Sheet to store the results from the sessions
1. Create a tab in the sheet with the name you picked in step 1
1. Share edit permission for the sheet with: `sheet-writer@online-empathy.iam.gserviceaccount.com`
1. Fork this repo
1. Edit `steps.yaml` with the following information:
   1. `name:` the name you picked in step 1
   1. `id:` the [ID of the Google Sheet](https://developers.google.com/sheets/api/guides/concepts#sheet_id) you created in step 2
1. Add your challenge steps to `steps.yaml`
   1. `name:` This should be a unique name for each step
   1. `assignment:` This is the text that is printed out when the user gets to this step
   1. See `example_steps.yaml` for a real example
1. Modify the `Open In Google Cloud Shell` button with a link to your fork:
```
[![Open in Cloud Shell](https://gstatic.com/cloudssh/images/open-btn.svg)](https://console.cloud.google.com/cloudshell/editor?cloudshell_print=instructions.txt&cloudshell_git_repo=<YOUR_REPO_HERE>)
```
9. Remove this text from `README.md` and replace with your own intro.
1. _Optional:_ Remove `example_steps.yaml`
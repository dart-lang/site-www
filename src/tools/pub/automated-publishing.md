---
title: Automated publishing of packages
description: Publish Dart packages to pub.dev directly from GitHub Actions.
---

You can configure automated publishing from GitHub Actions using
[OIDC tokens signed by GitHub][1] or anywhere else using a
[GCP Service Account][2].

With these methods of automated publishing, you do not need to store long-lived
secrets. The `dart pub` client authenticates using temporary tokens that either
GitHub Actions or Google Cloud IAM have signed.

{{site.alert.note}}
  Today, you can only automate publishing of existing packages.
  To create a new package, you must publish the first version using
  `dart pub publish`.
{{site.alert.end}}


## Publish packages using GitHub Actions

To publish from [GitHub Actions](https://github.com/features/actions), you must:
 * Enable automated publishing in the **Admin** tab for the package on
   `pub.dev`.
   This involves specifying:
   * The GitHub `<organization>/<repository>` from which publishing should
     happen,
   * A _tag-pattern_ that git tags must match to permit publishing.
 * Create a GitHub Action workflow for publishing in GitHub.
   This would use `.github/workflows/publish.yml` in your repository.
 * Create a `pubspec.yaml` with a `version` number that matches the
   `tag-pattern` in your package repository.
 * Create a git tag that matches the configured `tag-pattern`.

{{site.alert.note}}
  Pub.dev only allows automated publishing from GitHub Actions when the
  _workflow_ is triggered by pushing a git tag to GitHub.
  Pub.dev rejects publishing from GitHub Actions triggered without a tag.
  This ensures that new versions cannot be published by events that should
  never trigger publishing.
{{site.alert.end}}


### Configure automated publishing from GitHub Actions on pub.dev

To enable automated publication from GitHub Actions to `pub.dev`, you must be:
 * An _uploader_ on the package, or,
 * An _admin_ of the publisher (if the package is owned by a publisher).

If you have sufficient permission, you can enable automated publishing by:

1. Navigating to the **Admin** tab (`pub.dev/packages/<package>/admin`).
1. Find the **Automated publishing** section.
1. Click **Enable publishing from GitHub Actions**, this will prompt you to
   specify:
   * Repository (`<organization>/<repository>`, example: `dart-lang/pana`),
   * Tag pattern (a string containing `{{version}}`).

The _repository_ is the `<organization>/<repository>` on Github.
For example, if your repository
`https://github.com/dart-lang/pana` you must specify `dart-lang/pana` in the
repository field.

The _tag pattern_ is a string that must contain `{{version}}`. Only
Github Actions that runs in response to the push of a tag that matches this
_tag pattern_ will be allowed to publish your package.
Furthermore, the package version published _must_ also match the
`{{version}}` in the _tag pattern_.

**Example:** a _tag pattern_ like `v{{version}}` will allow Github Actions
triggered by `git tag v1.2.3 && git push v1.2.3` to publish version `1.2.3` of
your package. Thus, it's also important the `version` key in
`pubspec.yaml` matches this version number.

If your repository contains multiple packages you'll need to use separate
_tag pattern_ for each of them. A pattern like `my_package_name-v{{version}}`
for a package named `my_package_name` is a good option.

[!Configuration of publishing from GitHub Actions on pub.dev](pub-dev-gh-setup.png)
TODO: Fix screenshot!!!

### Configure a GitHub Action to publish to pub.dev

After you enable automated publishing from GitHub Actions on pub.dev, you
can create a GitHub Action in the repository, as follows:

1. Create a `.github/workflows/publish.yml` file.
1. Add the following content to this file:

```yaml
# .github/workflows/publish.yml
name: Publish to pub.dev

on:
  push:
    tags:
    # must align with the tag pattern configured on pub.dev, often just replace
    # {{version}} with [0-9]+.[0-9]+.[0-9]+*
    - 'v[0-9]+.[0-9]+.[0-9]+*' # tag pattern on pub.dev: 'v{{version}}'
    # If you prefer tags like '1.2.3', without the 'v' prefix, then use:
    # - '[0-9]+.[0-9]+.[0-9]+*' # tag pattern on pub.dev: '{{version}}'
    # If you repository contains multiple packages consider a pattern like:
    # - 'my_package_name-v[0-9]+.[0-9]+.[0-9]+*'

# Publish using the reusable workflow from dart-lang.
jobs:
  publish:
    uses: dart-lang/setup-dart/.github/workflows/publish.yml
    # with:
    #   working-directory: path/to/package/within/repository
```

Make sure to match the pattern in `on.push.tags` with the _tag pattern_
specified on pub.dev. Otherwise, the GitHub Action workflow won’t work.

The workflow file above uses
`dart-lang/setup-dart/.github/workflows/publish.yml` to publish the package.
This is a [reusable workflow][3], which allows the Dart team to maintain
the publishing logic and enables pub.dev to know how the package was published.
Using this _reusable workflow_ is strongly encouraged.

If you need generated code in your package, check this generated code into your
repository. This simplifies verifying that the files published on pub.dev match
the files from your repository. If checking generated or built artifact into
your repository is not reasonable, you can create a custom workflow along
the lines of:

```yaml
# .github/workflows/publish.yml
name: Publish to pub.dev

on:
  push:
    tags:
    - 'v[0-9]+.[0-9]+.[0-9]+*' # tag pattern on pub.dev: 'v{{version}}'

# Publish using custom workflow
jobs:
  publish:
    permissions:
      id-token: write # This is required for authentication using OIDC
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: dart-lang/setup-dart
      - name: Install dependencies
        run: dart pub get
      # Here you can insert custom steps you need
      # - run: dart tool/generate-code.dart
      - name: Publish
        run: dart pub publish --force
```

The workflow authenticates to `pub.dev` using a temporary
[GitHub-signed OIDC token][1], the token is created and configured in the
`dart-lang/setup-dart` step.
To publish to pub.dev, subsequent steps can run `dart pub publish --force`.

{{site.alert.note}}
  At this point, anyone with push access to your repository can publish new versions
  of the package. Consider using [tag protection rules][sec-gh-tag-protection] or
  [GitHub deployment Environments][sec-gh-environment] to limit who can publish.
{{site.alert.end}}

[sec-gh-tag-protection]: #hardening-security-with-tag-protection-rules-on-github
[sec-gh-environment]: #hardening-security-with-github-deployment-environments


### Triggering a automated publishing from Github Actions

When you've configured automated publishing on `pub.dev` and created a
GitHub Actions workflow, you can publish a new version of your package.
To publish, push a _git tag_ matching the configured _tag pattern_.

```console
$ cat pubspec.yaml
package: my_package_name
version: 1.2.3            # must match the version number used in the git tag
environment:
  sdk: ^2.18.0

$ git tag v1.2.3          # assuming my tag pattern is: 'v{{version}}'
$ git push origin v1.2.3  # triggers the action that publishes my package.
```

Once pushed, review the workflow logs at
`https://github.com/<organization>/<repository>/actions`.

If the Action didn't trigger, check that the pattern configured in
`.github/workflows/publish.yml` matches the pushed _git tag_.

If the Action failed, the logs may contain clues as to why it failed.
If the log offered no clues, check that you configured the correct
organization/repository and _tag pattern_ on pub.dev.

Once published, you can see the publication event in the `audit-log` on
`pub.dev`.
The `audit-log` entry should contain a link to the GitHub Action run that
published the package version.

[!Audit log after publishing from GitHub Actions](audit-log-pub-gh.png)

If you don't like using the `git` CLI to create tags, you can create _releases_
on GitHub from `https://github.com/<organization>/<repository>/releases/new`.
This requires merging the change that updated the `version` number in your
`pubspec.yaml`.
To learn more, check out [managing releases in a repository][4] from GitHub.


### Hardening security with tag protection rules on GitHub

Configuring automated publishing from GitHub Actions enables any GitHub user
who have permissions to push a tag to your repository to trigger publication.
You can restrict who can push tags to your repository using
[tag protection rules][5] on GitHub.

By limiting who can create tags matching your _tag pattern_, you can limit who
can publish the package.

At this time, the [tag protection rules][5] lack flexibility. You may want to
restrict who can trigger publishing using GitHub Deployment Environments,
as outlined in the next section.


### Hardening security with GitHub Deployment Environments

When configuring automated publishing from GitHub Actions in `pub.dev`, you can 
require a [GitHub Actions environment][6]. To use _GitHub Actions environment_
for publishing you must:

1. Navigating to the **Admin** tab (`pub.dev/packages/<package>/admin`).
1. Find the **Automated publishing** section.
1. Click **Require GitHub Actions environment**.
1. Specify an **Environment** name, (`pub.dev` is typically a good name)


[!Configure pub.dev to require a GitHub deployment environment](pub-dev-gh-env-setup.png)

When an environment is configured on pub.dev, GitHub Actions will not able to
publish unless they have `environment: pub.dev`. Thus, you must:

1. [Create an _environment_][8] with the same name on GitHub
   (typically `pub.dev`)
1. Alter your `.github/workflows/publish.yml` workflow file to specify
   `environment: pub.dev`, as follows:

```yaml
# .github/workflows/publish.yml
name: Publish to pub.dev

on:
  push:
    tags:
    - 'v[0-9]+.[0-9]+.[0-9]+*' # for tags like: 'v1.2.3'

jobs:
  publish:
    uses: dart-lang/setup-dart/.github/workflows/publish.yml
    with:
      # Specify the github actions deployment environment
      environment: pub.dev
      # working-directory: path/to/package/within/repository
```

The _environment_ is reflected in the temporary [GitHub-signed OIDC token][1]
used for authentication with pub.dev. Thus, a user with permission to push to
your repository cannot circumvent [environment protection rules][7] by modifying
the workflow file.

In GitHub settings, you can use [environment protection rules][7] to configure
_required reviewers_. If you configure this option, GitHub prevents actions with
the environment from running until one of the _required reviewers_ have approved
the run.

[!GitHub Action waiting for deployment review](gh-pending-review.png)


## Publishing from Google Cloud Build

To publish from [Google Cloud Build][9] you must:
1. Register a Google Cloud Project,
1. Create a [service account][10] for publishing to pub.dev,
1. Enable automated publishing in the admin tab for the package on pub.dev,
   specifying the email of the service account created for publishing.
1. Grant the default Cloud Build service account permission to impersonate the
   service account created for publishing.
1. Create a `cloudbuild.yaml` file which obtains a temporary OIDC `id_token`
   and uses it for publishing to pub.dev
1. Configure a Cloud Build trigger, for running the steps in `cloudbuild.yaml`
   in your project on Google Cloud Build.


{{site.alert.note}}
  When you enable automated publishing from a _service account_ you must carefully
  review who has the ability to impersonate this service account, either by
  calling through APIs, exporting service account keys or through changing
  IAM permission in the cloud project.
  See [managing service account impersonation][11] for details.
{{site.alert.end}}


### Creating a service account for publishing

To create a service account that can publish to pub.dev, you must:

1. Create a cloud project, if you don't have an existing project
   check out [creating and managing projects][12]. 
1. Create a _service account_. This account needs permission to publish your
   package on `pub.dev` and must exist in the same cloud project where you run
   Cloud Build.
   Run the following command to create a service account:

   ```sh
   gcloud iam service-accounts create pub-dev \
     --description='Service account to be impersonated when publishing to pub.dev' \
     --display-name='pub-dev'
   ```

   This creates a service account named:
   `pub-dev@$PROJECT_ID.iam.gserviceaccount.com`.

1. Grant the service account permission to publish your package.

   To complete this step, you must have _uploader_ permission on the package or
   _admin_ of the publisher that owns the package.

   a. Navigate to the **Admin** tab (`pub.dev/packages/<package>/admin`).
   a. Click the **Enable publishing with Google Cloud Service account**.
   a. Type the email of the service account into the **Service account email** field.
      You created this account in the previous step:
      `pub-dev@$PROJECT_ID.iam.gserviceaccount.com`

[!Configuration that allows service account to publish on pub.dev](pub-dev-gcb-config.png)

With this procedure complete, anyone who can impersonate the service account can
publish new versions of the package. Make sure to review who has permissions to
impersonate the service account and change permissions in the cloud project as
needed.


### Granting Cloud Build permission to publish

To publish from Cloud Build you must give the
[default Cloud Build service account][13] permission to impersonate 
the service account created for publishing in the previous section.

1. Enable the [IAM Service Account Credentials API][] in the cloud project.
   Attempts to impersonate the service account will fail without this API.

   ```sh
   # Enable IAM Service Account Credentials API
   gcloud services enable iamcredentials.googleapis.com
   ```

1. Find the project number.

   ```sh
   # The PROJECT_NUMBER can be obtained as follows:
   gcloud projects describe $PROJECT_ID --format='value(projectNumber)'
   ```

1. Grant the permission to impersonate the publishing service account.

   ```
   # Grant default cloud
   gcloud iam service-accounts add-iam-policy-binding \
     pub-dev@$PROJECT_ID.iam.gserviceaccount.com \
     --member=serviceAccount:$PROJECT_NUMBER@cloudbuild.gserviceaccount.com \
     --role=roles/iam.serviceAccountTokenCreator
   ```

### Writing a `cloudbuild.yaml` for publishing to pub.dev

To publish from Cloud Build, we must specify steps for Cloud Build to:
 * Impersonate the service account to obtain a temporary OIDC `id_token`
 * Provide the temporary `id_token` to `dart pub` for use when publishing
 * Calling `dart pub publish` to publish the package

Steps for Google Cloud Build are specified in a `cloudbuild.yaml` file, see
[build configuration file schema][15] for full documentation of the format.
In our case the this can be done as follows:

```yaml
# cloudbuild.yaml
steps:
- id: Create temporary token
  name: gcr.io/cloud-builders/gcloud
  volumes:
  - name: temporary-secrets
    path: /secrets
  script: |
    gcloud auth print-identity-token \
      --impersonate-service-account=pub-dev@$PROJECT_ID.iam.gserviceaccount.com \
      --audiences=https://pub.dev \
      --include-email > /secrets/temporary-pub-token.txt
  env:
  - PROJECT_ID=$PROJECT_ID
- id: Publish to pub.dev
  name: dart
  volumes:
  - name: temporary-secrets
    path: /secrets
  script: | 
    cat /secrets/temporary-pub-token.txt | dart pub token add https://pub.dev
    dart pub publish --force
```

The `gcloud auth print-identity-token` creates an OIDC `id_token` impersonating
the specified service account. This `id_token` is signed by Google, with a
signature that expires within 1 hour. The _audiences_ parameters lets pub.dev
know that it is the intended recipient of the token. The `--include-email`
option is necessary for pub.dev to be able to recognize the service account.

Once the `id_token` is created it is written to a file that resides in a
_volume_, this mechanism is used to [pass data between steps][16].
Avoid storing it in `/workspace`, since `/workspace` is where the repository
from which you wish to publish is checked out, this prevents the `id_token`
from being accidentally included in your package when publishing.

### Creating a Cloud Build trigger

With service accounts configured and a `cloudbuild.yaml` file in the repository
we can create a _Cloud Build Trigger_ using the
[console.cloud.google.com](https://console.cloud.google.com/cloud-build/triggers)
dashboard. This involves connecting to a _source repository_ and specifying
which events should trigger a build. You can use [GitHub][18],
[Cloud Source Repository][19], or one of the [other options][20].
For details on how to configure a _Cloud Build Trigger_, see
[creating and managing build triggers][21].

To publish packages using the `cloudbuild.yaml` we've created in the previous
step, you need to configure the type as "Cloud Build Configuration" located in
the repository in the `/cloudbuild.yaml` file.
Importantly, you should **not** specify a _service account_ for the build to be
triggered with. Instead we want to use the default service account for Cloud
Build.

[!Configuration for trigger](gcb-trigger-configuration.png)


{{site.alert.note}}
  It is possible to configure the Cloud Build trigger to run under a custom
  _service account_. If this desired it's probably best to create a new service
  account for this purpose, and allow this service account to impersonate the
  `pub-dev@$PROJECT_ID.iam.gserviceaccount.com` which can publish to pub.dev.

  In the configuration of the `pub-dev@$PROJECT_ID.iam.gserviceaccount.com`
  _service account_ we allowed the default Cloud Build service account:
  `$PROJECT_NUMBER@cloudbuild.gserviceaccount.com`, to impersonate the 
  `pub-dev@$PROJECT_ID.iam.gserviceaccount.com` service account.

  Using custom service accounts for running Cloud Builds is covered in more
  detail in [Configuring user-specified service accounts][22].
{{site.alert.end}}

When configuring your Cloud Build Trigger do consider who can trigger the
build. Because anyone who can trigger the build will be able to publish your
package. It might be wise to only allow manually triggered builds, or use
[Cloud Build approvals][17] to gate builds, as outlined in next section.

### Hardening security with Cloud Build Approvals

When configuring a _Cloud Build Trigger_ it is possible to tick the checkbox to
"require approval before build executes". If a Cloud Build Trigger requires
approval, it won't run when triggered, instead it'll wait for approval.
This can be used to limit who can publish new versions of your package.

[!Enabling approvals in configuration of the Cloud Build trigger](gcb-approval-checkbox.png)

Only a user with the 'Cloud Build Approver' role can give approval.
When giving a approval the approver can specify a URL and comment, as
illustrated below.

[!Cloud Build run waiting for approval to run](gcp-waiting-for-approval.png)

It is also possible to configure notifications for pending approvals.
For more details, see [gate build on approval][17].


## Publishing from anywhere using a Service Account

To do automated publishing from somewhere other than GitHub Actions, you may
authenticate using service accounts similarly to the approach for _Cloud Build_.
This usually involves:
 * [Creating a service account for publishing][create-svc],
 * Impersonating the service account for publishing, by either:
   * Using Workload Identity Federation, or,
   * Using Exported Service Account Keys.

How to [create a service account for publishing][create-svc] is outlined in the
section for _Cloud Build_. This should give us a service account like:
`pub-dev@$PROJECT_ID.iam.gserviceaccount.com`, which an publish to pub.dev

[create-svc]: #creating-a-service-account-for-publishing


### Using Workload Identity Federation

When running on AWS, Azure or another cloud service with OIDC or SAML support
you can use [Workload Identity Federation][23] to impersonate a GCP service
account using credentials from said cloud environment. This enables you to
leverage the identity services offered by your cloud environment.

For example, if you are deploying on EC2, you can 
[configure workload identity federation with AWS][24] such that temporary AWS
tokens from EC2 metadata service can be used to impersonate a service account.
Refer to [workload identity federation][25] for details on how to configure
such flows.


### Using Exported Service Account Keys

When running on a custom machine without identity services, you
can export service account keys. Exported service account keys allows you to
authenticate as said _service account_.
Keys can be exported for a service account as illustrated below.
Refer to [create and manage service account keys][26] further details.

```sh
# Create exported service account keys for previously created service account
gcloud iam service-accounts keys create key-file.json \
  --iam-account=pub-dev@$PROJECT_ID.iam.gserviceaccount.com

# Save the key-file.json for later use
```

You should be careful with the `key-file.json` as it is a long-lived secret and
anyone who gains access to it can authenticate as the service account, which in
turn enables them to publish your package.

To publish a package using exported service account keys do:

```sh
# Setup gcloud to authenticate using key-file.json
gcloud auth activate-service-account --key-file=key-file.json

# Create a temporary token for pub.dev and add to `dart pub token add`
# --include-email is necessary if impersonating service account, in this case
# we're authenticated as the service account, since we exported keys for it!
gcloud auth print-identity-token \
  --audiences=https://pub.dev \
  | dart pub token add https://pub.dev

# Publish using temporary token
# --force skips the manual yes/no prompt
dart pub publish --force
```


{{site.alert.note}}
  Consider using [Workload Identity Federation][23] if possible. This avoids
  long-lived secrets. Relying on workload identity federation enables you to use
  short-lived secrets that your cloud provider signs. As short-lived secrets
  expire, this limits the negative implications if leaked in logs or similar
  ways.
{{site.alert.end}}


[1]: https://docs.github.com/en/actions/deployment/security-hardening-your-deployments/about-security-hardening-with-openid-connect
[2]: https://cloud.google.com/iam/docs/service-accounts
[3]: https://docs.github.com/en/actions/using-workflows/reusing-workflows#calling-a-reusable-workflow
[4]: https://docs.github.com/en/repositories/releasing-projects-on-github/managing-releases-in-a-repository
[5]: https://docs.github.com/en/repositories/managing-your-repositorys-settings-and-features/managing-repository-settings/configuring-tag-protection-rules
[6]: https://docs.github.com/en/actions/deployment/targeting-different-environments/using-environments-for-deployment
[7]: https://docs.github.com/en/actions/deployment/targeting-different-environments/using-environments-for-deployment#environment-protection-rules
[8]: https://docs.github.com/en/actions/deployment/targeting-different-environments/using-environments-for-deployment#creating-an-environment
[9]: https://cloud.google.com/build
[10]: https://cloud.google.com/iam/docs/service-accounts
[11]: https://cloud.google.com/iam/docs/impersonating-service-accounts
[12]: https://cloud.google.com/resource-manager/docs/creating-managing-projects
[13]: https://cloud.google.com/build/docs/cloud-build-service-account
[14]: https://console.cloud.google.com/apis/api/iamcredentials.googleapis.com
[15]: https://cloud.google.com/build/docs/build-config-file-schema
[16]: https://cloud.google.com/build/docs/configuring-builds/pass-data-between-steps
[17]: https://cloud.google.com/build/docs/securing-builds/gate-builds-on-approval
[18]: https://cloud.google.com/build/docs/automating-builds/github/connect-repo-github
[19]: https://cloud.google.com/source-repositories/docs/create-code-repository
[20]: https://cloud.google.com/build/docs/triggers
[21]: https://cloud.google.com/build/docs/automating-builds/create-manage-triggers
[22]: https://cloud.google.com/build/docs/securing-builds/configure-user-specified-service-accounts
[23]: https://cloud.google.com/iam/docs/workload-identity-federation
[24]: https://cloud.google.com/iam/docs/workload-identity-federation-with-other-clouds
[25]: https://cloud.google.com/iam/docs/how-to#workload-identity-federation
[26]: https://cloud.google.com/iam/docs/creating-managing-service-account-keys


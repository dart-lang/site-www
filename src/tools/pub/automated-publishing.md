---
title: Automated publishing of packages to pub.dev
description: Publish Dart packages to pub.dev directly from GitHub Actions.
---

You can automate publishing from:
* [GitHub Actions](https://github.com/features/actions),
* [Google Cloud Build][9] or,
* Anywhere else using a [GCP service account][2].

The following sections explain how automated publishing is configured, and
how you can customize publishing flows in line with your preferences.

When configuring automated publishing you don't need to create a long-lived
secret that is copied into your automated deployment environment.
Instead, authentication relies on temporary OpenID-Connect tokens signed by
either GitHub Actions (See [OIDC for GitHub Actions][1]) or Google Cloud IAM.

You can use _exported service account keys_ for deployment
environments where an identity service isn't present.
Such exported service account keys are long-lived secrets, they might be easier
to use in some environments, but also pose a larger risk if accidentally leaked.

{{site.alert.note}}
  Today, you can only automate publishing of existing packages.
  To create a new package, you must publish the first version using
  `dart pub publish`.
{{site.alert.end}}

## Publishing packages using GitHub Actions

You can configure automated publishing using GitHub Actions. This involves:

* Enabling automated publishing on pub.dev, specifying:

  * The GitHub repository and,
  * A _tag-pattern_ that must match to allow publishing.

* Creating a GitHub Actions _workflow_ for publishing to pub.dev.
* Pushing a _git tag_ for the version to be published.

The following sections outline how to complete these steps.

{{site.alert.note}}
  Pub.dev only allows automated publishing from GitHub Actions when the
  _workflow_ is triggered by pushing a git tag to GitHub.
  Pub.dev rejects publishing from GitHub Actions triggered without a tag.
  This ensures that new versions cannot be published by events that should
  never trigger publishing.
{{site.alert.end}}

### Configuring automated publishing from GitHub Actions on pub.dev

To enable automated publication from GitHub Actions to `pub.dev`, you must be:

* An _uploader_ on the package, or,
* An _admin_ of the publisher (if the package is owned by a publisher).

If you have sufficient permission, you can enable automated publishing by:

1. Navigating to the **Admin** tab (`pub.dev/packages/<package>/admin`).
1. Find the **Automated publishing** section.
1. Click **Enable publishing from GitHub Actions**, this prompts you to
   specify:

   * A repository (`<organization>/<repository>`, example: `dart-lang/pana`),
   * A _tag-pattern_ (a string containing `{% raw %}{{version}}{% endraw %}`).

The _repository_ is the `<organization>/<repository>` on GitHub.
For example, if your repository is
`https://github.com/dart-lang/pana` you must specify `dart-lang/pana` in the
repository field.

The _tag pattern_ is a string that must contain `{% raw %}{{version}}{% endraw %}`.
Only GitHub Actions triggered by a push of a tag that matches this
_tag pattern_ will be allowed to publish your package.

![Configuration of publishing from GitHub Actions on pub.dev](/assets/img/tools/pub/pub-dev-gh-setup.png)

**Example:** a _tag pattern_ like `v{% raw %}{{version}}{% endraw %}` allows
GitHub Actions (triggered by `git tag v1.2.3 && git push v1.2.3`) to publish
version `1.2.3` of your package. Thus, it's also important that the `version` key in
`pubspec.yaml` matches this version number.

If your repository contains multiple packages, give each a separate
_tag-pattern_. Consider using a _tag-pattern_ like
`my_package_name-v{% raw %}{{version}}{% endraw %}` for a package
named `my_package_name`.

### Configuring a GitHub Action workflow for publishing to pub.dev

When automated publishing from GitHub Actions is enabled on pub.dev,
you can create a GitHub Actions workflow for publishing. This is done by
creating a `.github/workflows/publish.yml` file as follows:

```yaml
# .github/workflows/publish.yml
name: Publish to pub.dev

on:
  push:
    tags:
    # must align with the tag-pattern configured on pub.dev, often just replace
    # {{version}} with [0-9]+.[0-9]+.[0-9]+*
    - 'v[0-9]+.[0-9]+.[0-9]+*' # tag-pattern on pub.dev: 'v{{version}}'
    # If you prefer tags like '1.2.3', without the 'v' prefix, then use:
    # - '[0-9]+.[0-9]+.[0-9]+*' # tag-pattern on pub.dev: '{{version}}'
    # If your repository contains multiple packages consider a pattern like:
    # - 'my_package_name-v[0-9]+.[0-9]+.[0-9]+*'

# Publish using the reusable workflow from dart-lang.
jobs:
  publish:
    permissions:
      id-token: write # Required for authentication using OIDC
    uses: dart-lang/setup-dart/.github/workflows/publish.yml@v1
    # with:
    #   working-directory: path/to/package/within/repository
```

Make sure to match the pattern in `on.push.tags` with the _tag pattern_
specified on pub.dev. Otherwise, the GitHub Action workflow won't work.
If publishing multiple packages from the same repository, 
use a per-package _tag pattern_ like `my_package_name-v{{version}}`
and create a separate workflow file for each package.

The workflow file above uses
`dart-lang/setup-dart/.github/workflows/publish.yml` to publish the package.
This is a [reusable workflow][3] that allows the Dart team to maintain
the publishing logic and enables pub.dev to know how the package was published.
Using this _reusable workflow_ is strongly encouraged.

If you need generated code in your package, then it is preferable to check this
generated code into your repository.
This simplifies verifying that the files published on pub.dev match
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
      id-token: write # Required for authentication using OIDC
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: dart-lang/setup-dart@v1
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

### Triggering automated publishing from GitHub Actions

After you've configured automated publishing on `pub.dev` and created a
GitHub Actions workflow, you can publish a new version of your package.
To publish, push a _git tag_ matching the configured _tag pattern_.

```terminal
$ cat pubspec.yaml
```

```yaml
package: my_package_name
version: 1.2.3            # must match the version number used in the git tag
environment:
  sdk: ^2.19.0
```

```terminal
$ git tag v1.2.3          # assuming my tag pattern is: 'v{{version}}'
$ git push origin v1.2.3  # triggers the action that publishes my package.
```

Once pushed, review the workflow logs at
`https://github.com/<organization>/<repository>/actions`.

If the Action didn't trigger, check that the pattern configured in
`.github/workflows/publish.yml` matches the pushed _git tag_.
If the Action failed, the logs might contain clues as to why it failed.

Once published, you can see the publication event in the `audit-log` on
`pub.dev`.
The `audit-log` entry should contain a link to the GitHub Action run that
published the package version.

![Audit log after publishing from GitHub Actions](/assets/img/tools/pub/audit-log-pub-gh.png)

If you don't like using the `git` CLI to create tags, you can create _releases_
on GitHub from `https://github.com/<organization>/<repository>/releases/new`.
To learn more, check out [managing releases in a repository][4] from GitHub.

### Hardening security with tag protection rules on GitHub

Configuring automated publishing from GitHub Actions allows anyone who can push
a tag to your repository to trigger publishing to pub.dev.
You can restrict who can push tags to your repository using
[tag protection rules][5] on GitHub.

By limiting who can create tags matching your _tag pattern_, you can limit who
can publish the package.

At this time, the [tag protection rules][5] lack flexibility. You might want to
restrict who can trigger publishing using GitHub Deployment Environments,
as outlined in the next section.

### Hardening security with GitHub Deployment Environments

When configuring automated publishing from GitHub Actions on pub.dev, you can 
require a [GitHub Actions environment][6].
To require a _GitHub Actions environment_ for publishing you must:

1. Navigate to the **Admin** tab (`pub.dev/packages/<package>/admin`).
1. Find the **Automated publishing** section.
1. Click **Require GitHub Actions environment**.
1. Specify an **Environment** name, (`pub.dev` is typically a good name)

![Configure pub.dev to require a GitHub deployment environment](/assets/img/tools/pub/pub-dev-gh-env-setup.png)

When an environment is required on pub.dev, GitHub Actions won't be able to
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
    permissions:
      id-token: write # Required for authentication using OIDC
    uses: dart-lang/setup-dart/.github/workflows/publish.yml@v1
    with:
      # Specify the github actions deployment environment
      environment: pub.dev
      # working-directory: path/to/package/within/repository
```

The _environment_ is reflected in the temporary [GitHub-signed OIDC token][1]
used for authentication with pub.dev. Thus, a user with permission to push to
your repository cannot circumvent [environment protection rules][7] by modifying
the workflow file.

In GitHub repository settings, you can use [environment protection rules][7] to
configure _required reviewers_. If you configure this option, GitHub prevents
actions with the environment from running until one of the
_required reviewers_ have approved the run.

![GitHub Action waiting for deployment review](/assets/img/tools/pub/gh-pending-review.png)

## Publishing from Google Cloud Build

You can configure automated publishing from [Google Cloud Build][9]. This
involves:

* Register a Google Cloud Project (or using an existing project),
* Create a [service account][10] for publishing to pub.dev,
* Enable automated publishing in the admin tab for the package on pub.dev,
  specifying the email of the service account created for publishing.
* Grant the default Cloud Build service account permission to impersonate the
  service account created for publishing.
* Create a `cloudbuild.yaml` file that obtains a temporary OIDC `id_token`
  and uses it for publishing to pub.dev
* Configure a Cloud Build trigger, for running the steps in `cloudbuild.yaml`
  in your project on Google Cloud Build.

The following sections outline how to complete these steps.

{{site.alert.note}}
  When you enable automated publishing from a _service account_ you must carefully
  review who has the ability to impersonate this service account, either by
  calling through APIs, exporting service account keys, or through changing
  IAM permission in the cloud project.
  To learn more, check out [managing service account impersonation][11].
{{site.alert.end}}

### Creating a service account for publishing

For publishing to pub.dev you are going to create a _service account_ that is
granted permission to publish your package on pub.dev. You are then going to
grant Cloud Build permission to impersonate this service account.

1. [Create a cloud project][12], if you don't have an existing project.
1. Create a _service account_ as follows:

    ```terminal
    $ gcloud iam service-accounts create pub-dev \
      --description='Service account to be impersonated when publishing to pub.dev' \
      --display-name='pub-dev'
    ```

    This creates a service account named
    `pub-dev@$PROJECT_ID.iam.gserviceaccount.com`.

1. Grant the service account permission to publish your package.

   To complete this step, you must have _uploader_ permission on the package or
   be an _admin_ of the publisher that owns the package.

   a. Navigate to the **Admin** tab (`pub.dev/packages/<package>/admin`).
   a. Click **Enable publishing with Google Cloud Service account**.
   a. Type the email of the service account into the **Service account email** field.
      You created this account in the previous step:
      `pub-dev@$PROJECT_ID.iam.gserviceaccount.com`

![Configuration that allows service account to publish on pub.dev](/assets/img/tools/pub/pub-dev-gcb-config.png)

With this procedure complete, anyone who can impersonate the service account can
publish new versions of the package. Make sure to review who has permissions to
impersonate the service account and change permissions in the cloud project as
needed.

{{site.alert.note}}
  The _service account_ must be created in the same cloud project where you
  intend to run Cloud Build. If you need to impersonate across cloud projects,
  refer to [enabling service account impersonation across projects][27].
{{site.alert.end}}

### Granting Cloud Build permission to publish

To publish from Cloud Build you must give the
[default Cloud Build service account][13] permission to impersonate 
the service account created for publishing in the previous section.

1. Enable the [IAM Service Account Credentials API][14] in the cloud project.
   Attempts to impersonate a service account will fail without this API.

   ```terminal
   # Enable IAM Service Account Credentials API
   $ gcloud services enable iamcredentials.googleapis.com
   ```

1. Find the project number.

   ```terminal
   # The PROJECT_NUMBER can be obtained as follows:
   $ gcloud projects describe $PROJECT_ID --format='value(projectNumber)'
   ```

1. Grant the permission to impersonate the publishing service account.

   ```terminal
   # Grant default cloud
   $ gcloud iam service-accounts add-iam-policy-binding \
     pub-dev@$PROJECT_ID.iam.gserviceaccount.com \
     --member=serviceAccount:$PROJECT_NUMBER@cloudbuild.gserviceaccount.com \
     --role=roles/iam.serviceAccountTokenCreator
   ```

### Writing a Cloud Build configuration file

To publish from Cloud Build, you must specify steps for Cloud Build to:

* Impersonate the service account to obtain a temporary OIDC token.
* Provide the temporary OIDC token to `dart pub` for use when publishing.
* Calling `dart pub publish` to publish the package.

Steps for Google Cloud Build are provided in a `cloudbuild.yaml` file, see
[build configuration file schema][15] for full documentation of the format.

For publishing to pub.dev from Google Cloud Build, a `cloudbuild.yaml` file as
follows will do:

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
signature that expires within 1 hour. The _audiences_ parameter lets pub.dev
know that it is the intended recipient of the token. The `--include-email`
option is necessary for pub.dev to recognize the service account.

Once the `id_token` is created, it's written to a file that resides in a
_volume_; this mechanism is used to [pass data between steps][16].
Don't store the token in `/workspace`. Since `/workspace` is where the
repository from which you wish to publish is checked out.
Not using `/workspace` for storing the token reduces the risk that you
accidentally include it in your package when publishing.

### Creating a Cloud Build trigger

With service accounts configured and a `cloudbuild.yaml` file in the repository
you can create a _Cloud Build Trigger_ using the [console.cloud.google.com][28]
dashboard.
To create a build trigger, you need to connect to a _source repository_
and specify which events should trigger a build. You can use [GitHub][18],
[Cloud Source Repository][19], or one of the [other options][20].
To learn how to configure a _Cloud Build Trigger_, check out
[creating and managing build triggers][21].

To use the `cloudbuild.yaml` from the previous step, configure the
_Cloud Build Trigger_ type as "Cloud Build Configuration" located in the
repository in the `/cloudbuild.yaml` file.
Do **not** specify a _service account_ for the build to be triggered with.
Instead you'll want to use the default service account for Cloud Build.

![Configuration for trigger](/assets/img/tools/pub/gcb-trigger-configuration.png)

{{site.alert.note}}
  You can configure the Cloud Build trigger to run under a custom
  _service account_. If you want to do this, create a new service
  account for this purpose. Allow this service account to impersonate
  the `pub-dev@$PROJECT_ID.iam.gserviceaccount.com` account, which can
  publish to pub.dev.

  The configuration of the `pub-dev@$PROJECT_ID.iam.gserviceaccount.com`
  _service account_ allowed the default Cloud Build service account,
  `$PROJECT_NUMBER@cloudbuild.gserviceaccount.com`, to impersonate the 
  `pub-dev@$PROJECT_ID.iam.gserviceaccount.com` service account.
  If using a custom service account for the Cloud Build, you'll need to change
  this.

  To learn more about custom service accounts for running Cloud Builds,
  check out [Configuring user-specified service accounts][22].
{{site.alert.end}}

When configuring your Cloud Build trigger, consider who can trigger the
build. _Because triggering a build might publish a new version of your package_.
Consider only allowing manual builds or use
[Cloud Build approvals][17] to gate builds as outlined in next section.

### Hardening security with Cloud Build Approvals

When configuring a Cloud Build trigger, you can select
**require approval before build executes**. If a Cloud Build trigger
requires approval, it won't run when triggered. Instead, it'll wait for
approval.
This can be used to limit who can publish new versions of your package.

![Enabling approvals in configuration of the Cloud Build trigger](/assets/img/tools/pub/gcb-approval-checkbox.png)

Only a user with the **Cloud Build Approver** role can give approval.
When giving a approval, the approver can specify a URL and comment.

![Cloud Build run waiting for approval to run](/assets/img/tools/pub/gcp-waiting-for-approval.png)

You can also configure notifications for pending approvals.
To learn more, check out [gate build on approval][17].

## Publish from anywhere using a Service Account

To allow automated publishing outside of GitHub Actions, you might
authenticate using service accounts in way similar to _Cloud Build_.

This usually involves:

* [Create a service account for publishing][create-svc],
* Impersonate the publishing service account in one of two ways:
  * Workload Identity Federation
  * Exported Service Account Keys

The section for _Cloud Build_ outlined how to
[create a service account for publishing][create-svc].
This should provide a service account, such as
`pub-dev@$PROJECT_ID.iam.gserviceaccount.com`.

[create-svc]: #creating-a-service-account-for-publishing

### Publish using Workload Identity Federation

When running on a cloud service that supports OIDC or SAML,
you can impersonate a GCP service account using
[Workload Identity Federation][23]. This enables you to
leverage your cloud provider's identity services.

For example, if deploying on EC2, you can
[configure workload identity federation with AWS][24], allowing
temporary AWS tokens from the EC2 metadata service to impersonate a
service account.
To learn how to configure these flows, check out
[workload identity federation][25].

### Publish using Exported Service Account Keys

When running on a custom system without identity services, you
can export service account keys. Exported service account keys allows you to
authenticate as said _service account_.
To learn more, check out how to
[create and manage service account keys][26].

#### Export service account keys

1. Create exported service account keys for an existing service account.

    ```terminal
    $ gcloud iam service-accounts keys create key-file.json \
      --iam-account=pub-dev@$PROJECT_ID.iam.gserviceaccount.com
    ```

1. Save the `key-file.json` file for later use.

{{site.alert.warning}}
  Treat the `key-file.json` like a password.
  Anyone who gains access to it can authenticate as the service account
  and publish your package.
{{site.alert.end}}

#### Publish packages using exported service account keys

To publish a package using exported service account keys:

1. Setup gcloud to authenticate using `key-file.json` (created in the previous step)

    ```terminal
    $ gcloud auth activate-service-account --key-file=key-file.json
    ```

1. Create a temporary token for pub.dev and pass it to
   `dart pub token add https://pub.dev`.
   To impersonate service account, include the `--include-email` option.

    ```terminal
    $ gcloud auth print-identity-token \
      --audiences=https://pub.dev \
      | dart pub token add https://pub.dev
    ```

1. Publish using the temporary token.
   Add the `--force` option to skip the `yes/no` prompt.

    ```terminal
    $ dart pub publish --force
    ```

{{site.alert.note}}
  Consider using [Workload Identity Federation][23], if possible. This
  avoids long-lived secrets. Relying on Workload Identity Federation
  allows you to use short-lived secrets that your cloud provider signs.
  Short-lived secrets greatly reduces the security risks if accidentally leaked
  in logs or similar ways.
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
[27]: https://cloud.google.com/iam/docs/impersonating-service-accounts#enabling-cross-project
[28]: https://console.cloud.google.com/cloud-build/triggers


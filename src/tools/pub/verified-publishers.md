---
description: Learn what verified publishers are, and how they are verified.
---

# Verified publishers {% asset verified-publisher.svg alt="pub.dev verified publisher logo" %}

The pub.dev verified publisher logo {% asset verified-publisher.svg alt="pub.dev
verified publisher logo" %} let's you know that a package was published by a
publisher who's identity has been verified.

The badge appears next to packages published by verified publishers in several
places:

  * On the pub.dev landing page
  * In package search results
  * On a package detail page
  * On a publisher profile page

If you wish to see additional details (such as the contact email) for a
publisher (e.g. [dart.dev](https://pub.dev/publishers/dart.dev/)), or
see a list of all packages published by the publisher, click the publisher
identity link (e.g. `dart.dev`) next to the badge.

## Verification process

To ensure that verified publishers are trustworthy, low cost, available to
anyone interested in being a verified publisher, pub.dev relies on DNS (domain
name system) domains as an identification token. We chose DNS because we believe
that most package publishers already have a domain/homepage. During the
publisher creation process (see below), pub.dev verifies that the user creating
the verified publisher has admin access to the associated domain, based on
existing logic in the (Google Search Console)[https://search.google.com/search-console/about].

## Creating a verified publisher account

If you are a publisher and wish to create a new verified publisher,
please see the [publishing page](/tools/pub/publishing#create-verified-publisher).

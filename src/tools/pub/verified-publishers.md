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
publisher (e.g. [dart.dev](https://pub.dev/publishers/dart.dev/packages)), or
see a list of all packages published by the publisher, click the pubisher
identity link (e.g. `dart.dev`) next to the badge.

## Verification process

To ensure anyone who wishes to create a publisher account is able to do so
themselves, and to ensure there are no high verification costs, pub.dev relies
on DNS (domain name system) domains as an identification token. This was
selected as we believe most organizations who with to publish content already
have a domain/home-page. During the publisher creation process (see below),
pub.dev verifies that the user creating the verified publisher account has admin
access to the associated domain based on existing logic available in the (Google
Search Console)[https://search.google.com/search-console/about].


## Creating a verified publisher account

If you are a publisher and wish to create a new verified publisher account,
please see the [publishing page](/tools/pub/publishing#create-verified-publisher).

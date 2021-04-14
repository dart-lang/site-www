---
title: Writing package pages
description: Learn how to write a good package page.
---

This document describes what you can do to construct a good package page on pub.dev. More specifically, this document provides several tips on how to write a better README.md file, as marked in the following image. If you need more information about other parts of the package page, refer to the links below. 

<p id="gdcalert1" ><span style="color: red; font-weight: bold">>>>>  GDC alert: inline image link here (to images/image1.png). Store image on your image server and adjust path/filename/extension if necessary. </span><br>(<a href="#">Back to top</a>)(<a href="#gdcalert2">Next alert</a>)<br><span style="color: red; font-weight: bold">>>>> </span></p>


![alt_text](images/image1.png "image_tooltip")




1. About the [package layout ](https://dart.dev/tools/pub/package-layout)
2. About the [Flutter Favorite program](https://flutter.dev/docs/development/packages-and-plugins/favorites)
3. About the [package scoring system](https://pub.dev/help/scoring)
4. About [verified publishers](https://dart.dev/tools/pub/verified-publishers)
5. About the [pubspec file](https://dart.dev/tools/pub/pubspec)


## Writing a good README is important

Most package users who landed on your package on pub.dev will quickly scan your README to decide whether to try your package or not. A nice README will catch users’ attention and show that your package is worth trying.

There are seven tips that you can follow to write a good README. 



1. Write a short description at the top of the README
2. Include visual content to explain things
3. Utilize lists to present key information
4. Include at least one usage example
5. Use Dart code formatting
6. Mention terms that people might use to search for
7. Tell users where they can go next

Throughout this document, we’ll use the README of the package [in\_app\_purchase](https://pub.dev/packages/in_app_purchase) as a “full” example. Depending on the complexity of your package, you can choose to go as simple as the README of the [yaml](https://www.google.com/url?q=https://pub.dev/packages/yaml&sa=D&source=editors&ust=1617426367714000&usg=AOvVaw3baHRrdmgStJDNhepaIkPr) package. 

Note that your README be used in multiple places and contexts, such as API references, in addition to the package page on pub.dev. 


## Seven tips for good README



1. Write a short description at the top of the README

According to our user research, package users spend only a few seconds to read the package description and make a decision whether to read the rest of the README or not. Thus, you should concisely describe what the package does or achieves, at a glance. Spend some time to craft a short and sweet description and help the user to make decisions. There’s no need to write the package name again on the top. 

See examples of good descriptions below.



*   A Flutter plugin for showing rainbows.
*   This plugin allows Flutter apps to categorize bird sounds using machine learning.

If there is important information users should know about, such as project status or constraints, note that at the top too. 



*   Does not work on iOS versions below 10.3.

If you have any badges, put them under the description or anywhere high on the page as well. 

The package [in\_app\_purchase](https://pub.dev/packages/in_app_purchase) starts its README with a brief explanation of the package and a caution.



<p id="gdcalert2" ><span style="color: red; font-weight: bold">>>>>  GDC alert: inline image link here (to images/image2.png). Store image on your image server and adjust path/filename/extension if necessary. </span><br>(<a href="#">Back to top</a>)(<a href="#gdcalert3">Next alert</a>)<br><span style="color: red; font-weight: bold">>>>> </span></p>


![alt_text](images/image2.png "image_tooltip")


_Description of the package in\_app\_purchase_



2. Include visual content to explain things

UI is difficult to explain in text. If your package page is just a “wall of text” with no visual content, users may find it intimidating. In that case, it is very likely that package searchers skip your package without reading the README. Place visual content such as images, gifs, movs close to the beginning of the README, so that users can easily find them and use them. (Movs or gifs are even better than static images!) 

See the example below to see how the visual contents made the README look better (right) than before (left). 



<p id="gdcalert3" ><span style="color: red; font-weight: bold">>>>>  GDC alert: inline image link here (to images/image3.png). Store image on your image server and adjust path/filename/extension if necessary. </span><br>(<a href="#">Back to top</a>)(<a href="#gdcalert4">Next alert</a>)<br><span style="color: red; font-weight: bold">>>>> </span></p>


![alt_text](images/image3.png "image_tooltip")


<p id="gdcalert4" ><span style="color: red; font-weight: bold">>>>>  GDC alert: inline image link here (to images/image4.png). Store image on your image server and adjust path/filename/extension if necessary. </span><br>(<a href="#">Back to top</a>)(<a href="#gdcalert5">Next alert</a>)<br><span style="color: red; font-weight: bold">>>>> </span></p>


![alt_text](images/image4.png "image_tooltip")


_In\_app\_purchase README without (left) and with (right) images_


```
ⓘNote: When adding visual contents, make sure that you use absolute URLs for the files, so that they'll work no matter where the README is published. One place to host your images is in the repository itself. For example, here's where in_app_purchases hosts its animated gifs.
```


If your package supports complex concepts, utilize diagrams that explain the package, so that your users can quickly understand the package and feel confident about using it. 



3. Use lists to present key information

Use lists to draw attention to important information on your README. This section suggests to utilize lists for the followings:



*   Key features of the package
*   Parameters, attributes, or properties
*   Unusual requirements 
*   Things that are out of scope of your package
*   Content of longer pages or sections (just like this list)


#### List key features of the package 

First of all, clearly list what your package can do. Some users might be looking for a very specific feature in your package. Help those users find out whether your package supports their needs or not. You may use tables, too.



<p id="gdcalert5" ><span style="color: red; font-weight: bold">>>>>  GDC alert: inline image link here (to images/image5.png). Store image on your image server and adjust path/filename/extension if necessary. </span><br>(<a href="#">Back to top</a>)(<a href="#gdcalert6">Next alert</a>)<br><span style="color: red; font-weight: bold">>>>> </span></p>


![alt_text](images/image5.png "image_tooltip")


_List of features of the package [in\_app\_purchase](https://pub.dev/packages/in_app_purchase)_



<p id="gdcalert6" ><span style="color: red; font-weight: bold">>>>>  GDC alert: inline image link here (to images/image6.png). Store image on your image server and adjust path/filename/extension if necessary. </span><br>(<a href="#">Back to top</a>)(<a href="#gdcalert7">Next alert</a>)<br><span style="color: red; font-weight: bold">>>>> </span></p>


![alt_text](images/image6.png "image_tooltip")


_Features of the package [just\_audio](https://pub.dev/packages/just_audio)_


#### List parameters, attributes, or properties

You can also consider listing parameters, attributes, or properties for their quick reference. See the example below.



<p id="gdcalert7" ><span style="color: red; font-weight: bold">>>>>  GDC alert: inline image link here (to images/image7.png). Store image on your image server and adjust path/filename/extension if necessary. </span><br>(<a href="#">Back to top</a>)(<a href="#gdcalert8">Next alert</a>)<br><span style="color: red; font-weight: bold">>>>> </span></p>


![alt_text](images/image7.png "image_tooltip")


_List of supported schemes of the package [url\_launcher](https://pub.dev/packages/url_launcher#supported-url-schemes)_

Linking specific functions or classes to those in dartdoc can be useful too. See [async](https://pub.dev/packages/async) package for an example of linking dartdocs.


#### List unusual requirements 

Listing requirements that are out of the scope of ordinary instructions is a good idea, too.



<p id="gdcalert8" ><span style="color: red; font-weight: bold">>>>>  GDC alert: inline image link here (to images/image8.png). Store image on your image server and adjust path/filename/extension if necessary. </span><br>(<a href="#">Back to top</a>)(<a href="#gdcalert9">Next alert</a>)<br><span style="color: red; font-weight: bold">>>>> </span></p>


![alt_text](images/image8.png "image_tooltip")


_Additional instructions to use [google\_maps\_flutter](https://pub.dev/packages/google_maps_flutter)._


#### List things out of scope of your package

Listing things that are out of scope for your package is another good idea. For example, if you decide that your button package is only focused on text buttons and not on icon buttons, make it clear in the README. If your package only supports Android from a certain version, make sure the readers know about it.


#### List content if necessary for longer pages or sections

Users will find it easier to navigate a section, when there’s a table of content. If a section in your README is very long, consider listing the subsections clearly at the beginning of the section. 



<p id="gdcalert9" ><span style="color: red; font-weight: bold">>>>>  GDC alert: inline image link here (to images/image9.png). Store image on your image server and adjust path/filename/extension if necessary. </span><br>(<a href="#">Back to top</a>)(<a href="#gdcalert10">Next alert</a>)<br><span style="color: red; font-weight: bold">>>>> </span></p>


![alt_text](images/image9.png "image_tooltip")


_Content of the “Usage” section of the package [in\_app\_purchase](https://pub.dev/packages/in_app_purchase)_



4. Include at least one usage example

If your package looks promising, users will want to test your package. Include a “Get started” or “Usage” section and include at least one code sample that users can easily understand, and ideally, copy and paste into their project. It’s even better if you can provide more examples with more details to help users to understand your package. 

Remember that not all users speak English, but they all speak Dart! Good code samples can go a long way. Consider adding more complete examples in example/example.dart as well. 



<p id="gdcalert10" ><span style="color: red; font-weight: bold">>>>>  GDC alert: inline image link here (to images/image10.png). Store image on your image server and adjust path/filename/extension if necessary. </span><br>(<a href="#">Back to top</a>)(<a href="#gdcalert11">Next alert</a>)<br><span style="color: red; font-weight: bold">>>>> </span></p>


![alt_text](images/image10.png "image_tooltip")


_Sample code of the package [in\_app\_purchase](https://pub.dev/packages/in_app_purchase)_



5. Use Dart code formatting

When adding code examples, use three backticks + dart (```dart) instead of three backticks (```). It will do the correct Dart syntax highlighting for your code examples.



<p id="gdcalert11" ><span style="color: red; font-weight: bold">>>>>  GDC alert: inline image link here (to images/image11.png). Store image on your image server and adjust path/filename/extension if necessary. </span><br>(<a href="#">Back to top</a>)(<a href="#gdcalert12">Next alert</a>)<br><span style="color: red; font-weight: bold">>>>> </span></p>


![alt_text](images/image11.png "image_tooltip")




<p id="gdcalert12" ><span style="color: red; font-weight: bold">>>>>  GDC alert: inline image link here (to images/image12.png). Store image on your image server and adjust path/filename/extension if necessary. </span><br>(<a href="#">Back to top</a>)(<a href="#gdcalert13">Next alert</a>)<br><span style="color: red; font-weight: bold">>>>> </span></p>


![alt_text](images/image12.png "image_tooltip")


(Replace the above with the actual syntax highlights)



6. Mention terms that people might use to search for

In the recent UX study, we found that many users use the within-page search feature (ctrl+F or cmd+F) to search for the feature they are looking for. Thus, be sure to mention the key terms in the README, so that users can find them. 

For instance, users might want to know whether the in\_app\_purchase package supports in app subscription. Users may search for the keyword “subscription”, and they might abandon the page if there’s no “subscription” highlighted.



<p id="gdcalert13" ><span style="color: red; font-weight: bold">>>>>  GDC alert: inline image link here (to images/image13.png). Store image on your image server and adjust path/filename/extension if necessary. </span><br>(<a href="#">Back to top</a>)(<a href="#gdcalert14">Next alert</a>)<br><span style="color: red; font-weight: bold">>>>> </span></p>


![alt_text](images/image13.png "image_tooltip")


_The keyword will be highlighted when users search for it within the page_

After that, be consistent with using such terms. If needed, clearly define them. In the package [in\_app\_purchase](https://pub.dev/packages/in_app_purchase), the meaning of “underlying store” is presented at the beginning, and the term is used consistently in the page.



<p id="gdcalert14" ><span style="color: red; font-weight: bold">>>>>  GDC alert: inline image link here (to images/image14.png). Store image on your image server and adjust path/filename/extension if necessary. </span><br>(<a href="#">Back to top</a>)(<a href="#gdcalert15">Next alert</a>)<br><span style="color: red; font-weight: bold">>>>> </span></p>


![alt_text](images/image14.png "image_tooltip")


_The meaning of “underlying store”_



<p id="gdcalert15" ><span style="color: red; font-weight: bold">>>>>  GDC alert: inline image link here (to images/image15.png). Store image on your image server and adjust path/filename/extension if necessary. </span><br>(<a href="#">Back to top</a>)(<a href="#gdcalert16">Next alert</a>)<br><span style="color: red; font-weight: bold">>>>> </span></p>


![alt_text](images/image15.png "image_tooltip")


_The term “underlying store” is used consistently across the page_



7. Tell users where they can go next

Tell users where they can go next to seek help. It may be an issue tracker, a chat room, or an email address.

Tell users how they can contribute code to the package.

Tell users where they can find more about the package. You many link to your article on Medium, video on YouTube, etc.

Tell users about your roadmap, or where they can find a roadmap. Users might want to know if the feature they need is coming soon or not.   \




<p id="gdcalert16" ><span style="color: red; font-weight: bold">>>>>  GDC alert: inline image link here (to images/image16.png). Store image on your image server and adjust path/filename/extension if necessary. </span><br>(<a href="#">Back to top</a>)(<a href="#gdcalert17">Next alert</a>)<br><span style="color: red; font-weight: bold">>>>> </span></p>


![alt_text](images/image16.png "image_tooltip")


_How to contribute to [in\_app\_purchase](https://pub.dev/packages/in_app_purchase)_


## Learn more about good README authoring

We’ve suggested seven tips for good README in this documentation. You can learn more about common recommendations for developer docs from the [Google Developer Documentation Style Guide](https://developers.google.com/style/highlights). Some additional tips include:  



*   Supply alt text for images.
*   Be succinct. Don't say please.
*   Keep line length &lt; 80 chars.
*   Format code correctly (as dartfmt or flutter format would format it).

You may also use the following resources to learn more about good README:



*   https://github.com/ddbeck/readme-checklist/blob/main/checklist.md (Checklist for a good readme)
*   https://github.com/matiassingers/awesome-readme (Examples of a good readme)
*   https://www.makeareadme.com/ (Suggestions for a good readme)
*   https://dbader.org/blog/write-a-great-readme-for-your-github-project (With a link to a template)

The suggestions here may not work for all the packages. Be creative! Put yourself into users’ shoes and imagine what the readers will want to read and know. You’re the only person who can provide information the readers need.

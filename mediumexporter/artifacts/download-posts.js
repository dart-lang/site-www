(async () => {
    const links = [
        "https://blog.dart.dev/announcing-dart-3-10-ea8b952b6088",
        "https://blog.dart.dev/google-summer-of-code-2025-results-596cf0a43422",
        "https://blog.dart.dev/announcing-dart-3-9-ba49e8f38298",
        "https://blog.dart.dev/announcing-dart-3-8-724eaaec9f47",
        "https://blog.dart.dev/gemini-for-dartpad-ca962729cee6",
        "https://blog.dart.dev/dart-in-google-summer-of-code-2025-b6373bdb7a08",
        "https://blog.dart.dev/announcing-dart-3-7-bf864a1b195c",
        "https://blog.dart.dev/an-update-on-dart-macros-data-serialization-06d3037d4f12",
        "https://blog.dart.dev/announcing-dart-3-6-778dd7a80983",
        "https://blog.dart.dev/google-summer-of-code-2024-results-ae925357d2d7",
        "https://blog.dart.dev/dart-3-5-6ca36259fa2f",
        "https://blog.dart.dev/dart-3-4-bd8d23b4462a",
        "https://blog.dart.dev/history-of-js-interop-in-dart-98b06991158f",
        "https://blog.dart.dev/dart-in-google-summer-of-code-2024-8ca45fb6dc4e",
        "https://blog.dart.dev/dart-3-3-325bf2bf6c13",
        "https://blog.dart.dev/dart-3-2-c8de8fe1b91f",
        "https://blog.dart.dev/dart-3-1-a-retrospective-on-functional-style-programming-in-dart-3-a1f4b3a7cdda",
        "https://blog.dart.dev/dart-devtools-analyzing-application-performance-with-the-cpu-profiler-3e94a0ec06ae",
        "https://blog.dart.dev/announcing-dart-3-53f065a10635",
        "https://blog.dart.dev/introducing-realm-for-dart-flutter-e30cb05eb313",
        "https://blog.dart.dev/dart-3-alpha-f1458fb9d232",
        "https://blog.dart.dev/better-isolate-management-with-isolate-run-547ef3d6459b",
        "https://blog.dart.dev/screenshots-and-automated-publishing-for-pub-dev-9bceb19edf79",
        "https://blog.dart.dev/the-road-to-dart-3-afdd580fbefa",
        "https://blog.dart.dev/google-summer-of-code-2022-results-a3ce1c13c06c",
        "https://blog.dart.dev/partnering-with-github-on-an-supply-chain-security-485eed1fc388",
        "https://blog.dart.dev/dart-2-18-f4b3101f146c",
        "https://blog.dart.dev/quick-assists-for-editing-453f051fb28c",
        "https://blog.dart.dev/dart-2-17-b216bfc80c5d",
        "https://blog.dart.dev/bulk-application-of-fixes-e6add333c3c1",
        "https://blog.dart.dev/dart-asynchronous-programming-streams-dab952023ed7",
        "https://blog.dart.dev/contributors-for-google-summer-of-code-2022-17e777f043f0",
        "https://blog.dart.dev/gradual-null-safety-migration-for-large-dart-projects-85acb10b64a9",
        "https://blog.dart.dev/hosting-a-private-dart-package-repository-774c3c51dff9",
        "https://blog.dart.dev/quick-fixes-for-analysis-issues-c10df084971a",
        "https://blog.dart.dev/dart-2-16-improved-tooling-and-platform-handling-dd87abd6bad1",
        "https://blog.dart.dev/dart-2-15-7e7a598e508a",
        "https://blog.dart.dev/announcing-package-support-for-dartpad-66a4b415970b",
        "https://blog.dart.dev/dart-diagnostic-messages-ae302aa398e8",
        "https://blog.dart.dev/google-summer-of-code-2021-results-e514cce50fc",
        "https://blog.dart.dev/announcing-dart-2-14-b48b9bb2fb67",
        "https://blog.dart.dev/experimenting-with-dart-and-wasm-ef7f1c065577",
        "https://blog.dart.dev/how-darts-null-safety-helped-me-augment-my-projects-af58f8129cf",
        "https://blog.dart.dev/implementing-structs-by-value-in-dart-ffi-1cb1829d11a9",
        "https://blog.dart.dev/announcing-dart-2-13-c6d547b57067",
        "https://blog.dart.dev/angulardart-flutter-and-the-web-spring-update-f7f5b8b10001",
        "https://blog.dart.dev/announcing-dart-support-for-github-actions-3d892642104",
        "https://blog.dart.dev/dart-in-google-summer-of-code-2021-e89eaf1d177a",
        "https://blog.dart.dev/announcing-dart-2-12-499a6e689c87",
        "https://blog.dart.dev/preparing-the-dart-and-flutter-ecosystem-for-null-safety-e550ce72c010",
        "https://blog.dart.dev/dart-and-the-performance-benefits-of-sound-types-6ceedd5b6cdc",
        "https://blog.dart.dev/why-nullable-types-7dd93c28c87a",
        "https://blog.dart.dev/announcing-dart-null-safety-beta-87610fee6730",
        "https://blog.dart.dev/announcing-dart-2-10-350823952bd5",
        "https://blog.dart.dev/exploring-collections-in-dart-f66b6a02d0b1",
        "https://blog.dart.dev/google-summer-of-code-2020-results-a38cd072c9fe",
        "https://blog.dart.dev/pub-dev-redesign-747406dcb486",
        "https://blog.dart.dev/dart-string-manipulation-done-right-5abd0668ba3e",
        "https://blog.dart.dev/announcing-sound-null-safety-defd2216a6f3",
        "https://blog.dart.dev/3-cool-dart-patterns-6d8d9d3d8fb8",
        "https://blog.dart.dev/announcing-dart-2-8-7750918db0a",
        "https://blog.dart.dev/students-join-a-dart-project-for-google-summer-of-code-2020-655d39b557c2",
        "https://blog.dart.dev/dart-asynchronous-programming-streams-2569a993324d",
        "https://blog.dart.dev/dart-declaration-site-variance-5c0e9c5f18a5",
        "https://blog.dart.dev/life-as-a-dart-intern-a62cb8db2414",
        "https://blog.dart.dev/dart-2-7-a3710ec54e97",
        "https://blog.dart.dev/a-brand-new-dartpad-dev-with-flutter-support-16fe6027784",
        "https://blog.dart.dev/dart2native-a76c815e6baf",
        "https://blog.dart.dev/extension-methods-2d466cd8b308",
        "https://blog.dart.dev/verified-publishers-98f05466558a",
        "https://blog.dart.dev/dart-asynchronous-programming-futures-96937f831137",
        "https://blog.dart.dev/announcing-dart-2-5-super-charged-development-328822024970",
        "https://blog.dart.dev/dart-nullability-syntax-decision-a-b-or-a-b-d827259e34a3",
        "https://blog.dart.dev/dart-asynchronous-programming-isolates-and-event-loops-bffc3e296a6a",
        "https://blog.dart.dev/pedantic-dart-1c7d365510de",
        "https://blog.dart.dev/announcing-dart-2-3-optimized-for-building-user-interfaces-e84919ca1dff",
        "https://blog.dart.dev/announcing-windows-support-for-dart-on-travis-ci-8160f53662f",
        "https://blog.dart.dev/making-dart-a-better-language-for-ui-f1ccaf9f546c",
        "https://blog.dart.dev/announcing-dart-2-2-faster-native-code-support-for-set-literals-7e2ab19cc86d",
        "https://blog.dart.dev/announcing-dart-2-1-improved-performance-usability-9f55fca6f31a",
        "https://blog.dart.dev/future-void-vs-future-null-whats-the-difference-84a42d616e7d",
        "https://blog.dart.dev/improved-discovery-on-the-dart-package-site-9bfe24c3d7d3",
        "https://blog.dart.dev/dart-2-legacy-of-the-void-e7afb5f44df0",
        "https://blog.dart.dev/dart-2-stable-and-the-dart-web-platform-3775d5f8eac7",
        "https://blog.dart.dev/getting-ready-for-dart-2-and-making-your-packages-look-great-on-the-pub-site-118464d7f59d",
        "https://blog.dart.dev/announcement-ide-tooling-for-angulardart-5-de01ecccec9d",
        "https://blog.dart.dev/announcing-official-grpc-support-for-dart-6c9b50357af6",
        "https://blog.dart.dev/announcing-dart-2-80ba01f43b6",
        "https://blog.dart.dev/annotate-once-angulardart-825479b1e78f",
        "https://blog.dart.dev/building-data-binding-in-the-browser-f523c99de79c",
        "https://blog.dart.dev/moving-fast-with-dart-immutable-values-1e717925fafb",
        "https://blog.dart.dev/dart-gets-a-type-system-6bd3121772de",
        "https://blog.dart.dev/an-intro-to-immutability-with-dart-d4de871865c7",
        "https://blog.dart.dev/evolving-dart-repl-poc-233440a35e1f",
        "https://blog.dart.dev/making-a-dart-web-app-offline-capable-3-lines-of-code-e980010a7815",
        "https://blog.dart.dev/google-maps-with-angulardart-a75f7f84f941",
        "https://blog.dart.dev/dart-repl-poc-f327e3769b6f",
        "https://blog.dart.dev/dart-on-llvm-b82e83f99a70",
        "https://blog.dart.dev/building-a-chat-app-in-dart-815fcd0e5a31",
        "https://blog.dart.dev/darts-built-value-for-serialization-f5db9d0f4159",
        "https://blog.dart.dev/darts-built-value-for-immutable-object-models-83e2497922d4",
        "https://blog.dart.dev/darts-built-collection-for-immutable-collections-db662f705eff",
        "https://blog.dart.dev/stagexl-1-0-a9c5ff22a534",
        "https://blog.dart.dev/why-i-m-joining-the-dart-team-of-all-places-d0b9f83a3b66"
    ];

    const download = (content, filename) => {
        const blob = new Blob([content], { type: 'application/json' });
        const url = URL.createObjectURL(blob);
        const a = document.createElement('a');
        a.href = url;
        a.download = filename;
        document.body.appendChild(a);
        a.click();
        document.body.removeChild(a);
        URL.revokeObjectURL(url);
    };

    for (let i = 0; i < links.length; i++) {
        const url = links[i] + "?format=json";
        const filename = links[i].split('/').pop() + ".json";
        console.log(`[${i + 1}/${links.length}] Fetching ${filename}...`);

        try {
            const resp = await fetch(url);
            let text = await resp.text();
            const prefix = "])}while(1);</x>";
            if (text.startsWith(prefix)) {
                text = text.substring(prefix.length);
            }
            // Double check it's valid JSON
            JSON.parse(text);
            download(text, filename);
        } catch (e) {
            console.error(`Failed to download ${filename}:`, e);
        }

        // Wait 1 second between downloads
        await new Promise(r => setTimeout(r, 1000));
    }
    console.log("Finished!");
})();